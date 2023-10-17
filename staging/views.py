from django.shortcuts import render

def staging_home(request):
    return render(request, 'staging/home.html')
