from argon2 import PasswordHasher
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives import hashes
from django.conf import settings

_hasher = PasswordHasher(time_cost=3, memory_cost=11719, parallelism=1, encoding="base64")

with open(f"./cert/{'test' if settings.DEBUG else 'prod'}/private/private.pem", "rb") as key_file:
    _private_key = serialization.load_pem_private_key(key_file.read(), password=None)

def password_hash(password_digest):
    return _hasher.hash(password_digest)

def password_verify(password_digest, password_hash):
    return _hasher.verify(password_hash, password_digest)

def asymmetric_decrypt(ciphertext):
    return _private_key.decrypt(ciphertext, padding.OAEP(
        mgf=padding.MGF1(algorithm=hashes.SHA256()),
        algorithm=hashes.SHA256(),
        label=None
    ))

def asymmetric_sign(data):
    return _private_key.sign(data, padding.PSS(
        mgf=padding.MGF1(hashes.SHA256()),
        salt_length=padding.PSS.MAX_LENGTH
    ), hashes.SHA256())
