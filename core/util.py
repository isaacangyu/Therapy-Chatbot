import json

from django.http import HttpResponse

from core import crypto

def cors_signed_json_response(data):
    response_data = json.dumps(data)
    response_data = crypto.asymmetric_sign(response_data.encode())
    
    response = HttpResponse(response_data)
    response["Access-Control-Allow-Origin"] = "*"
    return response
