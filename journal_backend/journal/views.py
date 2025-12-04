from rest_framework import generics
from .models import JournalEntry
from .serializers import JournalEntrySerializer

class JournalEntryListCreate(generics.ListCreateAPIView):
    queryset = JournalEntry.objects.all().order_by('-date')
    serializer_class = JournalEntrySerializer