from django.urls import path

from chatbot import views

urlpatterns = [
    path("recent_history/<int:oldest_timestamp>/", views.recent_history, name=views.recent_history.__name__)
]
