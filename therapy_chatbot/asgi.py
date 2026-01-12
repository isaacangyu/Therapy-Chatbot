"""
ASGI config for therapy_chatbot project.

It exposes the ASGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/5.1/howto/deployment/asgi/
"""

import os

from django.core.asgi import get_asgi_application

from channels.auth import AuthMiddlewareStack
from channels.routing import ProtocolTypeRouter, URLRouter
from channels.security.websocket import AllowedHostsOriginValidator

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "therapy_chatbot.settings")

django_asgi_app = get_asgi_application()

# Must occur after ASGI application is initialized.
from chatbot.routing import websocket_urlpatterns

application = ProtocolTypeRouter({
    "http": django_asgi_app,
    # "websocket": AllowedHostsOriginValidator(
    #     AuthMiddlewareStack(URLRouter(websocket_urlpatterns))
    # )
    "websocket": (
        # We'll have to do conditional compilation between the web and Android 
        # since Android needs to set the origin header, while web can't 
        # set headers at all.
        AuthMiddlewareStack(URLRouter(websocket_urlpatterns))
    )
})
