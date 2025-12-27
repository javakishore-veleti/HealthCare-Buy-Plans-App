"""
Catalog Models
"""
from datetime import datetime
from flask_back_office.extensions import db


class PlanCategory(db.Model):
    """Health plan category"""
    __tablename__ = 'plan_categories'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False, unique=True)
    description = db.Column(db.Text, nullable=True)
    is_active = db.Column(db.Boolean, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    # Relationship
    plans = db.relationship('HealthPlan', backref='category', lazy='dynamic')
    
    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'description': self.description,
            'is_active': self.is_active
        }


class HealthPlan(db.Model):
    """Health plan"""
    __tablename__ = 'health_plans'
    
    id = db.Column(db.Integer, primary_key=True)
    category_id = db.Column(db.Integer, db.ForeignKey('plan_categories.id'), nullable=False)
    name = db.Column(db.String(255), nullable=False)
    description = db.Column(db.Text, nullable=True)
    coverage_amount = db.Column(db.Float, nullable=False)
    premium_monthly = db.Column(db.Float, nullable=False)
    premium_yearly = db.Column(db.Float, nullable=False)
    features = db.Column(db.Text, nullable=True)  # JSON string
    is_active = db.Column(db.Boolean, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    def to_dict(self):
        return {
            'id': self.id,
            'category_id': self.category_id,
            'category': self.category.to_dict() if self.category else None,
            'name': self.name,
            'description': self.description,
            'coverage_amount': self.coverage_amount,
            'premium_monthly': self.premium_monthly,
            'premium_yearly': self.premium_yearly,
            'features': self.features,
            'is_active': self.is_active
        }