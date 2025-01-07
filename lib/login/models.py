from django.db import models
from django.contrib.auth.models import AbstractUser
from django_resized import ResizedImageField


def upload_to(filename):
    return '/profile/' + str(filename)


class User(AbstractUser):
    username = models.CharField(max_length=55)
    password = models.CharField(max_length=55)
    email = models.CharField(max_length=55)
    profile_picture = ResizedImageField(
        upload_to=upload_to, blank=True, null=True)
    pass


print("models running")
