# NOTE: This module uses Gemini for now, until we can get the fine-tuned model.

import asyncio, logging, os, sys, uuid
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

from therapy_chatbot import settings

load_dotenv()

"""
Other enhancements to look into:
- More custom entity types
- Building and periodically refreshing graph communities
- Optimized search recipe(s)
"""

NODE_SEARCH_LIMIT = 5

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
            embedding_model="embedding-001"
        )
    )
)

def setup_logging():
    logger = logging.getLogger("chatbot")
    logger.setLevel(logging.DEBUG if settings.DEBUG else logging.ERROR)
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setLevel(logging.DEBUG)
    formatter = logging.Formatter('%(name)s - %(levelname)s - %(message)s')
    console_handler.setFormatter(formatter)
    logger.addHandler(console_handler)
    return logger

logger = setup_logging()

# https://help.getzep.com/graphiti/graphiti/searching#configurable-search-strategies
# Do not use cross-encoder recipes unless an OpenAI API key is available and configured.
node_search_config = COMBINED_HYBRID_SEARCH_MMR.model_copy(deep=True)
node_search_config.limit = NODE_SEARCH_LIMIT

@tool
async def get_latest_journal_entry():
    raise NotImplementedError()

tools = [get_latest_journal_entry]
tool_node = ToolNode(tools)

llm = ChatGoogleGenerativeAI(model='gemini-2.0-flash', temperature=0).bind_tools(tools)

class User(BaseModel):
    name: str | None = Field(..., description="The name of the user.")
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
    return (await graphiti._search(
        f"{name} {account_uuid}", 
        NODE_HYBRID_SEARCH_EPISODE_MENTIONS, 
        group_ids=[augment_account_uuid(account_uuid)]
    ))[0].uuid

def edges_to_facts_string(entities: list[EntityEdge]):
    return '-' + '\n- '.join([edge.fact for edge in entities])

class State(TypedDict):
    messages: Annotated[list, add_messages]
    user_name: str
    user_node_uuid: str
    user_account_uuid: str

async def chatbot(state: State):
    facts_string = None
    if len(state['messages']) > 0:
        last_message = state['messages'][-1]
        graphiti_query = f'{"Chatbot" 
                            if isinstance(last_message, AIMessage) 
                            else state["user_name"]}: {last_message.content}'

        # Search graphiti using the user's node UUID as the center node.
        # Graph edges (facts) further from the user node will be ranked lower.
        edge_results = await graphiti._search(
            query=graphiti_query, 
            center_node_uuid=state['user_node_uuid'], 
            config=node_search_config,
            group_ids=[augment_account_uuid(state['user_account_uuid'])]
        )
        facts_string = edges_to_facts_string(edge_results)

    system_message = SystemMessage(
        content=f"""You are a casual chatbot that talks to users about whatever. Review information about the user and their prior conversation below and respond accordingly.
Keep responses short and concise. And remember, always be a friend.

Facts about the user and their conversation:
{facts_string or 'No facts about the user and their conversation yet.'}"""
    )

    messages = [system_message] + state['messages']

    response = await llm.ainvoke(messages)

    # Add the response to the Graphiti graph.
    # This will allow us to use the Graphiti search later in the conversation.
    # We're doing async here to avoid blocking the graph execution.
    asyncio.create_task(
        graphiti.add_episode(
            name='Chatbot Response',
            episode_body=f'{state["user_name"]}: {state["messages"][-1]}\nChatbot: {response.content}',
            source=EpisodeType.message,
            reference_time=datetime.now(timezone.utc),
            source_description='Chatbot',
            group_id=augment_account_uuid(state['user_account_uuid'])
        )
    )
    return {'messages': [response]}

graph_builder = StateGraph(State)
memory = 

# Define the function that determines whether to continue or not.
# async def should_continue(state, config):
#     messages = state['messages']
#     last_message = messages[-1]
#     # If there is no function call, then we finish.
#     if not last_message.tool_calls:
#         return "end"
#     # Otherwise if there is, we continue.
#     else:
#         return "continue"
graph_builder.add_node('agent', chatbot)
# graph_builder.add_node('tools', tool_node)
graph_builder.add_edge(START, 'agent')
# graph_builder.add_conditional_edges('agent', should_continue, {'continue': 'tools', 'end': END})
# graph_builder.add_edge('tools', 'agent')
graph = graph_builder.compile(checkpointer=memory)

async def process_input(user_state: State, user_input: str):
    graph_state = {
        'messages': [{'role': 'user', 'content': user_input}],
        'user_name': user_state['user_name'],
        'user_node_uuid': user_state['user_node_uuid'],
        'user_account_uuid': user_state['user_account_uuid']
    }
    
    config = {'configurable': {'thread_id': user_state['user_account_uuid']}}

    try:
        async for event in graph.astream(
            graph_state,
            config=config,
        ):
            for value in event.values():
                if 'messages' in value:
                    last_message = value['messages'][-1]
                    if isinstance(last_message, AIMessage) and isinstance(
                        last_message.content, str
                    ):
                        return last_message.content
    except Exception as e:
        logger.error(f'{e}')

# For async operations which take place during initialization.
async def main():
    logger.info("Building Graphiti indices and contraints.")
    # Can take a while according to documentation.
    await graphiti.build_indices_and_contraints()
    logger.info("Finished building.")

asyncio.run(main())
