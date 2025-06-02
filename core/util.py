import json, functools, base64

from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.conf import settings

from core import crypto

def decrypt_body(view):
    @functools.wraps(view)
    def wrapper(request, *args, **kwargs):
        # Decrypt and parse the request body.
        raw_data = crypto.asymmetric_decrypt(request.body)
        form = json.loads(raw_data)
        return view(request, form, *args, **kwargs)
    return wrapper

def app_view(view):
    @functools.wraps(view)
    @csrf_exempt
    def wrapper(request, *args, **kwargs):
        response = HttpResponse()
        response["Access-Control-Allow-Origin"] = settings.ACCESS_CONTROL_ALLOW_ORIGIN
        
        # Get the response key used to encrypt the response body.
        response_key_encrypted = request.headers.get("X-Custom-Response-Key")
        if response_key_encrypted is None:
            response.status_code = 400
            return response
        
        response_key = crypto.asymmetric_decrypt(base64.b64decode(response_key_encrypted))
        
        # Process the request.
        response_data = view(request, *args, **kwargs)
        response_data = json.dumps(response_data)
        response_data = crypto.asymmetric_sign(response_data.encode())
        response_data = crypto.symmetric_encrypt(
            response_data.encode(), base64.b64decode(response_key)
        )
        
        response.content = response_data
        return response
    return wrapper

def require_POST_OPTIONS(view):
    @functools.wraps(view)
    @require_http_methods(["POST", "OPTIONS"])
    def wrapper(request, *args, **kwargs):
        if request.method == "OPTIONS":
            response = HttpResponse()
            response["Access-Control-Allow-Origin"] = settings.ACCESS_CONTROL_ALLOW_ORIGIN
            response["Access-Control-Allow-Methods"] = "POST, OPTIONS"
            response["Access-Control-Allow-Headers"] = "X-Custom-Response-Key"# , Cache-Control"
            return response
        return view(request, *args, **kwargs)
    return wrapper
