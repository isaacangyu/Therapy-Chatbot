from channels.generic.websocket import AsyncWebsocketConsumer
from asgiref.sync import sync_to_async #, async_to_sync
from channels.db import database_sync_to_async

from core.models import Account, Session
from core.utils import app_ws_in, ws_process_out

from chatbot import agent
from chatbot.models import Conversation

# Note: Status code 0 indicates success.

class ChatbotConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        await self.accept()
    
    async def disconnect(self, close_code):
        if hasattr(self, "user_email"):
            await self.channel_layer.group_discard(
                self.account.id.hex, self.channel_name
            )
    
    @app_ws_in
    async def receive(self, json_data):
        if "type" not in json_data:
            await ws_process_out(self, {"status": 1})
            return
        frame_type = json_data["type"]
        if frame_type == "connect":
            self.account = await database_sync_to_async(lambda: Account.objects.get(email=json_data.get("_email")))()
            self.session = await database_sync_to_async(lambda: Session.objects.get(token=json_data.get("_token")))()
            if await sync_to_async(lambda: self.account != self.session.account)():
                self.close(code=3003)
                return
            self.authenticated = True
            
            await first_time_create_agent_user(self.account)
            
            await self.channel_layer.group_add(
                self.account.id.hex, self.channel_name
            )
            await ws_process_out(self, {"status": 0})
        elif frame_type == "message":
            if not self.authenticated:
                await self.close(code=3003)
                return

            message = json_data.get("message")
            if message is None:
                await ws_process_out(self, {"status": 2})
                return
            
            chatbot_response = await agent_response(self.account, message)
            
            await self.channel_layer.group_send(
                self.account.id.hex, {
                    "type": "chatbot.response", 
                    "response": {"user": message, "chatbot": chatbot_response}
                }
            )
        else:
            await ws_process_out(self, {"status": 3})
    
    async def chatbot_response(self, event):
        response = event["response"]
        await ws_process_out(self, {"status": 0, "response": response})

async def first_time_create_agent_user(account):
    if not await database_sync_to_async(lambda: Conversation.objects.filter(account=account).exists())():
        await database_sync_to_async(lambda: Conversation.objects.create(account=account).save())()
        await agent.create_user(account.name, account.id.hex)

async def agent_response(account, prompt):
    user_node = await agent.get_user_node(account.name, account.id.hex)
    user_state = {
        'user_name': account.name,
        'user_node_uuid': user_node,
        'user_account_uuid': account.id.hex
    }
    return await agent.process_input(user_state, prompt)
