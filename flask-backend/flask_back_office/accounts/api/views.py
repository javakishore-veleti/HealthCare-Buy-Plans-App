"""
Accounts API Views (REST Endpoints)
"""
from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from flask_back_office.accounts.services import AuthService, ProfileService

accounts_bp = Blueprint('accounts', __name__)


@accounts_bp.route('/register/', methods=['POST'])
def register():
    """POST /api/v1/accounts/register/"""
    data = request.get_json()
    
    if not data:
        return jsonify({'error': 'No data provided'}), 400
    
    success, result = AuthService.register(
        email=data.get('email'),
        password=data.get('password'),
        full_name=data.get('full_name'),
        mobile_number=data.get('mobile_number')
    )
    
    if success:
        return jsonify(result), 201
    return jsonify(result), 400


@accounts_bp.route('/login/', methods=['POST'])
def login():
    """POST /api/v1/accounts/login/"""
    data = request.get_json()
    
    if not data:
        return jsonify({'error': 'No data provided'}), 400
    
    success, result = AuthService.login(
        email=data.get('email'),
        password=data.get('password')
    )
    
    if success:
        return jsonify(result), 200
    return jsonify(result), 401


@accounts_bp.route('/token/refresh/', methods=['POST'])
@jwt_required(refresh=True)
def refresh():
    """POST /api/v1/accounts/token/refresh/"""
    user_id = get_jwt_identity()
    success, result = AuthService.refresh(user_id)
    
    if success:
        return jsonify(result), 200
    return jsonify(result), 401


@accounts_bp.route('/profile/', methods=['GET'])
@jwt_required()
def get_profile():
    """GET /api/v1/accounts/profile/"""
    user_id = get_jwt_identity()
    success, result = ProfileService.get_profile(user_id)
    
    if success:
        return jsonify(result), 200
    return jsonify(result), 404


@accounts_bp.route('/profile/', methods=['PUT'])
@jwt_required()
def update_profile():
    """PUT /api/v1/accounts/profile/"""
    user_id = get_jwt_identity()
    data = request.get_json()
    
    if not data:
        return jsonify({'error': 'No data provided'}), 400
    
    success, result = ProfileService.update_profile(user_id, **data)
    
    if success:
        return jsonify(result), 200
    return jsonify(result), 400