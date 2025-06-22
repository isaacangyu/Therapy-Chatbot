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
        try:
            raw_data = crypto.asymmetric_decrypt(request.body)
            form = json.loads(raw_data)
        except (json.decoder.JSONDecodeError, ValueError):
            raise MalformedRequestError()
        return view(request, form, *args, **kwargs)
    return wrapper

def app_view(view):
    @functools.wraps(view)
    @csrf_exempt
    def wrapper(request, *args, **kwargs):
        response = HttpResponse()
        response["Access-Control-Allow-Origin"] = settings.ACCESS_CONTROL_ALLOW_ORIGIN
        
        try:
            try:
                # Get the response key used to encrypt the response body.
                response_key_encrypted = request.headers["X-Custom-Response-Key"]
                response_key = crypto.asymmetric_decrypt(base64.b64decode(response_key_encrypted))
            except (KeyError, ValueError):
                raise MalformedRequestError()
            
            # Process the request, catching bad processing.
            response_data = view(request, *args, **kwargs)
        except MalformedRequestError:
            response.status_code = 400
            return response
        except UnprocessableRequestError:
            response.status_code = 422
            return response
        
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

class CoreError(Exception):
    pass

class MalformedRequestError(CoreError):
    pass

class UnprocessableRequestError(CoreError):
    pass

def app_ws_in(consumer_receive):
    @functools.wraps(consumer_receive)
    async def wrapper(self, text_data=None, bytes_data=None):
        try:
            raw_data = crypto.asymmetric_decrypt(bytes_data)
            json_data = json.loads(raw_data)
            
            if not hasattr(self, "response_key"):
                response_key_encrypted = json_data["custom_response_key"]
                self.response_key = crypto.asymmetric_decrypt(
                    base64.b64decode(response_key_encrypted)
                )
            await consumer_receive(self, json_data)
        except (json.decoder.JSONDecodeError, ValueError, KeyError):
            await self.close(code=4000)
    return wrapper

async def ws_process_out(consumer, data_dict):
    response_data = json.dumps(data_dict)
    response_data = crypto.asymmetric_sign(response_data.encode())
    response_data = crypto.symmetric_encrypt(
        response_data.encode(), base64.b64decode(consumer.response_key)
    )
    await consumer.send(text_data=response_data)
