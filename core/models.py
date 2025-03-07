import math, secrets

from django.db import models
from django.utils import timezone

from core import crypto

SESSION_TOKEN_BYTES = 0x40

class Account(models.Model):
    name = models.CharField(max_length=64)
    email = models.EmailField(max_length=64)
    password_hash = models.CharField()
    kdf_salt = models.CharField(max_length=64)
    creation_date = models.DateTimeField()
    
    def __str__(self):
        return f"{self.name} ({self.email})"
    
    @staticmethod
    def create(name, email, password_digest, kdf_salt):
        password_hash = crypto.password_hash(password_digest)
        return Account(
            name=name, 
            email=email, 
            password_hash=password_hash, 
            kdf_salt=kdf_salt, 
            creation_date=timezone.now()
        )

class Session(models.Model):
    account = models.ForeignKey(Account, on_delete=models.CASCADE)
    token = models.CharField(max_length=math.ceil(SESSION_TOKEN_BYTES * 8 / 6))
    creation_date = models.DateTimeField()
    
    def __str__(self):
        return f"{self.account} ({self.token})"
    
    @staticmethod
    def create(account):
        token = secrets.token_urlsafe(SESSION_TOKEN_BYTES)
        return Session(
            account=account, 
            token=token, 
            creation_date=timezone.now()
        )
