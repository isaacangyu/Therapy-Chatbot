from datetime import datetime

from django.shortcuts import render

from core import utils
from core.models import Account, Session
from chatbot.models import Conversation

RECENT_HISTORY_REQUEST_COUNT = 20

@utils.app_view
@utils.decrypt_body
def recent_history(request, form, oldest_timestamp):
    try:
        account = Account.objects.get(email=form.get("_email"))
        session = Session.objects.get(token=form.get("_token"))
        if account != session.account:
            return {"success": False}
        
        conversation = Conversation.objects.get(account=account)
        if oldest_timestamp == 0:
            message_history = conversation.messages.order_by('-timestamp')[:RECENT_HISTORY_REQUEST_COUNT]
        else:
            message_history = conversation.messages.filter(timestamp__lt=datetime.fromtimestamp(oldest_timestamp)).order_by('-timestamp')[:RECENT_HISTORY_REQUEST_COUNT]
        # There may be a better way to this than converting the QuerySet to a list.
        message_history = [{"sender": message["sender"], "encrypted_content": message["encrypted_content"].decode(), "timestamp": message["timestamp"].timestamp()} for message in message_history.values("sender", "encrypted_content", "timestamp")]
        return {"success": True, "log": message_history}
    except (Session.DoesNotExist, Account.DoesNotExist):
        return {"success": False}
