from django.shortcuts import render

from core import utils
from core.models import Account, Session
from chatbot.models import Conversation

RECENT_HISTORY_REQUEST_COUNT = 10

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
            message_history = conversation.messages.filter(timestamp__lt=oldest_timestamp).order_by('-timestamp')[:RECENT_HISTORY_REQUEST_COUNT]
        print(list(message_history.values("sender", "encrypted_content", "timestamp")))
        # There may be a better way to this than converting the QuerySet to a list.
        return {"success": True}
    except (Session.DoesNotExist, Account.DoesNotExist):
        return {"success": False}
