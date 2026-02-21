import os

from graphiti_core import Graphiti
from graphiti_core.llm_client.gemini_client import GeminiClient, LLMConfig
from graphiti_core.embedder.gemini import GeminiEmbedder, GeminiEmbedderConfig

api_key = os.environ.get("GOOGLE_API_KEY")
if not api_key:
    raise ValueError("GOOGLE_API_KEY environment variable must be set.")

graphiti = None

def gemini_init(neo4j_uri, neo4j_user, neo4j_password):
    global graphiti
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
