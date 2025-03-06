import json

from django.views.decorators.http import require_POST

from core import crypto, util
from core.models import Account, Session

@require_POST
def create_account(request):
    raw_data = crypto.asymmetric_decrypt(request.body)
    form = json.loads(raw_data)
    
    # Check if account already exists.
    if Account.objects.filter(email=form["email"]).exists():
        return util.cors_signed_json_response({
            "success": False,
            "message": "Account already exists.",
        })
    
    account = Account.create(
        form["name"], 
        form["email"], 
        form["password_digest"], 
        form["salt"]
    )
    session = Session.create(account)
    account.save()
    session.save()
    return util.cors_signed_json_response({
        "success": True,
        "token": session.token,
    })

@require_POST
def login_password(request):
    raw_data = crypto.asymmetric_decrypt(request.body)
    form = json.loads(raw_data)
    
    try:
        account = Account.objects.get(email=form["email"])
    except Account.DoesNotExist:
        return util.cors_signed_json_response({
            "success": False,
            "message": "Account does not exist.",
        })
    
    if not crypto.password_verify(form["password_digest"], account.password_hash):
        return util.cors_signed_json_response({
            "success": False,
            "message": "Incorrect password.",
        })
    
    session = Session.create(account)
    session.save()
    return util.cors_signed_json_response({
        "success": True,
        "salt": account.kdf_salt,
        "token": session.token,
    })

@require_POST
def login_token(request):
    raw_data = crypto.asymmetric_decrypt(request.body)
    form = json.loads(raw_data)
    
    try:
        session = Session.objects.get(token=form["token"])
    except Session.DoesNotExist:
        return util.cors_signed_json_response({
            "valid": False,
        })
    
    return util.cors_signed_json_response({
        "valid": True,
    })
