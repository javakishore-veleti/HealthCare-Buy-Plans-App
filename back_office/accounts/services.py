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
