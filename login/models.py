from django.db import models
# Django model reference + insert, update, delete - https://www.w3schools.com/django/django_models.php


class User(models.Model):
    username = models.CharField(max_length=55)
    password = models.CharField(max_length=55)
    email = models.CharField(max_length=55, primary_key=True)
    # find array field for all users info

    # profile_picture = ResizedImageField(
    #     upload_to=upload_to, blank=True, null=True)
    pass


class SessionToken(models.Model):
    # Django foreign key field for session token to reference User, one-to-one
    # https://docs.djangoproject.com/en/5.1/topics/db/examples/one_to_one/
    user_reference = models.OneToOneField(
        User, on_delete=models.CASCADE, primary_key=True)


print("models running")


# # from django_resized import ResizedImageField


# def upload_to(filename):
#     return '/profile/' + str(filename)
