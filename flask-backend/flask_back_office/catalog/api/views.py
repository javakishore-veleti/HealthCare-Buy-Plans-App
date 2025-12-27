"""
Catalog API Views (REST Endpoints)
"""
from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required
from flask_back_office.catalog.services import CategoryService, PlanService

catalog_bp = Blueprint('catalog', __name__)


# ============================================
# Category Endpoints
# ============================================

@catalog_bp.route('/categories/', methods=['GET'])
def get_categories():
    """GET /api/v1/catalog/categories/"""
    success, result = CategoryService.get_all_categories()
    return jsonify(result), 200


@catalog_bp.route('/categories/<int:category_id>/', methods=['GET'])
def get_category(category_id):
    """GET /api/v1/catalog/categories/<id>/"""
    success, result = CategoryService.get_category(category_id)
    
    if success:
        return jsonify(result), 200
    return jsonify(result), 404


@catalog_bp.route('/categories/', methods=['POST'])
@jwt_required()
def create_category():
    """POST /api/v1/catalog/categories/"""
    data = request.get_json()
    
    if not data:
        return jsonify({'error': 'No data provided'}), 400
    
    success, result = CategoryService.create_category(
        name=data.get('name'),
        description=data.get('description')
    )
    
    if success:
        return jsonify(result), 201
    return jsonify(result), 400


# ============================================
# Plan Endpoints
# ============================================

@catalog_bp.route('/plans/', methods=['GET'])
def get_plans():
    """GET /api/v1/catalog/plans/"""
    success, result = PlanService.get_all_plans()
    return jsonify(result), 200


@catalog_bp.route('/plans/<int:plan_id>/', methods=['GET'])
def get_plan(plan_id):
    """GET /api/v1/catalog/plans/<id>/"""
    success, result = PlanService.get_plan(plan_id)
    
    if success:
        return jsonify(result), 200
    return jsonify(result), 404


@catalog_bp.route('/categories/<int:category_id>/plans/', methods=['GET'])
def get_plans_by_category(category_id):
    """GET /api/v1/catalog/categories/<id>/plans/"""
    success, result = PlanService.get_plans_by_category(category_id)
    
    if success:
        return jsonify(result), 200
    return jsonify(result), 404


@catalog_bp.route('/plans/', methods=['POST'])
@jwt_required()
def create_plan():
    """POST /api/v1/catalog/plans/"""
    data = request.get_json()
    
    if not data:
        return jsonify({'error': 'No data provided'}), 400
    
    success, result = PlanService.create_plan(
        category_id=data.get('category_id'),
        name=data.get('name'),
        description=data.get('description'),
        coverage_amount=data.get('coverage_amount', 0),
        premium_monthly=data.get('premium_monthly', 0),
        premium_yearly=data.get('premium_yearly', 0),
        features=data.get('features')
    )
    
    if success:
        return jsonify(result), 201
    return jsonify(result), 400