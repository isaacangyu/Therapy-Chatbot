from core import crypto, utils
from core.models import Account, Session

@utils.require_POST_OPTIONS
@utils.app_view
@utils.decrypt_body
def create_account(request, form):
    # Check if account already exists.
    if Account.objects.filter(email=form.get("email")).exists():
        return {
            "success": False,
            "message": "Account already exists.",
        }
    
    account = Account.create(
        form.get("name"), 
        form.get("email"), 
        form.get("password_digest"), 
        form.get("salt")
    )
    session = Session.create(account)
    account.save()
    session.save()
    return {
        "success": True,
        "token": session.token,
    }

@utils.require_POST_OPTIONS
@utils.app_view
@utils.decrypt_body
def login_password(request, form):
    try:
        account = Account.objects.get(email=form.get("email"))
    except Account.DoesNotExist:
        return {
            "success": False,
            "message": "Account does not exist.",
        }
    
    if not crypto.password_verify(form.get("password_digest"), account.password_hash):
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

@utils.require_POST_OPTIONS
@utils.app_view
@utils.decrypt_body
def login_token(request, form):
    try:
        account = Account.objects.get(email=form.get("_email"))
        session = Session.objects.get(token=form.get("_token"))
        return {"valid": True} if account == session.account else {"valid": False}
    except (Session.DoesNotExist, Account.DoesNotExist):
        return {"valid": False}

@utils.require_POST_OPTIONS
@utils.app_view
@utils.decrypt_body
def update_info(request, form):
    account = Account.objects.get(email=form.get("_email"))
    session = Session.objects.get(token=form.get("_token"))
    new_account_email = form.get("email")
    if account != session.account or new_account_email is None:
        return {"success": False}
    
    account.email = new_account_email
    account.save()
    return {"success": True}
