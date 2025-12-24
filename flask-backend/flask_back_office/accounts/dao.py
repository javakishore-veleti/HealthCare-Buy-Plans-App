"""
Accounts DAO (Data Access Object)
"""
from typing import Optional
from flask_back_office.extensions import db
from flask_back_office.accounts.models import User, UserProfile


class UserDAO:
    """Data Access Object for User"""
    
    @staticmethod
    def create(email: str, password: str) -> User:
        user = User(email=email.lower().strip())
        user.set_password(password)
        db.session.add(user)
        db.session.commit()
        return user
    
    @staticmethod
    def get_by_id(user_id: int) -> Optional[User]:
        return User.query.get(user_id)
    
    @staticmethod
    def get_by_email(email: str) -> Optional[User]:
        return User.query.filter_by(email=email.lower().strip()).first()
    
    @staticmethod
    def email_exists(email: str) -> bool:
        return User.query.filter_by(email=email.lower().strip()).first() is not None
    
    @staticmethod
    def update(user: User, **kwargs) -> User:
        for key, value in kwargs.items():
            if hasattr(user, key) and key not in ['id', 'password_hash']:
                setattr(user, key, value)
        db.session.commit()
        return user
    
    @staticmethod
    def delete(user: User) -> bool:
        user.is_active = False
        db.session.commit()
        return True


class UserProfileDAO:
    """Data Access Object for UserProfile"""
    
    @staticmethod
    def create(user_id: int, full_name: str, mobile_number: str = None) -> UserProfile:
        profile = UserProfile(
            user_id=user_id,
            full_name=full_name,
            mobile_number=mobile_number
        )
        db.session.add(profile)
        db.session.commit()
        return profile
    
    @staticmethod
    def get_by_user_id(user_id: int) -> Optional[UserProfile]:
        return UserProfile.query.filter_by(user_id=user_id).first()
    
    @staticmethod
    def update(profile: UserProfile, **kwargs) -> UserProfile:
        for key, value in kwargs.items():
            if hasattr(profile, key) and key not in ['id', 'user_id']:
                setattr(profile, key, value)
        db.session.commit()
        return profile