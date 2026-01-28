from rest_framework import generics
from rest_framework.permissions import BasePermission
from .models import JournalEntry
from .serializers import JournalEntrySerializer
from core.models import Account, Session

class IsAuthenticatedCustom(BasePermission):
    def has_permission(self, request, _):
        account = Account.objects.get(email=request.form.get("_email"))
        session = Session.objects.get(token=request.form.get("_token"))
        setattr(request, "account", account)
        return account == session.account

class JournalEntryListCreate(generics.ListCreateAPIView):
    serializer_class = JournalEntrySerializer
    permission_classes = [IsAuthenticatedCustom]
    
    def get_queryset(self):
        return JournalEntry.objects.filter(account=self.request.account).order_by('-date')

    def perform_create(self, serializer):
        serializer.save(account=self.request.account)
