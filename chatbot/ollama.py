import os

from graphiti_core import Graphiti
from graphiti_core.llm_client.config import LLMConfig
from graphiti_core.llm_client.openai_generic_client import OpenAIGenericClient
from graphiti_core.embedder.openai import OpenAIEmbedder, OpenAIEmbedderConfig
from graphiti_core.cross_encoder.openai_reranker_client import OpenAIRerankerClient

endpoint = os.environ.get("OLLAMA_ENDPOINT")
if not endpoint:
    raise ValueError("OLLAMA_ENDPOINT environment variable must be set.")

# Graphiti requires some modification to the Ollama endpoint, 
# but the original `endpoint` is used directly by `ChatOllama`.
graphiti_ollama_endpoint = endpoint + ("v1" if endpoint.endswith("/") else "/v1")

llm_config = LLMConfig(
    api_key="ollama", # Placeholder API key.
    model="deepseek-r1:7b",
    small_model="deepseek-r1:7b",
    base_url=graphiti_ollama_endpoint, # OpenAI-compatible endpoint.
)

llm_client = OpenAIGenericClient(config=llm_config)

graphiti = None

def ollama_init(neo4j_uri, neo4j_user, neo4j_password):
    global graphiti
    graphiti = Graphiti(
        neo4j_uri,
        neo4j_user,
        neo4j_password,
        llm_client=llm_client,
        embedder=OpenAIEmbedder(
            config=OpenAIEmbedderConfig(
                api_key="ollama", # Placeholder API key.
                embedding_model="nomic-embed-text",
                embedding_dim=768,
                base_url=graphiti_ollama_endpoint,
            )
        ),
        cross_encoder=OpenAIRerankerClient(client=llm_client, config=llm_config),
    )
