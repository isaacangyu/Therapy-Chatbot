#!/usr/bin/env -S poetry run python

import os, asyncio

from dotenv import load_dotenv

from graphiti_core.utils.maintenance.graph_data_operations import clear_data

from langgraph.checkpoint.redis import AsyncRedisSaver

load_dotenv()

redis_checkpointer_url = os.environ.get("REDIS_URL", "redis://localhost:6379")
if not redis_checkpointer_url:
    raise ValueError("REDIS_URL environment variable must be set.")

neo4j_uri = os.environ.get('NEO4J_URI', 'bolt://localhost:7687')
neo4j_user = os.environ.get('NEO4J_USER', 'neo4j')
neo4j_password = os.environ.get('NEO4J_PASSWORD', 'neo4j_pswd')
if not neo4j_uri or not neo4j_user or not neo4j_password:
    raise ValueError('NEO4J_URI, NEO4J_USER, and NEO4J_PASSWORD must be set.')

async def main():
    if os.environ.get("USE_GEMINI"):
        import chatbot.gemini
        chatbot.gemini.gemini_init(neo4j_uri, neo4j_user, neo4j_password)
        graphiti = chatbot.gemini.graphiti
    else:
        import chatbot.ollama
        chatbot.ollama.ollama_init(neo4j_uri, neo4j_user, neo4j_password)
        graphiti = chatbot.ollama.graphiti

    await graphiti.build_indices_and_constraints()
    if os.environ.get("USE_IN_MEMORY_SAVER") or os.environ.get("IDX_CHANNEL"):
        pass
    else:
        checkpointer = AsyncRedisSaver(redis_checkpointer_url)
        await checkpointer.asetup()
    print("Done.")

asyncio.run(main())
