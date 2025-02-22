from django.http import HttpResponse
from django.shortcuts import render

from core import crypto

def create_account(request):
    print(request.body)
    print(crypto.asymmetric_decrypt(request.body))
    return HttpResponse("Test")
