import math, uuid

from django.db import models
from django.db.utils import IntegrityError

from core import crypto
from core.utils import UnprocessableRequestError

class Account(models.Model):
    id            = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name          = models.CharField(max_length=64)
    email         = models.EmailField(max_length=64)
    password_hash = models.CharField()
    kdf_salt      = models.CharField(max_length=64)
    creation_date = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"{self.name} ({self.email})"
    
    @staticmethod
    def create(name, email, password_digest, kdf_salt):
        password_hash = crypto.password_hash(password_digest)
        return Account(
            name=name, 
            email=email, 
            password_hash=password_hash, 
            kdf_salt=kdf_salt
        )
    
    def save(self):
        try:
            super().save()
        except IntegrityError:
            raise UnprocessableRequestError()

class Session(models.Model):
    account       = models.ForeignKey(Account, on_delete=models.CASCADE, related_name="sessions")
    token         = models.CharField(max_length=math.ceil(crypto.SESSION_TOKEN_BYTES * 8 / 6))
    creation_date = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"{self.account} ({self.token[0:8]}...)"
    
    @staticmethod
    def create(account):
        token = crypto.generate_generic_session_token()
        return Session(
            account=account, 
            token=token
        )
