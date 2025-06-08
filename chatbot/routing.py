from django.urls import re_path

from chatbot import consumers

websocket_urlpatterns = [
    re_path("ws/chatbot/", consumers.ChatbotConsumer.as_asgi()),
]
