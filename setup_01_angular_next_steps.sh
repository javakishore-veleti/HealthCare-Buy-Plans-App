#!/bin/bash

# =============================================================================
# setup_01_angular_next_steps.sh
# Purpose: Configure Bootstrap and create folder structure for healthcare_plans_ui
# Run this AFTER: ng new healthcare_plans_ui --routing --style=scss --strict
# =============================================================================

echo "=========================================="
echo "Angular Setup - Step 01: Next Steps"
echo "=========================================="

# Navigate to Angular app folder
cd front_end_code/healthcare_plans_ui

# -----------------------------------------
# Step 1: Update angular.json to include Bootstrap CSS
# -----------------------------------------
echo ""
echo "[Step 1] Adding Bootstrap to angular.json..."

# Using sed to add Bootstrap CSS to styles array
# This finds the styles array and adds bootstrap before the existing styles
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' 's|"src/styles.scss"|"node_modules/bootstrap/dist/css/bootstrap.min.css",\n              "src/styles.scss"|g' angular.json
else
    # Linux
    sed -i 's|"src/styles.scss"|"node_modules/bootstrap/dist/css/bootstrap.min.css",\n              "src/styles.scss"|g' angular.json
fi

echo "    ✓ Bootstrap CSS added to angular.json"

# -----------------------------------------
# Step 2: Create folder structure
# -----------------------------------------
echo ""
echo "[Step 2] Creating folder structure..."

# Core module - authentication, guards, interceptors, services
mkdir -p src/app/core/auth
mkdir -p src/app/core/guards
mkdir -p src/app/core/interceptors
mkdir -p src/app/core/services

# Shared module - common components, directives, pipes
mkdir -p src/app/shared/components
mkdir -p src/app/shared/directives
mkdir -p src/app/shared/pipes

# Feature modules
mkdir -p src/app/features/accounts      # SignUp, Login, Profile
mkdir -p src/app/features/catalog       # Health Plans listing
mkdir -p src/app/features/cart          # Shopping Cart
mkdir -p src/app/features/checkout      # Checkout & Payment
mkdir -p src/app/features/orders        # Order History

# Models
mkdir -p src/app/models

# Environments already exists (created by ng new)

echo "    ✓ core/auth"
echo "    ✓ core/guards"
echo "    ✓ core/interceptors"
echo "    ✓ core/services"
echo "    ✓ shared/components"
echo "    ✓ shared/directives"
echo "    ✓ shared/pipes"
echo "    ✓ features/accounts"
echo "    ✓ features/catalog"
echo "    ✓ features/cart"
echo "    ✓ features/checkout"
echo "    ✓ features/orders"
echo "    ✓ models"

# -----------------------------------------
# Step 3: Create placeholder .gitkeep files
# -----------------------------------------
echo ""
echo "[Step 3] Creating .gitkeep files for empty folders..."

touch src/app/core/auth/.gitkeep
touch src/app/core/guards/.gitkeep
touch src/app/core/interceptors/.gitkeep
touch src/app/core/services/.gitkeep
touch src/app/shared/components/.gitkeep
touch src/app/shared/directives/.gitkeep
touch src/app/shared/pipes/.gitkeep
touch src/app/features/accounts/.gitkeep
touch src/app/features/catalog/.gitkeep
touch src/app/features/cart/.gitkeep
touch src/app/features/checkout/.gitkeep
touch src/app/features/orders/.gitkeep
touch src/app/models/.gitkeep

echo "    ✓ .gitkeep files created"

# -----------------------------------------
# Step 4: Create environment files
# -----------------------------------------
echo ""
echo "[Step 4] Creating environment configuration..."

cat > src/environments/environment.ts << 'EOF'
export const environment = {
  production: false,
  apiBaseUrl: 'http://localhost:8000/api/v1',
  appName: 'Your Health Plans'
};
EOF

cat > src/environments/environment.prod.ts << 'EOF'
export const environment = {
  production: true,
  apiBaseUrl: 'https://api.yourhealthplans.com/api/v1',
  appName: 'Your Health Plans'
};
EOF

echo "    ✓ environment.ts created"
echo "    ✓ environment.prod.ts created"

# -----------------------------------------
# Step 5: Update styles.scss with basic styles
# -----------------------------------------
echo ""
echo "[Step 5] Updating styles.scss..."

cat > src/styles.scss << 'EOF'
/* =============================================================================
   Your Health Plans - Global Styles
   ============================================================================= */

/* Custom CSS Variables */
:root {
  --yhp-primary: #0d6efd;
  --yhp-secondary: #6c757d;
  --yhp-success: #198754;
  --yhp-danger: #dc3545;
  --yhp-warning: #ffc107;
  --yhp-info: #0dcaf0;
}

/* Global Styles */
body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background-color: #f8f9fa;
}

/* Utility Classes */
.cursor-pointer {
  cursor: pointer;
}

.text-yhp-primary {
  color: var(--yhp-primary);
}

/* Form Styles */
.form-container {
  max-width: 500px;
  margin: 2rem auto;
  padding: 2rem;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

/* Card Styles */
.card-hover:hover {
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15);
  transition: box-shadow 0.3s ease;
}
EOF

echo "    ✓ styles.scss updated"

# -----------------------------------------
# Summary
# -----------------------------------------
echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Folder Structure Created:"
echo ""
echo "src/app/"
echo "├── core/"
echo "│   ├── auth/"
echo "│   ├── guards/"
echo "│   ├── interceptors/"
echo "│   └── services/"
echo "├── shared/"
echo "│   ├── components/"
echo "│   ├── directives/"
echo "│   └── pipes/"
echo "├── features/"
echo "│   ├── accounts/      ← SignUp, Login, Profile"
echo "│   ├── catalog/       ← Health Plans"
echo "│   ├── cart/          ← Shopping Cart"
echo "│   ├── checkout/      ← Payment"
echo "│   └── orders/        ← Order History"
echo "├── models/"
echo "└── environments/"
echo ""
echo "Next Steps:"
echo "  1. Run: cd front_end_code/healthcare_plans_ui"
echo "  2. Run: ng serve"
echo "  3. Open: http://localhost:4200"
echo ""
