#!/usr/bin/env python3

import os, asyncio

from dotenv import load_dotenv
from graphiti_core import Graphiti
from graphiti_core.utils.maintenance.graph_data_operations import clear_data
from graphiti_core.llm_client.gemini_client import GeminiClient, LLMConfig
from graphiti_core.embedder.gemini import GeminiEmbedder, GeminiEmbedderConfig

load_dotenv(dotenv_path="chatbot/.env")

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

async def main():
    confirm = input("Are you sure you want to clear all Graphiti data? (Y/N): ").lower()
    if confirm == "y" or confirm == "yes":
        await clear_data(graphiti.driver)
        # Can take a while according to documentation.
        await graphiti.build_indices_and_constraints()
        print("Cleared data.")
    else:
        print("Cancelled.")

asyncio.run(main())
