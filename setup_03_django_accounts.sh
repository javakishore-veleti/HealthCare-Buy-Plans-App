#!/bin/bash

# =============================================================================
# setup_03_django_accounts.sh
# Purpose: Create Django backend with accounts app for signup/login
# Run this from git repo root folder
# =============================================================================

echo "=========================================="
echo "Django Setup - Step 03: Backend & Accounts"
echo "=========================================="

# -----------------------------------------
# Step 1: Create back_office folder
# -----------------------------------------
echo ""
echo "[Step 1] Creating back_office folder..."

mkdir -p back_office
cd back_office

echo "    ✓ back_office folder created"

# -----------------------------------------
# Step 2: Create virtual environment
# -----------------------------------------
echo ""
echo "[Step 2] Creating Python virtual environment..."

python3 -m venv venv

# Activate virtual environment
source venv/bin/activate

echo "    ✓ Virtual environment created"

# -----------------------------------------
# Step 3: Create requirements.txt
# -----------------------------------------
echo ""
echo "[Step 3] Creating requirements.txt..."

cat > requirements.txt << 'EOF'
# Django
Django==4.2.17
djangorestframework==3.15.2
django-cors-headers==4.6.0

# JWT Authentication
djangorestframework-simplejwt==5.4.0

# Database
psycopg2-binary==2.9.10
mysqlclient==2.2.6

# Environment variables
python-dotenv==1.0.1

# Utilities
python-dateutil==2.9.0
EOF

echo "    ✓ requirements.txt created"

# -----------------------------------------
# Step 4: Install dependencies
# -----------------------------------------
echo ""
echo "[Step 4] Installing dependencies..."

pip install --upgrade pip
pip install -r requirements.txt

echo "    ✓ Dependencies installed"

# -----------------------------------------
# Step 5: Create Django project
# -----------------------------------------
echo ""
echo "[Step 5] Creating Django project..."

django-admin startproject healthcare_plans_bo .

echo "    ✓ Django project created"

# -----------------------------------------
# Step 6: Create accounts app
# -----------------------------------------
echo ""
echo "[Step 6] Creating accounts app..."

python manage.py startapp accounts

echo "    ✓ accounts app created"

# -----------------------------------------
# Step 7: Create .env file
# -----------------------------------------
echo ""
echo "[Step 7] Creating .env file..."

cat > .env << 'EOF'
# Django Settings
DEBUG=True
SECRET_KEY=your-secret-key-change-in-production
ALLOWED_HOSTS=localhost,127.0.0.1

# Database (SQLite for local development)
DATABASE_URL=sqlite:///db.sqlite3

# For MySQL (uncomment and configure)
# DB_ENGINE=django.db.backends.mysql
# DB_NAME=healthcare_plans_db
# DB_USER=healthcare_user
# DB_PASSWORD=healthcare_pass
# DB_HOST=localhost
# DB_PORT=3306

# For PostgreSQL (uncomment and configure)
# DB_ENGINE=django.db.backends.postgresql
# DB_NAME=healthcare_plans_db
# DB_USER=healthcare_user
# DB_PASSWORD=healthcare_pass
# DB_HOST=localhost
# DB_PORT=5432

# JWT Settings
JWT_ACCESS_TOKEN_LIFETIME_MINUTES=60
JWT_REFRESH_TOKEN_LIFETIME_DAYS=7
EOF

echo "    ✓ .env file created"

# -----------------------------------------
# Step 8: Update settings.py
# -----------------------------------------
echo ""
echo "[Step 8] Updating settings.py..."

cat > healthcare_plans_bo/settings.py << 'EOF'
"""
Django settings for healthcare_plans_bo project.
"""

import os
from pathlib import Path
from datetime import timedelta
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.getenv('SECRET_KEY', 'django-insecure-change-me')

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = os.getenv('DEBUG', 'True').lower() == 'true'

ALLOWED_HOSTS = os.getenv('ALLOWED_HOSTS', 'localhost,127.0.0.1').split(',')

# Application definition
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    
    # Third party apps
    'rest_framework',
    'rest_framework_simplejwt',
    'corsheaders',
    
    # Local apps
    'accounts',
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',  # Must be at top
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'healthcare_plans_bo.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'healthcare_plans_bo.wsgi.application'

# Database
# https://docs.djangoproject.com/en/4.2/ref/settings/#databases

DB_ENGINE = os.getenv('DB_ENGINE', 'django.db.backends.sqlite3')

if DB_ENGINE == 'django.db.backends.sqlite3':
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.sqlite3',
            'NAME': BASE_DIR / 'db.sqlite3',
        }
    }
else:
    DATABASES = {
        'default': {
            'ENGINE': DB_ENGINE,
            'NAME': os.getenv('DB_NAME', 'healthcare_plans_db'),
            'USER': os.getenv('DB_USER', 'healthcare_user'),
            'PASSWORD': os.getenv('DB_PASSWORD', 'healthcare_pass'),
            'HOST': os.getenv('DB_HOST', 'localhost'),
            'PORT': os.getenv('DB_PORT', '5432'),
        }
    }

# Custom User Model
AUTH_USER_MODEL = 'accounts.User'

# Password validation
AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
        'OPTIONS': {
            'min_length': 8,
        }
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

# Internationalization
LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'Asia/Kolkata'
USE_I18N = True
USE_TZ = True

# Static files (CSS, JavaScript, Images)
STATIC_URL = 'static/'

# Default primary key field type
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# REST Framework Configuration
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticated',
    ),
}

# Simple JWT Configuration
SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(minutes=int(os.getenv('JWT_ACCESS_TOKEN_LIFETIME_MINUTES', 60))),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=int(os.getenv('JWT_REFRESH_TOKEN_LIFETIME_DAYS', 7))),
    'ROTATE_REFRESH_TOKENS': True,
    'BLACKLIST_AFTER_ROTATION': True,
    'AUTH_HEADER_TYPES': ('Bearer',),
}

# CORS Configuration
CORS_ALLOWED_ORIGINS = [
    'http://localhost:4200',
    'http://127.0.0.1:4200',
]

CORS_ALLOW_CREDENTIALS = True
EOF

echo "    ✓ settings.py updated"

# -----------------------------------------
# Step 9: Create accounts/models.py
# -----------------------------------------
echo ""
echo "[Step 9] Creating accounts models..."

cat > accounts/models.py << 'EOF'
"""
Accounts Models - User and UserProfile
"""

from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin


class UserManager(BaseUserManager):
    """Custom user manager for email-based authentication."""
    
    def create_user(self, email, mobile, password=None, **extra_fields):
        if not email:
            raise ValueError('Email is required')
        if not mobile:
            raise ValueError('Mobile number is required')
        
        email = self.normalize_email(email)
        user = self.model(email=email, mobile=mobile, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user
    
    def create_superuser(self, email, mobile, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('is_active', True)
        
        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')
        
        return self.create_user(email, mobile, password, **extra_fields)


class User(AbstractBaseUser, PermissionsMixin):
    """Custom User model using email for authentication."""
    
    email = models.EmailField(max_length=255, unique=True)
    mobile = models.CharField(max_length=15)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    objects = UserManager()
    
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['mobile']
    
    class Meta:
        db_table = 'users'
    
    def __str__(self):
        return self.email


class UserProfile(models.Model):
    """User profile with additional information."""
    
    GENDER_CHOICES = [
        ('Male', 'Male'),
        ('Female', 'Female'),
        ('Other', 'Other'),
    ]
    
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    full_name = models.CharField(max_length=255)
    date_of_birth = models.DateField(null=True, blank=True)
    gender = models.CharField(max_length=10, choices=GENDER_CHOICES, null=True, blank=True)
    address_line1 = models.CharField(max_length=255, null=True, blank=True)
    address_line2 = models.CharField(max_length=255, null=True, blank=True)
    city = models.CharField(max_length=100, null=True, blank=True)
    state = models.CharField(max_length=100, null=True, blank=True)
    pincode = models.CharField(max_length=10, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'user_profiles'
    
    def __str__(self):
        return f"{self.full_name} ({self.user.email})"
EOF

echo "    ✓ accounts/models.py created"

# -----------------------------------------
# Step 10: Create accounts/dao.py
# -----------------------------------------
echo ""
echo "[Step 10] Creating accounts DAO layer..."

cat > accounts/dao.py << 'EOF'
"""
Accounts DAO (Data Access Object) Layer
Handles all database operations for User and UserProfile.
"""

from typing import Optional
from django.db import transaction
from .models import User, UserProfile


class UserDAO:
    """Data Access Object for User model."""
    
    @staticmethod
    def get_by_id(user_id: int) -> Optional[User]:
        """Get user by ID."""
        try:
            return User.objects.get(id=user_id)
        except User.DoesNotExist:
            return None
    
    @staticmethod
    def get_by_email(email: str) -> Optional[User]:
        """Get user by email."""
        try:
            return User.objects.get(email=email)
        except User.DoesNotExist:
            return None
    
    @staticmethod
    def email_exists(email: str) -> bool:
        """Check if email already exists."""
        return User.objects.filter(email=email).exists()
    
    @staticmethod
    def create(email: str, mobile: str, password: str) -> User:
        """Create a new user."""
        return User.objects.create_user(
            email=email,
            mobile=mobile,
            password=password
        )
    
    @staticmethod
    def update(user: User, **kwargs) -> User:
        """Update user fields."""
        for key, value in kwargs.items():
            if hasattr(user, key):
                setattr(user, key, value)
        user.save()
        return user


class UserProfileDAO:
    """Data Access Object for UserProfile model."""
    
    @staticmethod
    def get_by_user_id(user_id: int) -> Optional[UserProfile]:
        """Get profile by user ID."""
        try:
            return UserProfile.objects.get(user_id=user_id)
        except UserProfile.DoesNotExist:
            return None
    
    @staticmethod
    def get_by_user(user: User) -> Optional[UserProfile]:
        """Get profile by user object."""
        try:
            return user.profile
        except UserProfile.DoesNotExist:
            return None
    
    @staticmethod
    def create(user: User, full_name: str, **kwargs) -> UserProfile:
        """Create a new user profile."""
        return UserProfile.objects.create(
            user=user,
            full_name=full_name,
            **kwargs
        )
    
    @staticmethod
    def update(profile: UserProfile, **kwargs) -> UserProfile:
        """Update profile fields."""
        for key, value in kwargs.items():
            if hasattr(profile, key):
                setattr(profile, key, value)
        profile.save()
        return profile
EOF

echo "    ✓ accounts/dao.py created"

# -----------------------------------------
# Step 11: Create accounts/services.py
# -----------------------------------------
echo ""
echo "[Step 11] Creating accounts Service layer..."

cat > accounts/services.py << 'EOF'
"""
Accounts Service Layer
Handles business logic for user registration, authentication, and profile management.
"""

from typing import Tuple, Optional
from django.db import transaction
from rest_framework_simplejwt.tokens import RefreshToken
from .models import User, UserProfile
from .dao import UserDAO, UserProfileDAO


class AccountsService:
    """Service class for accounts operations."""
    
    @staticmethod
    @transaction.atomic
    def register_user(email: str, mobile: str, password: str, full_name: str) -> Tuple[User, UserProfile]:
        """
        Register a new user with profile.
        
        Args:
            email: User's email address
            mobile: User's mobile number
            password: User's password
            full_name: User's full name
            
        Returns:
            Tuple of (User, UserProfile)
            
        Raises:
            ValueError: If email already exists
        """
        # Check if email exists
        if UserDAO.email_exists(email):
            raise ValueError('Email already exists')
        
        # Create user
        user = UserDAO.create(email=email, mobile=mobile, password=password)
        
        # Create profile
        profile = UserProfileDAO.create(user=user, full_name=full_name)
        
        return user, profile
    
    @staticmethod
    def authenticate_user(email: str, password: str) -> Optional[User]:
        """
        Authenticate user with email and password.
        
        Args:
            email: User's email address
            password: User's password
            
        Returns:
            User object if authentication successful, None otherwise
        """
        user = UserDAO.get_by_email(email)
        
        if user and user.check_password(password) and user.is_active:
            return user
        
        return None
    
    @staticmethod
    def get_tokens_for_user(user: User) -> dict:
        """
        Generate JWT tokens for user.
        
        Args:
            user: User object
            
        Returns:
            Dictionary with access_token, refresh_token, and expires_in
        """
        refresh = RefreshToken.for_user(user)
        
        return {
            'access_token': str(refresh.access_token),
            'refresh_token': str(refresh),
            'expires_in': int(refresh.access_token.lifetime.total_seconds())
        }
    
    @staticmethod
    def get_user_with_profile(user_id: int) -> Optional[User]:
        """
        Get user with profile by ID.
        
        Args:
            user_id: User's ID
            
        Returns:
            User object with profile
        """
        user = UserDAO.get_by_id(user_id)
        if user:
            # Access profile to ensure it's loaded
            _ = UserProfileDAO.get_by_user(user)
        return user
    
    @staticmethod
    @transaction.atomic
    def update_profile(user: User, **kwargs) -> UserProfile:
        """
        Update user profile.
        
        Args:
            user: User object
            **kwargs: Profile fields to update
            
        Returns:
            Updated UserProfile object
        """
        profile = UserProfileDAO.get_by_user(user)
        
        if not profile:
            raise ValueError('Profile not found')
        
        return UserProfileDAO.update(profile, **kwargs)
EOF

echo "    ✓ accounts/services.py created"

# -----------------------------------------
# Step 12: Create accounts/api folder
# -----------------------------------------
echo ""
echo "[Step 12] Creating accounts API layer..."

mkdir -p accounts/api

# Create __init__.py
touch accounts/api/__init__.py

# Create serializers.py
cat > accounts/api/serializers.py << 'EOF'
"""
Accounts API Serializers
"""

from rest_framework import serializers
from ..models import User, UserProfile


class UserProfileSerializer(serializers.ModelSerializer):
    """Serializer for UserProfile model."""
    
    class Meta:
        model = UserProfile
        fields = [
            'id', 'full_name', 'date_of_birth', 'gender',
            'address_line1', 'address_line2', 'city', 'state', 'pincode',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']


class UserSerializer(serializers.ModelSerializer):
    """Serializer for User model with profile."""
    
    profile = UserProfileSerializer(read_only=True)
    
    class Meta:
        model = User
        fields = ['id', 'email', 'mobile', 'is_active', 'is_staff', 'created_at', 'updated_at', 'profile']
        read_only_fields = ['id', 'is_active', 'is_staff', 'created_at', 'updated_at']


class RegisterSerializer(serializers.Serializer):
    """Serializer for user registration."""
    
    email = serializers.EmailField()
    mobile = serializers.CharField(max_length=15)
    password = serializers.CharField(min_length=8, write_only=True)
    full_name = serializers.CharField(max_length=255)
    
    def validate_mobile(self, value):
        """Validate mobile number is 10 digits."""
        if not value.isdigit() or len(value) != 10:
            raise serializers.ValidationError('Mobile number must be 10 digits')
        return value


class LoginSerializer(serializers.Serializer):
    """Serializer for user login."""
    
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)


class ProfileUpdateSerializer(serializers.Serializer):
    """Serializer for profile update."""
    
    full_name = serializers.CharField(max_length=255, required=False)
    date_of_birth = serializers.DateField(required=False, allow_null=True)
    gender = serializers.ChoiceField(choices=['Male', 'Female', 'Other'], required=False, allow_null=True)
    address_line1 = serializers.CharField(max_length=255, required=False, allow_blank=True)
    address_line2 = serializers.CharField(max_length=255, required=False, allow_blank=True)
    city = serializers.CharField(max_length=100, required=False, allow_blank=True)
    state = serializers.CharField(max_length=100, required=False, allow_blank=True)
    pincode = serializers.CharField(max_length=10, required=False, allow_blank=True)
    
    def validate_pincode(self, value):
        """Validate pincode is 6 digits."""
        if value and (not value.isdigit() or len(value) != 6):
            raise serializers.ValidationError('Pincode must be 6 digits')
        return value
EOF

echo "    ✓ accounts/api/serializers.py created"

# Create views.py
cat > accounts/api/views.py << 'EOF'
"""
Accounts API Views
"""

from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework_simplejwt.tokens import RefreshToken

from ..services import AccountsService
from .serializers import (
    RegisterSerializer,
    LoginSerializer,
    UserSerializer,
    ProfileUpdateSerializer
)


class RegisterView(APIView):
    """API endpoint for user registration."""
    
    permission_classes = [AllowAny]
    
    def post(self, request):
        serializer = RegisterSerializer(data=request.data)
        
        if not serializer.is_valid():
            return Response(
                {'error': 'Validation failed', 'details': serializer.errors},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            user, profile = AccountsService.register_user(
                email=serializer.validated_data['email'],
                mobile=serializer.validated_data['mobile'],
                password=serializer.validated_data['password'],
                full_name=serializer.validated_data['full_name']
            )
            
            return Response({
                'id': user.id,
                'email': user.email,
                'message': 'Registration successful'
            }, status=status.HTTP_201_CREATED)
            
        except ValueError as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_400_BAD_REQUEST
            )


class LoginView(APIView):
    """API endpoint for user login."""
    
    permission_classes = [AllowAny]
    
    def post(self, request):
        serializer = LoginSerializer(data=request.data)
        
        if not serializer.is_valid():
            return Response(
                {'error': 'Validation failed', 'details': serializer.errors},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        user = AccountsService.authenticate_user(
            email=serializer.validated_data['email'],
            password=serializer.validated_data['password']
        )
        
        if not user:
            return Response(
                {'error': 'Invalid credentials'},
                status=status.HTTP_401_UNAUTHORIZED
            )
        
        tokens = AccountsService.get_tokens_for_user(user)
        
        return Response(tokens, status=status.HTTP_200_OK)


class LogoutView(APIView):
    """API endpoint for user logout."""
    
    permission_classes = [IsAuthenticated]
    
    def post(self, request):
        try:
            refresh_token = request.data.get('refresh_token')
            
            if refresh_token:
                token = RefreshToken(refresh_token)
                token.blacklist()
            
            return Response(
                {'message': 'Logout successful'},
                status=status.HTTP_200_OK
            )
        except Exception:
            return Response(
                {'message': 'Logout successful'},
                status=status.HTTP_200_OK
            )


class ProfileView(APIView):
    """API endpoint for user profile."""
    
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        """Get current user's profile."""
        user = AccountsService.get_user_with_profile(request.user.id)
        serializer = UserSerializer(user)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    def patch(self, request):
        """Update current user's profile."""
        serializer = ProfileUpdateSerializer(data=request.data)
        
        if not serializer.is_valid():
            return Response(
                {'error': 'Validation failed', 'details': serializer.errors},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            AccountsService.update_profile(
                user=request.user,
                **serializer.validated_data
            )
            
            # Return updated user data
            user = AccountsService.get_user_with_profile(request.user.id)
            user_serializer = UserSerializer(user)
            
            return Response(user_serializer.data, status=status.HTTP_200_OK)
            
        except ValueError as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_400_BAD_REQUEST
            )
EOF

echo "    ✓ accounts/api/views.py created"

# -----------------------------------------
# Step 13: Create accounts/urls.py
# -----------------------------------------
echo ""
echo "[Step 13] Creating accounts URLs..."

cat > accounts/urls.py << 'EOF'
"""
Accounts URL Configuration
"""

from django.urls import path
from .api.views import RegisterView, LoginView, LogoutView, ProfileView

urlpatterns = [
    path('register/', RegisterView.as_view(), name='register'),
    path('login/', LoginView.as_view(), name='login'),
    path('logout/', LogoutView.as_view(), name='logout'),
    path('profile/', ProfileView.as_view(), name='profile'),
]
EOF

echo "    ✓ accounts/urls.py created"

# -----------------------------------------
# Step 14: Update main urls.py
# -----------------------------------------
echo ""
echo "[Step 14] Updating main URLs..."

cat > healthcare_plans_bo/urls.py << 'EOF'
"""
healthcare_plans_bo URL Configuration
"""

from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/v1/accounts/', include('accounts.urls')),
]
EOF

echo "    ✓ healthcare_plans_bo/urls.py updated"

# -----------------------------------------
# Step 15: Create accounts/admin.py
# -----------------------------------------
echo ""
echo "[Step 15] Creating accounts admin..."

cat > accounts/admin.py << 'EOF'
"""
Accounts Admin Configuration
"""

from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from .models import User, UserProfile


class UserProfileInline(admin.StackedInline):
    model = UserProfile
    can_delete = False


@admin.register(User)
class UserAdmin(BaseUserAdmin):
    list_display = ('email', 'mobile', 'is_active', 'is_staff', 'created_at')
    list_filter = ('is_active', 'is_staff', 'created_at')
    search_fields = ('email', 'mobile')
    ordering = ('-created_at',)
    
    fieldsets = (
        (None, {'fields': ('email', 'password')}),
        ('Personal Info', {'fields': ('mobile',)}),
        ('Permissions', {'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions')}),
        ('Important Dates', {'fields': ('last_login',)}),
    )
    
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('email', 'mobile', 'password1', 'password2', 'is_staff', 'is_active'),
        }),
    )
    
    inlines = [UserProfileInline]


@admin.register(UserProfile)
class UserProfileAdmin(admin.ModelAdmin):
    list_display = ('full_name', 'user', 'city', 'state', 'created_at')
    list_filter = ('gender', 'state', 'created_at')
    search_fields = ('full_name', 'user__email', 'city')
    ordering = ('-created_at',)
EOF

echo "    ✓ accounts/admin.py created"

# -----------------------------------------
# Step 16: Run migrations
# -----------------------------------------
echo ""
echo "[Step 16] Running migrations..."

python manage.py makemigrations accounts
python manage.py migrate

echo "    ✓ Migrations completed"

# -----------------------------------------
# Step 17: Create superuser instructions
# -----------------------------------------
echo ""
echo "[Step 17] Setup complete!"

# Deactivate virtual environment
deactivate

# -----------------------------------------
# Summary
# -----------------------------------------
echo ""
echo "=========================================="
echo "Django Backend Setup Complete!"
echo "=========================================="
echo ""
echo "Project Structure:"
echo ""
echo "back_office/"
echo "├── venv/                    # Python virtual environment"
echo "├── requirements.txt         # Python dependencies"
echo "├── .env                     # Environment variables"
echo "├── manage.py"
echo "├── db.sqlite3               # SQLite database (created)"
echo "├── healthcare_plans_bo/"
echo "│   ├── settings.py"
echo "│   ├── urls.py"
echo "│   └── wsgi.py"
echo "└── accounts/"
echo "    ├── models.py            # User, UserProfile models"
echo "    ├── dao.py               # Data Access Layer"
echo "    ├── services.py          # Business Logic Layer"
echo "    ├── urls.py              # URL routing"
echo "    ├── admin.py             # Admin configuration"
echo "    └── api/"
echo "        ├── serializers.py   # DRF serializers"
echo "        └── views.py         # API views"
echo ""
echo "API Endpoints:"
echo "  POST /api/v1/accounts/register/  - Register new user"
echo "  POST /api/v1/accounts/login/     - Login (get JWT)"
echo "  POST /api/v1/accounts/logout/    - Logout"
echo "  GET  /api/v1/accounts/profile/   - Get profile"
echo "  PATCH /api/v1/accounts/profile/  - Update profile"
echo ""
echo "Next Steps:"
echo "  1. Activate virtual environment:"
echo "     cd back_office && source venv/bin/activate"
echo ""
echo "  2. Create superuser (optional):"
echo "     python manage.py createsuperuser"
echo ""
echo "  3. Start Django server:"
echo "     python manage.py runserver 8000"
echo ""
echo "  4. Or from repo root:"
echo "     npm run api:start"
echo ""
echo "  5. Test API at: http://localhost:8000/api/v1/accounts/"
echo ""
