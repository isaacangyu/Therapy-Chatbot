import enum

from django.db import models

from core.models import Account

class Conversation(models.Model):
    account = models.ForeignKey(
        Account, on_delete=models.CASCADE, related_name="conversations"
    )
    creation_date    = models.DateTimeField(auto_now_add=True)
    termination_date = models.DateTimeField(null=True, blank=True)
    
    def add_user_message(self, message_encrypted):
        message_store = Message.objects.create(
            session=self, sender=Message.Sender.USER, encrypted_content=message_encrypted.encode()
        )
        message_store.save()
    
    def add_chatbot_reply(self, reply_encrypted):
        reply_store = Message.objects.create(
            session=self, sender=Message.Sender.CHATBOT, encrypted_content=reply_encrypted.encode()
        )
        reply_store.save()

    def __str__(self):
        return f"{self.account} ({self.creation_date})"
    
class Message(models.Model):
    class Sender(enum.Enum):
        USER = "u"
        CHATBOT = "m"
    
    session           = models.ForeignKey(Conversation, on_delete=models.CASCADE, related_name="messages")
    sender            = models.CharField(choices=[(Sender.USER, "user"), (Sender.CHATBOT, "chatbot")])
    encrypted_content = models.BinaryField()
    timestamp         = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"{self.sender} ({self.timestamp})"
