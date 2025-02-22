from django.urls import path

from core import views

urlpatterns = [
    path("create/", views.create_account, name=views.create_account.__name__),
]
