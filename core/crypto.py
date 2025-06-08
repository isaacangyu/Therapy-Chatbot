import base64, secrets

from argon2 import PasswordHasher, exceptions
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
from django.conf import settings

RSA_KEY_SIZE_BITS = 3072
RSA_KEY_SIZE_BYTES = RSA_KEY_SIZE_BITS // 8
SESSION_TOKEN_BYTES = 0x40

_hasher = PasswordHasher(time_cost=3, memory_cost=11719, parallelism=1, encoding="utf-8")

with open(f"./cert/{'test' if settings.DEBUG else 'prod'}/private/private.pem", "rb") as key_file:
    _private_key = serialization.load_pem_private_key(key_file.read(), password=None)

def password_hash(password_digest):
    if len(password_digest) > 256:
        raise ValueError("Password digest is too long.")
    return _hasher.hash(password_digest)

def password_verify(password_digest, password_hash):
    if len(password_digest) > 256:
        raise ValueError("Password digest is too long.")
    try:
        # `verify` will return True if verification succeeds and raises an exception otherwise.
        return _hasher.verify(password_hash, password_digest)
    except exceptions.VerifyMismatchError:
        return False

def asymmetric_decrypt(ciphertext):
    return b"".join(
        _private_key.decrypt(
            ciphertext[inp_off:inp_off + RSA_KEY_SIZE_BYTES],
            padding.OAEP(
                mgf=padding.MGF1(hashes.SHA256()),
                algorithm=hashes.SHA256(),
                label=None
            )
        ) for inp_off in range(0, len(ciphertext), RSA_KEY_SIZE_BYTES)
    )

def asymmetric_sign(data):
    # We would use OAEP padding, but it's not easily supported on the client's side.
    signature = _private_key.sign(data, padding.PKCS1v15(), hashes.SHA256())
    dataBase64 = base64.b64encode(data).decode()
    signatureBase64 = base64.b64encode(signature).decode()
    return f"{dataBase64}:{signatureBase64}"

def symmetric_encrypt(data, key):
    aes_gcm = AESGCM(key)
    iv = secrets.token_bytes(0x10)
    ciphertext = aes_gcm.encrypt(iv, data, None)
    ivBase64 = base64.b64encode(iv).decode()
    ciphertextBase64 = base64.b64encode(ciphertext).decode()
    return f"{ciphertextBase64}:{ivBase64}"

def generate_generic_session_token():
    return secrets.token_urlsafe(SESSION_TOKEN_BYTES)
