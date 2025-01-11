from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.forms import UserCreationForm
from django.contrib.sessions.models import Session
from django.shortcuts import render, redirect
from django.http import HttpResponse

# from .models import User

print("login views running")


def testPostRequest(request):
    # if request.method == 'POST':
    #     data = request.POST
    #     print('INSIDE')
    #     print(data)
    return HttpResponse('Test Post Request working')


def register(request):
    if request.method == 'POST':
        form = UserCreationForm(request.POST)
        print(form)
        if form.is_valid():
            user = form.save()
            login(request, user)
        else:
            form = UserCreationForm()
        return render(request, 'create_account.dart', {'form': form})


def login_view(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            # set user-specific data in the session
            request.session['username'] = username
            request.session.save()
            return redirect('main')
        else:
            # handle invalid login
            print('INVALID LOGIN')
    else:
        return render(request, 'login.dart')
