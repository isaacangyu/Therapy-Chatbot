from django.contrib import admin

from chatbot.models import Conversation, Message

admin.site.register(Conversation)
admin.site.register(Message)
