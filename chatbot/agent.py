# NOTE: This module uses Gemini for now, until we can get the fine-tuned model.

import asyncio, logging, os
from datetime import datetime, timezone
from typing import Annotated
from typing_extensions import TypedDict
from pydantic import BaseModel, Field

from dotenv import load_dotenv

from graphiti_core import Graphiti
from graphiti_core.edges import EntityEdge
from graphiti_core.nodes import EpisodeType
from graphiti_core.llm_client.gemini_client import GeminiClient, LLMConfig
from graphiti_core.embedder.gemini import GeminiEmbedder, GeminiEmbedderConfig
from graphiti_core.search.search_config_recipes import COMBINED_HYBRID_SEARCH_MMR, NODE_HYBRID_SEARCH_EPISODE_MENTIONS

from langchain_core.messages import AIMessage, SystemMessage
from langchain_core.tools import tool
from langchain_google_genai import ChatGoogleGenerativeAI
from langgraph.graph import END, START, StateGraph, add_messages
from langgraph.prebuilt import ToolNode
from langgraph.checkpoint.redis import AsyncRedisSaver
from langgraph.checkpoint.memory import MemorySaver

from therapy_chatbot import settings

load_dotenv(dotenv_path="../.env")

"""
Current Problems:
- For some reason, it knows the user's UUID, but can't get the 
  user's name despite both pieces of information being stored and served in the same way.
- Minor: The agent will either excessively use the search conversation tool, 
  or only use it with specific prompts. Nothing inbetween.

Other enhancements to look into:
- API calls to the LLM may become excessive as the conversation advances
- More custom entity types
- Building and periodically refreshing graph communities
- Optimized search recipe(s)
- This implementation is tied to a single Redis database
    - Langgraph checkpoints may not be cleared properly at the moment.
- Not grabbing user node as soon as the first nodes are created.
  Possibly related to the latter problem above.
    - Define tools with more descriptive schemas.
"""

NODE_SEARCH_LIMIT = 5

# Configure time-to-live for checkpoint savers.
TTL_CONFIG = {
    "default_ttl": 1440, # Default TTL in minutes (1440 min = 24 hr).
    "refresh_on_read": True, # Refresh TTL when checkpoint is read.
}

redis_checkpointer_url = os.environ.get("REDIS_URL", "redis://localhost:6379")
if not redis_checkpointer_url:
    raise ValueError("REDIS_URL environment variable must be set.")

neo4j_uri = os.environ.get('NEO4J_URI', 'bolt://localhost:7687')
neo4j_user = os.environ.get('NEO4J_USER', 'neo4j')
neo4j_password = os.environ.get('NEO4J_PASSWORD', 'neo4j_pswd')
if not neo4j_uri or not neo4j_user or not neo4j_password:
    raise ValueError('NEO4J_URI, NEO4J_USER, and NEO4J_PASSWORD must be set.')

api_key = os.environ.get("GOOGLE_API_KEY")
if not api_key:
    raise ValueError("GOOGLE_API_KEY environment variable must be set.")

graphiti = Graphiti(
    neo4j_uri, 
    neo4j_user, 
    neo4j_password,
    llm_client=GeminiClient(
        config=LLMConfig(
            api_key=api_key,
            model="gemini-2.0-flash"
        )
    ),
    embedder=GeminiEmbedder(
        config=GeminiEmbedderConfig(
            api_key=api_key,
            embedding_model="gemini-embedding-001"
        )
    )
)

def setup_logging():
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.DEBUG if settings.DEBUG else logging.ERROR)
    # console_handler = logging.StreamHandler(sys.stdout)
    # console_handler.setLevel(logging.DEBUG)
    # formatter = logging.Formatter('%(name)s - %(levelname)s - %(message)s')
    # console_handler.setFormatter(formatter)
    # logger.addHandler(console_handler)
    return logger

logger = setup_logging()

# https://help.getzep.com/graphiti/graphiti/searching#configurable-search-strategies
# Do not use cross-encoder recipes unless an OpenAI API key is available and configured.
node_search_config = COMBINED_HYBRID_SEARCH_MMR.model_copy(deep=True)
node_search_config.limit = NODE_SEARCH_LIMIT

# Tools must have docstrings.

# @tool
# async def test_tool():
#     """A test tool."""
#     logger.info("THIS IS AN INVOCATION OF THE TEST TOOL.")

# @tool
# async def echo_tool(value: str) -> str:
#     """Echoes `value` verbatim."""
#     logger.info("THIS IS AN INVOCATION OF THE ECHO TOOL.")
#     return value

@tool
async def get_latest_journal_entry():
    """Tool currently unavailable. Do not use."""
    raise NotImplementedError()

@tool
async def search_conversation(query: str) -> str:
    """Search for information relevant to the conversation, where `query` contains keywords."""
    # `user_account_uuid` will be injected by the wrapper.
    raise NotImplementedError("This tool must be wrapped to inject `user_account_uuid`.")

async def search_conversation_with_context(query, state):
    user_account_uuid = state['user_account_uuid']
    edge_results = (await graphiti.search_(
        query=query,
        config=node_search_config,
        group_ids=[augment_account_uuid(user_account_uuid)]
    )).edges
    return edges_to_facts_string(edge_results)

# Custom ToolNode that injects state.
class ToolNodeWithContext(ToolNode):
    async def ainvoke(self, state, *args, **kwargs):
        last_message = state['messages'][-1]
        
        logger.debug(f"Tools invoked: {last_message.tool_calls}")
        
        results = []
        if last_message.tool_calls:
            for call in last_message.tool_calls:
                match call['name']:
                    case "search_conversation":
                        query = call['args']['query']
                        result = await search_conversation_with_context(query, state)
                        results.append(AIMessage(content=result))
        state['messages'].pop() # Remove the empty-content tool call AIMessage object...
        # It causes issues for Gemini.
        state['messages'] += results

# tools = [test_tool, echo_tool]
# tool_node = ToolNode(tools)
tools = [search_conversation]
tool_node = ToolNodeWithContext(tools)

llm = ChatGoogleGenerativeAI(model='gemini-2.0-flash', temperature=0).bind_tools(tools)

class User(BaseModel):
    real_name: str | None = Field(..., description="The name of the user.")
    account_uuid: str | None = Field(..., description="The user's account UUID.")

entity_types = {"User": User}

def augment_account_uuid(user_account_uuid):
    return f"user_{user_account_uuid}"

async def create_user(name, user_account_uuid):
    await graphiti.add_episode(
        name="User Creation",
        episode_body=f"\"{name}\" is the name of the user interacting with this chatbot. Their account UUID is {user_account_uuid}.",
        source=EpisodeType.text,
        reference_time=datetime.now(timezone.utc),
        source_description="system",
        group_id=augment_account_uuid(user_account_uuid),
        entity_types=entity_types
    )

async def get_user_node(name, account_uuid):
    try:
        return (await graphiti.search_(
            query=f"Real Name: {name}, Account UUID: {account_uuid}", 
            config=NODE_HYBRID_SEARCH_EPISODE_MENTIONS, 
            group_ids=[augment_account_uuid(account_uuid)]
        )).nodes[0].uuid
    except Exception as e:
        logger.error(f"MINOR ERROR DETAILS: {e}")
        return "no uuid found"

def edges_to_facts_string(entities: list[EntityEdge]):
    return '- ' + '\n- '.join([edge.fact for edge in entities])

class State(TypedDict):
    messages: Annotated[list, add_messages]
    user_name: str
    user_node_uuid: str
    user_account_uuid: str

async def chatbot(state: State):
    facts_string = None
    if len(state['messages']) > 0:
        last_message = state['messages'][-1]
        
        logger.debug(f"Agent Input: {last_message}")
        
        graphiti_query = f'{"Chatbot" if isinstance(last_message, AIMessage) else state["user_name"]}: {last_message.content}'

        # Search graphiti using the user's node UUID as the center node.
        # Graph edges (facts) further from the user node will be ranked lower.
        edge_results = (await graphiti.search_(
            query=graphiti_query, 
            center_node_uuid=state['user_node_uuid'], 
            config=node_search_config,
            group_ids=[augment_account_uuid(state['user_account_uuid'])]
        )).edges
        facts_string = edges_to_facts_string(edge_results)

    system_message = SystemMessage(
#         content=f"""You are a casual chatbot that talks to users about whatever. Review information about the user and their prior conversation below and respond accordingly.
# Keep responses short and concise. Always be a friend. NEVER REPLY WITH NO CONTENT, a thumbs up is the minimum.

# Facts about the user and their conversation:
# {facts_string or 'No facts about the user and their conversation yet.'}"""
        content=f"""You are a chatbot currently under development. Only developers will be talking with you.
Review information about the prior conversation below and respond accordingly.
Keep responses short and concise. NEVER REPLY WITH NO CONTENT, a thumbs up is the minimum.

Facts about the conversation:
{facts_string or 'No facts about the conversation yet.'}"""
    )

    messages = [system_message] + state['messages']

    response = await llm.ainvoke(messages)

    # Add the response to the Graphiti graph.
    # This will allow us to use the Graphiti search later in the conversation.
    # We're doing async here to avoid blocking the graph execution.
    asyncio.create_task(
        graphiti.add_episode(
            name='Chatbot Response',
            episode_body=f'{state["user_name"]}: {state["messages"][-1].content}\nChatbot: {response.content}',
            source=EpisodeType.message,
            reference_time=datetime.now(timezone.utc),
            source_description='Chatbot',
            group_id=augment_account_uuid(state['user_account_uuid'])
        )
    )
    return {'messages': [response]}

graph_builder = StateGraph(State)
# Memory will be initialized in main.

# Define the function that determines whether or not to continue.
async def should_continue(state, config):
    messages = state['messages']
    # logger.debug(f"All Current Messages: {messages}")
    last_message = messages[-1]
    # If there is no function call, then we finish.
    if not last_message.tool_calls:
        logger.debug("Skipping tool invocation.")
        return "end"
    # Otherwise if there is, we continue.
    else:
        logger.debug(f"Invoking tool(s): {last_message.tool_calls}")
        return "continue"
graph_builder.add_node('agent', chatbot)
graph_builder.add_node('tools', tool_node)
graph_builder.add_edge(START, 'agent')
graph_builder.add_conditional_edges('agent', should_continue, {'continue': 'tools', 'end': END})
graph_builder.add_edge('tools', 'agent')
graph = None # Set in main.

async def process_input(user_state: State, user_input: str):
    graph_state = {
        'messages': [{'role': 'user', 'content': user_input}],
        'user_name': user_state['user_name'],
        'user_node_uuid': user_state['user_node_uuid'],
        'user_account_uuid': user_state['user_account_uuid']
    }
    
    config = {'configurable': {'thread_id': user_state['user_account_uuid']}}

    try:
        # Requires `REDIS_URL` environment variable even if it was already provided.
        async for event in graph.astream(
            graph_state,
            config=config,
        ):
            for value in event.values():
                if value is None:
                    continue
                
                logger.debug(f"Event Value: {value}")
                
                if 'messages' in value:
                    last_message = value['messages'][-1]
                    
                    if isinstance(
                        last_message, AIMessage
                    ) and isinstance(
                        last_message.content, str
                    ) and last_message.content:
                        yield last_message.content
    except Exception as e:
        logger.error(f'CRITICAL ERROR DETAILS: {e}')
        yield "SYSTEM: The chatbot experienced a critical error."

# For async operations which take place during initialization and possibly persist.
async def main():
    global graph
    
    if os.environ.get("USE_IN_MEMORY_SAVER") or os.environ.get("IDX_CHANNEL"):
        checkpointer = MemorySaver()
        graph = graph_builder.compile(checkpointer=checkpointer)
    else:
        async with AsyncRedisSaver.from_conn_string(
            redis_checkpointer_url, ttl=TTL_CONFIG
        ) as checkpointer:
            graph = graph_builder.compile(checkpointer=checkpointer)
    logger.info("Agent initialized.")

asyncio.run(main())
