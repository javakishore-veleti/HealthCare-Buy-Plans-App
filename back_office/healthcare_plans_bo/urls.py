"""
healthcare_plans_bo URL Configuration
"""

from django.contrib import admin
from django.urls import path, include
from .views import welcome_view

urlpatterns = [
    path('', welcome_view, name='welcome'),
    path('admin/', admin.site.urls),
    path('api/v1/accounts/', include('accounts.urls')),
]
