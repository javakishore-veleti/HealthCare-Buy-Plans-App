"""
Flask Application Factory
"""
import os
from flask import Flask, jsonify
from flask_back_office.config import config
from flask_back_office.extensions import db, migrate, jwt, cors


def create_app(config_name=None):
    """Create and configure Flask application"""
    if config_name is None:
        config_name = os.environ.get('FLASK_ENV', 'development')
    
    app = Flask(__name__)
    app.config.from_object(config[config_name])
    
    # Initialize extensions
    db.init_app(app)
    migrate.init_app(app, db)
    jwt.init_app(app)
    cors.init_app(app, resources={r"/api/*": {"origins": "*"}})
    
    # Register blueprints
    from flask_back_office.accounts.api.views import accounts_bp
    from flask_back_office.catalog.api.views import catalog_bp
    from flask_back_office.cart.api.views import cart_bp
    
    app.register_blueprint(accounts_bp, url_prefix='/api/v1/accounts')
    app.register_blueprint(catalog_bp, url_prefix='/api/v1/catalog')
    app.register_blueprint(cart_bp, url_prefix='/api/v1/cart')
    
    # Root endpoint
    @app.route('/')
    def index():
        return jsonify({
            'message': 'Welcome to HealthCare Plans API (Flask)',
            'version': '1.0.0',
            'endpoints': {
                'accounts': '/api/v1/accounts/',
                'catalog': '/api/v1/catalog/',
                'cart': '/api/v1/cart/'
            }
        })
    
    # Health check
    @app.route('/api/v1/health/')
    def health():
        return jsonify({'status': 'healthy'})
    
    # Create tables
    with app.app_context():
        db.create_all()
    
    return app