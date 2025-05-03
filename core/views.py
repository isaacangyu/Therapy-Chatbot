from core import crypto, util
from core.models import Account, Session

@util.require_POST_OPTIONS
@util.app_view
def create_account(request, form):
    # Check if account already exists.
    if Account.objects.filter(email=form["email"]).exists():
        return {
            "success": False,
            "message": "Account already exists.",
        }
    
    account = Account.create(
        form["name"], 
        form["email"], 
        form["password_digest"], 
        form["salt"]
    )
    session = Session.create(account)
    account.save()
    session.save()
    return {
        "success": True,
        "token": session.token,
    }

@util.require_POST_OPTIONS
@util.app_view
def login_password(request, form):
    try:
        account = Account.objects.get(email=form["email"])
    except Account.DoesNotExist:
        return {
            "success": False,
            "message": "Account does not exist.",
        }
    
    if not crypto.password_verify(form["password_digest"], account.password_hash):
        return {
            "success": False,
            "message": "Incorrect password.",
        }
    
    session = Session.create(account)
    session.save()
    return {
        "success": True,
        "salt": account.kdf_salt,
        "token": session.token,
    }

@util.require_POST_OPTIONS
@util.app_view
def login_token(request, form):
    try:
        Session.objects.get(token=form["token"])
    except Session.DoesNotExist:
        return {
            "valid": False,
        }
    
    return {
        "valid": True,
    }
