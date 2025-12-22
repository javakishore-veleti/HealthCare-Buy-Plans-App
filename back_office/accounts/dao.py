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
