# backend/urls.py
from django.contrib import admin
from django.urls import path, include

print(">>> backend urls loaded")

urlpatterns = [
    path("admin/", admin.site.urls),
    path("api/", include("journal.urls")),
]