from django.urls import path

from core import utils
from .views import JournalEntryListCreate, JournalEntryDetail

urlpatterns = [
    path("entries/", utils.require_POST_OPTIONS(utils.app_view(utils.decrypt_body(
        utils.override_request_method(JournalEntryListCreate.as_view())
    ))), name="entries"),

    path("entries/<int:pk>/", utils.require_POST_OPTIONS(utils.app_view(utils.decrypt_body(
        utils.override_request_method(JournalEntryDetail.as_view())
    ))), name="entry-detail"),
]