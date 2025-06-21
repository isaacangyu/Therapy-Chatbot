from channels.generic.websocket import WebsocketConsumer
from asgiref.sync import async_to_sync

from core.models import Account, Session
from core.utils import app_ws_in, ws_process_out

# Note: Status code 0 indicates success.

class ChatbotConsumer(WebsocketConsumer):
    def connect(self):
        self.accept()
    
    def disconnect(self, close_code):
        if hasattr(self, "user_email"):
            async_to_sync(self.channel_layer.group_discard)(
                self.user_email, self.channel_name
            )
    
    @app_ws_in
    def receive(self, json_data):
        if "type" not in json_data:
            ws_process_out(self, {"status": 1})
            return
        frame_type = json_data["type"]
        if frame_type == "connect":
            self.user_email = json_data.get("_email")
            self.account = Account.objects.get(email=self.user_email)
            self.session = Session.objects.get(token=json_data.get("_token"))
            if self.account != self.session.account:
                self.close(code=3003)
                return
            async_to_sync(self.channel_layer.group_add)(
                self.user_email, self.channel_name
            )
            ws_process_out(self, {"status": 0})
        elif frame_type == "message":
            message = json_data.get("message")
            if message is None:
                ws_process_out(self, {"status": 2})
                return
            
            # Get response from Graphiti + others here.
            
            async_to_sync(self.channel_layer.group_send)(
                self.user_email, {
                    "type": "chatbot.response", 
                    "response": {"user": message, "chatbot": f"Echo: {message}"}
                }
            )
        else:
            ws_process_out(self, {"status": 3})
    
    def chatbot_response(self, event):
        response = event["response"]
        ws_process_out(self, {"status": 0, "response": response})
