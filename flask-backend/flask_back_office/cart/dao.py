"""
Cart DAO (Data Access Object)
"""
from typing import Optional
from flask_back_office.extensions import db
from flask_back_office.cart.models import Cart, CartItem


class CartDAO:
    """Data Access Object for Cart"""
    
    @staticmethod
    def create(user_id: int) -> Cart:
        cart = Cart(user_id=user_id)
        db.session.add(cart)
        db.session.commit()
        return cart
    
    @staticmethod
    def get_by_id(cart_id: int) -> Optional[Cart]:
        return Cart.query.get(cart_id)
    
    @staticmethod
    def get_active_cart(user_id: int) -> Optional[Cart]:
        return Cart.query.filter_by(user_id=user_id, is_active=True).first()
    
    @staticmethod
    def get_or_create(user_id: int) -> Cart:
        cart = CartDAO.get_active_cart(user_id)
        if not cart:
            cart = CartDAO.create(user_id)
        return cart
    
    @staticmethod
    def deactivate(cart: Cart) -> bool:
        cart.is_active = False
        db.session.commit()
        return True
    
    @staticmethod
    def clear(cart: Cart) -> bool:
        CartItem.query.filter_by(cart_id=cart.id).delete()
        db.session.commit()
        return True


class CartItemDAO:
    """Data Access Object for CartItem"""
    
    @staticmethod
    def create(cart_id: int, plan_id: int, quantity: int = 1, 
               billing_cycle: str = 'monthly') -> CartItem:
        item = CartItem(
            cart_id=cart_id,
            plan_id=plan_id,
            quantity=quantity,
            billing_cycle=billing_cycle
        )
        db.session.add(item)
        db.session.commit()
        return item
    
    @staticmethod
    def get_by_id(item_id: int) -> Optional[CartItem]:
        return CartItem.query.get(item_id)
    
    @staticmethod
    def get_by_cart_and_plan(cart_id: int, plan_id: int) -> Optional[CartItem]:
        return CartItem.query.filter_by(cart_id=cart_id, plan_id=plan_id).first()
    
    @staticmethod
    def update(item: CartItem, **kwargs) -> CartItem:
        for key, value in kwargs.items():
            if hasattr(item, key) and key not in ['id', 'cart_id']:
                setattr(item, key, value)
        db.session.commit()
        return item
    
    @staticmethod
    def delete(item: CartItem) -> bool:
        db.session.delete(item)
        db.session.commit()
        return True