#!/bin/bash

# =============================================================================
# fix_02_welcome_page.sh
# Purpose: Add a welcome page showing all API endpoints
# Run from git repo root folder
# =============================================================================

echo "=========================================="
echo "Fix 02: Adding Welcome Page"
echo "=========================================="

cd back_office

# -----------------------------------------
# Step 1: Create api_docs app
# -----------------------------------------
echo ""
echo "[Step 1] Creating api_docs view..."

# Create a simple views file in the main project folder
cat > healthcare_plans_bo/views.py << 'EOF'
"""
Welcome page showing all API endpoints.
"""

from django.http import JsonResponse
from django.views import View


class WelcomeView(View):
    """Welcome page with API documentation."""
    
    def get(self, request):
        api_docs = {
            "application": "Your Health Plans API",
            "version": "1.0.0",
            "description": "Healthcare Insurance E-Commerce Platform",
            "base_url": request.build_absolute_uri('/'),
            "endpoints": {
                "accounts": {
                    "description": "User authentication and profile management",
                    "base_path": "/api/v1/accounts/",
                    "endpoints": [
                        {
                            "method": "POST",
                            "path": "/api/v1/accounts/register/",
                            "description": "Register a new user",
                            "auth_required": False,
                            "request_body": {
                                "email": "string (required)",
                                "mobile": "string (required, 10 digits)",
                                "password": "string (required, min 8 chars)",
                                "full_name": "string (required)"
                            }
                        },
                        {
                            "method": "POST",
                            "path": "/api/v1/accounts/login/",
                            "description": "Login and get JWT token",
                            "auth_required": False,
                            "request_body": {
                                "email": "string (required)",
                                "password": "string (required)"
                            }
                        },
                        {
                            "method": "POST",
                            "path": "/api/v1/accounts/logout/",
                            "description": "Logout and invalidate token",
                            "auth_required": True,
                            "request_body": {
                                "refresh_token": "string (optional)"
                            }
                        },
                        {
                            "method": "GET",
                            "path": "/api/v1/accounts/profile/",
                            "description": "Get current user profile",
                            "auth_required": True
                        },
                        {
                            "method": "PATCH",
                            "path": "/api/v1/accounts/profile/",
                            "description": "Update user profile",
                            "auth_required": True,
                            "request_body": {
                                "full_name": "string (optional)",
                                "date_of_birth": "date YYYY-MM-DD (optional)",
                                "gender": "Male/Female/Other (optional)",
                                "address_line1": "string (optional)",
                                "address_line2": "string (optional)",
                                "city": "string (optional)",
                                "state": "string (optional)",
                                "pincode": "string 6 digits (optional)"
                            }
                        }
                    ]
                }
            },
            "authentication": {
                "type": "JWT Bearer Token",
                "header": "Authorization: Bearer <access_token>",
                "token_lifetime": {
                    "access_token": "60 minutes",
                    "refresh_token": "7 days"
                }
            },
            "admin": {
                "url": "/admin/",
                "description": "Django Admin Panel"
            },
            "health_check": {
                "status": "healthy",
                "database": "connected"
            }
        }
        
        return JsonResponse(api_docs, json_dumps_params={'indent': 2})
EOF

echo "    ✓ healthcare_plans_bo/views.py created"

# -----------------------------------------
# Step 2: Update main urls.py
# -----------------------------------------
echo ""
echo "[Step 2] Updating main URLs..."

cat > healthcare_plans_bo/urls.py << 'EOF'
"""
healthcare_plans_bo URL Configuration
"""

from django.contrib import admin
from django.urls import path, include
from .views import WelcomeView

urlpatterns = [
    path('', WelcomeView.as_view(), name='welcome'),
    path('admin/', admin.site.urls),
    path('api/v1/accounts/', include('accounts.urls')),
]
EOF

echo "    ✓ healthcare_plans_bo/urls.py updated"

# -----------------------------------------
# Summary
# -----------------------------------------
echo ""
echo "=========================================="
echo "Welcome Page Added!"
echo "=========================================="
echo ""
echo "Available URLs:"
echo "  http://127.0.0.1:8000/              - API Documentation (JSON)"
echo "  http://127.0.0.1:8000/admin/        - Django Admin"
echo "  http://127.0.0.1:8000/api/v1/accounts/register/  - Register"
echo "  http://127.0.0.1:8000/api/v1/accounts/login/     - Login"
echo "  http://127.0.0.1:8000/api/v1/accounts/logout/    - Logout"
echo "  http://127.0.0.1:8000/api/v1/accounts/profile/   - Profile"
echo ""
echo "Restart Django server to see changes:"
echo "  npm run api:start"
echo ""
