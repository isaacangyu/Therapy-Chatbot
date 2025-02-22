from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.forms import UserCreationForm
from django.contrib.sessions.models import Session
# from django.shortcuts import render, redirect
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_protect

# from .models import User


@csrf_protect
def testPostRequest(request):
    if request.method == 'POST':
        data = request.POST
        print(data)
        return JsonResponse('Test Post Request working', safe=False)


def register(request):
    if request.method == 'POST':
        post = request.POST
        print(post)
        form = UserCreationForm(post)
        print("Printing form", form)
        if form.is_valid():
            user = form.save()
            login(request, user)
            print("Created account")
        else:
            form = UserCreationForm()
        return JsonResponse({'form': form})


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
            print('LOGGED IN')
            session_token = ''
            return JsonResponse({'success': True, 'session token': session_token})
        else:
            # handle invalid login
            return JsonResponse({'success': False}, status=401)
    else:
        return JsonResponse({'error': 'Login view did not receive a POST Request'})

# @csrf_protect
# def forgot_password(request):
