from django.db import models
from core.models import Account

class JournalEntry(models.Model):
    account = models.ForeignKey(Account, on_delete=models.CASCADE)
    content = models.TextField()
    date = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.account}: {self.content[:20]}"
