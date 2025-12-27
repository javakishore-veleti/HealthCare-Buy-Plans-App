"""
Catalog Services (Business Logic)
"""
from typing import Tuple, Dict, Any, List
from flask_back_office.catalog.dao import PlanCategoryDAO, HealthPlanDAO


class CategoryService:
    """Category service"""
    
    @staticmethod
    def get_all_categories() -> Tuple[bool, Dict[str, Any]]:
        """Get all active categories"""
        categories = PlanCategoryDAO.get_all(active_only=True)
        return True, {
            'categories': [c.to_dict() for c in categories]
        }
    
    @staticmethod
    def get_category(category_id: int) -> Tuple[bool, Dict[str, Any]]:
        """Get category by ID"""
        category = PlanCategoryDAO.get_by_id(category_id)
        
        if not category:
            return False, {'error': 'Category not found'}
        
        return True, {'category': category.to_dict()}
    
    @staticmethod
    def create_category(name: str, description: str = None) -> Tuple[bool, Dict[str, Any]]:
        """Create a new category"""
        if not name or len(name.strip()) < 2:
            return False, {'error': 'Category name is required'}
        
        try:
            category = PlanCategoryDAO.create(name=name.strip(), description=description)
            return True, {
                'message': 'Category created',
                'category': category.to_dict()
            }
        except Exception as e:
            return False, {'error': str(e)}


class PlanService:
    """Health plan service"""
    
    @staticmethod
    def get_all_plans() -> Tuple[bool, Dict[str, Any]]:
        """Get all active plans"""
        plans = HealthPlanDAO.get_all(active_only=True)
        return True, {
            'plans': [p.to_dict() for p in plans]
        }
    
    @staticmethod
    def get_plan(plan_id: int) -> Tuple[bool, Dict[str, Any]]:
        """Get plan by ID"""
        plan = HealthPlanDAO.get_by_id(plan_id)
        
        if not plan:
            return False, {'error': 'Plan not found'}
        
        return True, {'plan': plan.to_dict()}
    
    @staticmethod
    def get_plans_by_category(category_id: int) -> Tuple[bool, Dict[str, Any]]:
        """Get plans by category"""
        category = PlanCategoryDAO.get_by_id(category_id)
        
        if not category:
            return False, {'error': 'Category not found'}
        
        plans = HealthPlanDAO.get_by_category(category_id, active_only=True)
        return True, {
            'category': category.to_dict(),
            'plans': [p.to_dict() for p in plans]
        }
    
    @staticmethod
    def create_plan(category_id: int, name: str, coverage_amount: float,
                    premium_monthly: float, premium_yearly: float,
                    description: str = None, features: str = None) -> Tuple[bool, Dict[str, Any]]:
        """Create a new plan"""
        # Validate
        if not name:
            return False, {'error': 'Plan name is required'}
        
        if coverage_amount <= 0:
            return False, {'error': 'Coverage amount must be positive'}
        
        if premium_monthly <= 0 or premium_yearly <= 0:
            return False, {'error': 'Premium must be positive'}
        
        # Check category exists
        category = PlanCategoryDAO.get_by_id(category_id)
        if not category:
            return False, {'error': 'Category not found'}
        
        try:
            plan = HealthPlanDAO.create(
                category_id=category_id,
                name=name,
                description=description,
                coverage_amount=coverage_amount,
                premium_monthly=premium_monthly,
                premium_yearly=premium_yearly,
                features=features
            )
            return True, {
                'message': 'Plan created',
                'plan': plan.to_dict()
            }
        except Exception as e:
            return False, {'error': str(e)}