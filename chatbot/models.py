from django.db import models
from django.utils import timezone

from core.models import Account

class Conversations(models.Model):
    message = models.CharField(max_length=250)
    sent_date = models.DateTimeField()
    sender = models.ForeignKey(Account, on_delete=models.CASCADE)