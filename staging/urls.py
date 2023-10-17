from django.urls import path
from . import views

app_name = 'staging'

urlpatterns = [
    path('', views.staging_home, name='home'),
    # ... other staging URLs ...
]
