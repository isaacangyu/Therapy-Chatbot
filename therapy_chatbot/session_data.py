from django.contrib.sessions.models import Session

sessions = Session.objects.all()
for session in sessions:
    print(session.session_key, session.get_decoded())
