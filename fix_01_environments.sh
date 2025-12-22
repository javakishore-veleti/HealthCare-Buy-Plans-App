#!/bin/bash

# =============================================================================
# fix_01_environments.sh
# Purpose: Fix environments folder and import path for Angular 17+
# =============================================================================

echo "=========================================="
echo "Fix 01: Environments Configuration"
echo "=========================================="

cd front_end_code/healthcare_plans_ui

npm install bootstrap
npm install @auth0/angular-jwt
npm install zone.js

# -----------------------------------------
# Step 1: Create environments folder if not exists
# -----------------------------------------
echo ""
echo "[Step 1] Creating environments folder..."

mkdir -p src/environments

# -----------------------------------------
# Step 2: Create environment.ts
# -----------------------------------------
echo ""
echo "[Step 2] Creating environment.ts..."

cat > src/environments/environment.ts << 'EOF'
export const environment = {
  production: false,
  apiBaseUrl: 'http://localhost:8000/api/v1',
  appName: 'Your Health Plans'
};
EOF

echo "    ✓ environment.ts created"

# -----------------------------------------
# Step 3: Create environment.prod.ts
# -----------------------------------------
echo ""
echo "[Step 3] Creating environment.prod.ts..."

cat > src/environments/environment.prod.ts << 'EOF'
export const environment = {
  production: true,
  apiBaseUrl: 'https://api.yourhealthplans.com/api/v1',
  appName: 'Your Health Plans'
};
EOF

echo "    ✓ environment.prod.ts created"

# -----------------------------------------
# Step 4: Fix import path in auth.service.ts
# -----------------------------------------
echo ""
echo "[Step 4] Fixing import path in auth.service.ts..."

# The correct path from src/app/core/auth/ to src/environments/ is:
# ../../../environments/environment (going up: auth -> core -> app -> src, then into environments)
# But Angular 17 default structure might differ, so let's use a simpler approach

# Check if the file exists and fix the import
if [ -f "src/app/core/auth/auth.service.ts" ]; then
    # For macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s|from '../../../environments/environment'|from '../../../../environments/environment'|g" src/app/core/auth/auth.service.ts
    else
        # For Linux
        sed -i "s|from '../../../environments/environment'|from '../../../../environments/environment'|g" src/app/core/auth/auth.service.ts
    fi
    echo "    ✓ auth.service.ts import path fixed"
else
    echo "    ! auth.service.ts not found - creating it..."
fi

# -----------------------------------------
# Step 5: Verify the structure
# -----------------------------------------
echo ""
echo "[Step 5] Verifying structure..."
echo ""
echo "src/environments/"
ls -la src/environments/

echo ""
echo "=========================================="
echo "Fix Complete!"
echo "=========================================="
echo ""
echo "Now run: npm run ui:start"
echo ""
