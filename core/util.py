import json, functools

from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST
from django.conf import settings
from core import crypto, util

def cors_signed_json_response(data):
    response_data = json.dumps(data)
    response_data = crypto.asymmetric_sign(response_data.encode())
    
    response = HttpResponse(response_data)
    response["Access-Control-Allow-Origin"] = settings.ACCESS_CONTROL_ALLOW_ORIGIN
    return response

def app_view(view):
    @functools.wraps(view)
    @csrf_exempt
    def wrapper(request, *args, **kwargs):
        raw_data = crypto.asymmetric_decrypt(request.body)
        form = json.loads(raw_data)
        response = view(request, form, *args, **kwargs)
        return util.cors_signed_json_response(response)
    return wrapper

def require_POST_OPTIONS(view):
    @functools.wraps(view)
    def wrapper(request, *args, **kwargs):
        if request.method == "OPTIONS":
            response = HttpResponse()
            response["Access-Control-Allow-Origin"] = settings.ACCESS_CONTROL_ALLOW_ORIGIN
            response["Access-Control-Allow-Methods"] = "POST, OPTIONS"
            # response["Access-Control-Allow-Headers"] = "Cache-Control"
            return response
        return require_POST(view)(request, *args, **kwargs)
    return wrapper
