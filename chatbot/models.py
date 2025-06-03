import enum

from django.db import models

from core.models import Account

class Conversation(models.Model):
    account = models.ForeignKey(
        Account, on_delete=models.CASCADE, related_name="conversations"
    )
    creation_date    = models.DateTimeField(auto_now_add=True)
    termination_date = models.DateTimeField(null=True, blank=True)

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
        prefix = "USER" if self.sender == Message.Sender.USER else "CHATBOT"
        return f"{prefix} ({self.timestamp})"
