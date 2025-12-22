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
