"""
Cart Models
"""
from datetime import datetime
from flask_back_office.extensions import db


class Cart(db.Model):
    """Shopping cart"""
    __tablename__ = 'carts'
    
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    is_active = db.Column(db.Boolean, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    items = db.relationship('CartItem', backref='cart', lazy='dynamic', cascade='all, delete-orphan')
    
    def to_dict(self):
        items_list = [item.to_dict() for item in self.items]
        total = sum(item['subtotal'] for item in items_list)
        return {
            'id': self.id,
            'user_id': self.user_id,
            'items': items_list,
            'total': total,
            'item_count': len(items_list)
        }


class CartItem(db.Model):
    """Cart item"""
    __tablename__ = 'cart_items'
    
    id = db.Column(db.Integer, primary_key=True)
    cart_id = db.Column(db.Integer, db.ForeignKey('carts.id'), nullable=False)
    plan_id = db.Column(db.Integer, db.ForeignKey('health_plans.id'), nullable=False)
    quantity = db.Column(db.Integer, default=1)
    billing_cycle = db.Column(db.String(20), default='monthly')  # monthly or yearly
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    # Relationship
    plan = db.relationship('HealthPlan')
    
    def to_dict(self):
        price = self.plan.premium_monthly if self.billing_cycle == 'monthly' else self.plan.premium_yearly
        return {
            'id': self.id,
            'plan_id': self.plan_id,
            'plan_name': self.plan.name if self.plan else None,
            'quantity': self.quantity,
            'billing_cycle': self.billing_cycle,
            'price': price,
            'subtotal': price * self.quantity
        }