"""
Catalog DAO (Data Access Object)
"""
from typing import Optional, List
from flask_back_office.extensions import db
from flask_back_office.catalog.models import PlanCategory, HealthPlan


class PlanCategoryDAO:
    """Data Access Object for PlanCategory"""
    
    @staticmethod
    def create(name: str, description: str = None) -> PlanCategory:
        category = PlanCategory(name=name, description=description)
        db.session.add(category)
        db.session.commit()
        return category
    
    @staticmethod
    def get_by_id(category_id: int) -> Optional[PlanCategory]:
        return PlanCategory.query.get(category_id)
    
    @staticmethod
    def get_all(active_only: bool = True) -> List[PlanCategory]:
        query = PlanCategory.query
        if active_only:
            query = query.filter_by(is_active=True)
        return query.all()
    
    @staticmethod
    def update(category: PlanCategory, **kwargs) -> PlanCategory:
        for key, value in kwargs.items():
            if hasattr(category, key) and key != 'id':
                setattr(category, key, value)
        db.session.commit()
        return category
    
    @staticmethod
    def delete(category: PlanCategory) -> bool:
        category.is_active = False
        db.session.commit()
        return True


class HealthPlanDAO:
    """Data Access Object for HealthPlan"""
    
    @staticmethod
    def create(category_id: int, name: str, coverage_amount: float,
               premium_monthly: float, premium_yearly: float,
               description: str = None, features: str = None) -> HealthPlan:
        plan = HealthPlan(
            category_id=category_id,
            name=name,
            description=description,
            coverage_amount=coverage_amount,
            premium_monthly=premium_monthly,
            premium_yearly=premium_yearly,
            features=features
        )
        db.session.add(plan)
        db.session.commit()
        return plan
    
    @staticmethod
    def get_by_id(plan_id: int) -> Optional[HealthPlan]:
        return HealthPlan.query.get(plan_id)
    
    @staticmethod
    def get_all(active_only: bool = True) -> List[HealthPlan]:
        query = HealthPlan.query
        if active_only:
            query = query.filter_by(is_active=True)
        return query.all()
    
    @staticmethod
    def get_by_category(category_id: int, active_only: bool = True) -> List[HealthPlan]:
        query = HealthPlan.query.filter_by(category_id=category_id)
        if active_only:
            query = query.filter_by(is_active=True)
        return query.all()
    
    @staticmethod
    def update(plan: HealthPlan, **kwargs) -> HealthPlan:
        for key, value in kwargs.items():
            if hasattr(plan, key) and key != 'id':
                setattr(plan, key, value)
        db.session.commit()
        return plan
    
    @staticmethod
    def delete(plan: HealthPlan) -> bool:
        plan.is_active = False
        db.session.commit()
        return True