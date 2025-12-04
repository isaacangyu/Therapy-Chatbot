from django.urls import path
from .views import JournalEntryListCreate

urlpatterns = [
    path("entries/", JournalEntryListCreate.as_view(), name="entries"),
]