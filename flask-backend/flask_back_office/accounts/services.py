"""
Accounts Services (Business Logic)
"""
from typing import Tuple, Dict, Any
from flask_jwt_extended import create_access_token, create_refresh_token
from flask_back_office.accounts.dao import UserDAO, UserProfileDAO


class AuthService:
    """Authentication service"""
    
    @staticmethod
    def register(email: str, password: str, full_name: str, 
                 mobile_number: str = None) -> Tuple[bool, Dict[str, Any]]:
        """Register a new user"""
        # Validate email
        if not email or '@' not in email:
            return False, {'error': 'Invalid email format'}
        
        # Validate password
        if not password or len(password) < 8:
            return False, {'error': 'Password must be at least 8 characters'}
        
        # Validate full name
        if not full_name or len(full_name.strip()) < 2:
            return False, {'error': 'Full name is required'}
        
        # Check if email exists
        if UserDAO.email_exists(email):
            return False, {'error': 'Email already registered'}
        
        try:
            # Create user
            user = UserDAO.create(email=email, password=password)
            
            # Create profile
            UserProfileDAO.create(
                user_id=user.id,
                full_name=full_name.strip(),
                mobile_number=mobile_number
            )
            
            return True, {
                'message': 'Registration successful',
                'user': user.to_dict()
            }
        except Exception as e:
            return False, {'error': str(e)}
    
    @staticmethod
    def login(email: str, password: str) -> Tuple[bool, Dict[str, Any]]:
        """Login user and return tokens"""
        if not email or not password:
            return False, {'error': 'Email and password are required'}
        
        user = UserDAO.get_by_email(email)
        
        if not user:
            return False, {'error': 'Invalid email or password'}
        
        if not user.is_active:
            return False, {'error': 'Account is deactivated'}
        
        if not user.check_password(password):
            return False, {'error': 'Invalid email or password'}
        
        # Generate tokens
        access_token = create_access_token(identity=user.id)
        refresh_token = create_refresh_token(identity=user.id)
        
        return True, {
            'message': 'Login successful',
            'access': access_token,
            'refresh': refresh_token,
            'user': user.to_dict()
        }
    
    @staticmethod
    def refresh(user_id: int) -> Tuple[bool, Dict[str, Any]]:
        """Refresh access token"""
        user = UserDAO.get_by_id(user_id)
        
        if not user or not user.is_active:
            return False, {'error': 'Invalid user'}
        
        access_token = create_access_token(identity=user.id)
        return True, {'access': access_token}


class ProfileService:
    """Profile service"""
    
    @staticmethod
    def get_profile(user_id: int) -> Tuple[bool, Dict[str, Any]]:
        """Get user profile"""
        user = UserDAO.get_by_id(user_id)
        
        if not user:
            return False, {'error': 'User not found'}
        
        return True, {'user': user.to_dict()}
    
    @staticmethod
    def update_profile(user_id: int, **kwargs) -> Tuple[bool, Dict[str, Any]]:
        """Update user profile"""
        profile = UserProfileDAO.get_by_user_id(user_id)
        
        if not profile:
            return False, {'error': 'Profile not found'}
        
        try:
            updated_profile = UserProfileDAO.update(profile, **kwargs)
            return True, {
                'message': 'Profile updated',
                'profile': updated_profile.to_dict()
            }
        except Exception as e:
            return False, {'error': str(e)}