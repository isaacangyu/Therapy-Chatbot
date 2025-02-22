from argon2 import PasswordHasher

_hasher = PasswordHasher(time_cost=3, memory_cost=11719, parallelism=1, encoding="base64")

def password_hash(password_digest):
    return _hasher.hash(password_digest)

def password_verify(password_digest, password_hash):
    return _hasher.verify(password_hash, password_digest)
