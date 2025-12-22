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
