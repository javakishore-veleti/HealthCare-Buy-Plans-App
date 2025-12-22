"""
Welcome page view.
"""

from django.shortcuts import render


def welcome_view(request):
    """Render the welcome page with API documentation."""
    return render(request, 'welcome.html')
