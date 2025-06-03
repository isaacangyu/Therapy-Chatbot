from django.db import models
from django.utils import timezone

from core.models import Account

class ChatSession(models.Model):
    account    = models.ForeignKey(Account, on_delete=models.CASCADE)
    started_at = models.DateTimeField(default=timezone.now)
    ended_at   = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return f"Session {self.id} for {self.account}"
    
class Message(models.Model):
    session   = models.ForeignKey(ChatSession, on_delete=models.CASCADE, related_name="messages")
    sender    = models.CharField(max_length=16, choices=[("user","user"),("bot","bot")])
    content   = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        prefix = "USER" if self.sender == "user" else "BOT"
        return f"{prefix} [{self.timestamp:%Y-%m-%d %H:%M}] {self.content[:50]}"

class Conversations(models.Model):
    message = models.CharField(max_length=250)
    sent_date = models.DateTimeField()
    sender = models.ForeignKey(Account, on_delete=models.CASCADE)
