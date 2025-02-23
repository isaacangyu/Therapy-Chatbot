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
