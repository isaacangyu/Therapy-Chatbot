from django.urls import path

from core import views

urlpatterns = [
    path("create/", views.create_account, name=views.create_account.__name__),
    path("login/password/", views.login_password, name=views.login_password.__name__),
    path("login/token/", views.login_token, name=views.login_token.__name__),
    path("update_info/", views.update_info, name=views.update_info.__name__),
]
