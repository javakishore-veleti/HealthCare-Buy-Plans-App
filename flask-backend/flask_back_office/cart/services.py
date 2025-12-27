"""
Cart Services (Business Logic)
"""
from typing import Tuple, Dict, Any
from flask_back_office.cart.dao import CartDAO, CartItemDAO
from flask_back_office.catalog.dao import HealthPlanDAO


class CartService:
    """Cart service"""
    
    @staticmethod
    def get_cart(user_id: int) -> Tuple[bool, Dict[str, Any]]:
        """Get user's active cart"""
        cart = CartDAO.get_or_create(user_id)
        return True, {'cart': cart.to_dict()}
    
    @staticmethod
    def add_item(user_id: int, plan_id: int, quantity: int = 1,
                 billing_cycle: str = 'monthly') -> Tuple[bool, Dict[str, Any]]:
        """Add item to cart"""
        # Validate plan exists
        plan = HealthPlanDAO.get_by_id(plan_id)
        if not plan:
            return False, {'error': 'Plan not found'}
        
        if not plan.is_active:
            return False, {'error': 'Plan is not available'}
        
        # Validate quantity
        if quantity < 1:
            return False, {'error': 'Quantity must be at least 1'}
        
        # Validate billing cycle
        if billing_cycle not in ['monthly', 'yearly']:
            return False, {'error': 'Invalid billing cycle'}
        
        try:
            cart = CartDAO.get_or_create(user_id)
            
            # Check if item already in cart
            existing_item = CartItemDAO.get_by_cart_and_plan(cart.id, plan_id)
            
            if existing_item:
                # Update quantity
                new_quantity = existing_item.quantity + quantity
                CartItemDAO.update(existing_item, quantity=new_quantity, billing_cycle=billing_cycle)
            else:
                # Create new item
                CartItemDAO.create(
                    cart_id=cart.id,
                    plan_id=plan_id,
                    quantity=quantity,
                    billing_cycle=billing_cycle
                )
            
            return True, {
                'message': 'Item added to cart',
                'cart': cart.to_dict()
            }
        except Exception as e:
            return False, {'error': str(e)}
    
    @staticmethod
    def update_item(user_id: int, item_id: int, quantity: int = None,
                    billing_cycle: str = None) -> Tuple[bool, Dict[str, Any]]:
        """Update cart item"""
        cart = CartDAO.get_active_cart(user_id)
        if not cart:
            return False, {'error': 'Cart not found'}
        
        item = CartItemDAO.get_by_id(item_id)
        if not item or item.cart_id != cart.id:
            return False, {'error': 'Item not found in cart'}
        
        try:
            update_data = {}
            if quantity is not None:
                if quantity < 1:
                    return False, {'error': 'Quantity must be at least 1'}
                update_data['quantity'] = quantity
            
            if billing_cycle is not None:
                if billing_cycle not in ['monthly', 'yearly']:
                    return False, {'error': 'Invalid billing cycle'}
                update_data['billing_cycle'] = billing_cycle
            
            if update_data:
                CartItemDAO.update(item, **update_data)
            
            return True, {
                'message': 'Item updated',
                'cart': cart.to_dict()
            }
        except Exception as e:
            return False, {'error': str(e)}
    
    @staticmethod
    def remove_item(user_id: int, item_id: int) -> Tuple[bool, Dict[str, Any]]:
        """Remove item from cart"""
        cart = CartDAO.get_active_cart(user_id)
        if not cart:
            return False, {'error': 'Cart not found'}
        
        item = CartItemDAO.get_by_id(item_id)
        if not item or item.cart_id != cart.id:
            return False, {'error': 'Item not found in cart'}
        
        try:
            CartItemDAO.delete(item)
            return True, {
                'message': 'Item removed',
                'cart': cart.to_dict()
            }
        except Exception as e:
            return False, {'error': str(e)}
    
    @staticmethod
    def clear_cart(user_id: int) -> Tuple[bool, Dict[str, Any]]:
        """Clear all items from cart"""
        cart = CartDAO.get_active_cart(user_id)
        if not cart:
            return False, {'error': 'Cart not found'}
        
        try:
            CartDAO.clear(cart)
            return True, {
                'message': 'Cart cleared',
                'cart': cart.to_dict()
            }
        except Exception as e:
            return False, {'error': str(e)}