import json

from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt

from core import crypto, util

def cors_signed_json_response(data):
    response_data = json.dumps(data)
    response_data = crypto.asymmetric_sign(response_data.encode())
    
    response = HttpResponse(response_data)
    response["Access-Control-Allow-Origin"] = "*"
    return response

def app_view(view):
    @csrf_exempt
    def wrapper(request):
        raw_data = crypto.asymmetric_decrypt(request.body)
        form = json.loads(raw_data)
        response = view(request, form)
        return util.cors_signed_json_response(response)
    return wrapper
