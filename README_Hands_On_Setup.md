# Hands-On: Build This Project From Scratch

## Overview

This guide helps you **recreate the entire HealthCare-Buy-Plans-App from scratch** as a hands-on learning exercise. All code references point to the working repository.

**Reference Repository:** https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App

---

## Prerequisites

Install these before starting:

| Software | Version | Verify Command |
|----------|---------|----------------|
| Git | Latest | `git --version` |
| Python | 3.11+ | `python --version` |
| Node.js | 18+ | `node --version` |
| Angular CLI | 17+ | `ng version` (install: `npm install -g @angular/cli`) |

---

## Step-by-Step Setup

### Phase 1: Create Your Repository

```bash
# Create new folder
mkdir HealthCare-Buy-Plans-App
cd HealthCare-Buy-Plans-App

# Initialize git
git init

# Create folder structure
mkdir -p front_end_code
mkdir -p back_office
mkdir -p .github/workflows
```

---

### Phase 2: Setup Angular Frontend

#### Step 2.1: Create Angular App

```bash
cd front_end_code
ng new healthcare_plans_ui --routing --style=scss --ssr=false
cd healthcare_plans_ui
```

#### Step 2.2: Copy Files from Reference Repository

Copy these files/folders from the reference repository to your project:

| Copy From Repository | To Your Project |
|---------------------|-----------------|
| [angular.json](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/front_end_code/healthcare_plans_ui/angular.json) | `front_end_code/healthcare_plans_ui/angular.json` |
| [src/environments/](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/tree/main/front_end_code/healthcare_plans_ui/src/environments) | `src/environments/` |
| [src/app/models/](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/tree/main/front_end_code/healthcare_plans_ui/src/app/models) | `src/app/models/` |
| [src/app/core/](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/tree/main/front_end_code/healthcare_plans_ui/src/app/core) | `src/app/core/` |
| [src/app/features/](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/tree/main/front_end_code/healthcare_plans_ui/src/app/features) | `src/app/features/` |
| [src/app/app.routes.ts](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/front_end_code/healthcare_plans_ui/src/app/app.routes.ts) | `src/app/app.routes.ts` |
| [src/app/app.config.ts](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/front_end_code/healthcare_plans_ui/src/app/app.config.ts) | `src/app/app.config.ts` |
| [src/app/app.component.ts](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/front_end_code/healthcare_plans_ui/src/app/app.component.ts) | `src/app/app.component.ts` |
| [src/app/app.component.html](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/front_end_code/healthcare_plans_ui/src/app/app.component.html) | `src/app/app.component.html` |
| [src/app/app.component.scss](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/front_end_code/healthcare_plans_ui/src/app/app.component.scss) | `src/app/app.component.scss` |
| [src/styles.scss](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/front_end_code/healthcare_plans_ui/src/styles.scss) | `src/styles.scss` |

#### Step 2.3: Install Dependencies & Run

```bash
npm install bootstrap
npm install
ng serve --open
```

---

### Phase 3: Setup Django Backend

#### Step 3.1: Create Virtual Environment

```bash
cd ../../back_office
python -m venv venv
source venv/bin/activate  # Mac/Linux
# venv\Scripts\activate   # Windows
```

#### Step 3.2: Copy Files from Reference Repository

Copy these files from the reference repository:

| Copy From Repository | To Your Project |
|---------------------|-----------------|
| [requirements.txt](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/back_office/requirements.txt) | `back_office/requirements.txt` |
| [Dockerfile](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/back_office/Dockerfile) | `back_office/Dockerfile` |
| [.dockerignore](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/back_office/.dockerignore) | `back_office/.dockerignore` |

#### Step 3.3: Install Dependencies & Create Project

```bash
pip install -r requirements.txt
django-admin startproject healthcare_plans_bo .
python manage.py startapp accounts
mkdir -p accounts/api
touch accounts/api/__init__.py
mkdir -p healthcare_plans_bo/templates
```

#### Step 3.4: Copy Django Files from Reference Repository

| Copy From Repository | To Your Project |
|---------------------|-----------------|
| [healthcare_plans_bo/settings.py](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/back_office/healthcare_plans_bo/settings.py) | `healthcare_plans_bo/settings.py` |
| [healthcare_plans_bo/urls.py](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/back_office/healthcare_plans_bo/urls.py) | `healthcare_plans_bo/urls.py` |
| [healthcare_plans_bo/views.py](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/back_office/healthcare_plans_bo/views.py) | `healthcare_plans_bo/views.py` |
| [healthcare_plans_bo/templates/welcome.html](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/back_office/healthcare_plans_bo/templates/welcome.html) | `healthcare_plans_bo/templates/welcome.html` |
| [accounts/models.py](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/back_office/accounts/models.py) | `accounts/models.py` |
| [accounts/dao.py](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/back_office/accounts/dao.py) | `accounts/dao.py` |
| [accounts/services.py](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/back_office/accounts/services.py) | `accounts/services.py` |
| [accounts/admin.py](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/back_office/accounts/admin.py) | `accounts/admin.py` |
| [accounts/urls.py](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/back_office/accounts/urls.py) | `accounts/urls.py` |
| [accounts/api/serializers.py](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/back_office/accounts/api/serializers.py) | `accounts/api/serializers.py` |
| [accounts/api/views.py](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/back_office/accounts/api/views.py) | `accounts/api/views.py` |

#### Step 3.5: Run Migrations & Create Superuser

```bash
python manage.py makemigrations
python manage.py migrate
DJANGO_SUPERUSER_PASSWORD=admin python manage.py createsuperuser --noinput --email admin@admin.com --mobile 1234567890
python manage.py runserver
```

---

### Phase 4: Setup NPM Orchestration

#### Step 4.1: Copy package.json

Copy from repository root:

| Copy From Repository | To Your Project |
|---------------------|-----------------|
| [package.json](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/package.json) | `package.json` (root) |

#### Step 4.2: Use NPM Commands

```bash
# From repository root
npm run ui:start    # Start Angular
npm run api:start   # Start Django
```

---

### Phase 5: Setup GitHub Workflows

Copy all workflow files from the reference repository:

| Copy From Repository | To Your Project |
|---------------------|-----------------|
| [.github/workflows/](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/tree/main/.github/workflows) | `.github/workflows/` |

**Files to copy:**
- `gcp-initial-setup.yml`
- `deploy-django.yml`
- `deploy-angular.yml`
- `gcp-destroy-all.yml`

---

### Phase 6: Setup GCP Deployment

1. **Create GCP Project** - See [README_GoogleCloud_WhatYouShouldDo.md](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/README_GoogleCloud_WhatYouShouldDo.md)

2. **Create Service Account** with roles:
   - Cloud Run Admin
   - Storage Admin
   - Artifact Registry Administrator
   - Service Account User
   - Cloud SQL Admin
   - Cloud SQL Client
   - Secret Manager Admin
   - Service Usage Admin

3. **Add GitHub Secrets:**
   - `GCP_PROJECT_ID`
   - `GCP_SA_KEY`

4. **Run Workflows in order:**
   1. GCP Initial Setup (select: "all")
   2. Deploy Django Backend (select: "dev-server")
   3. Deploy Angular Frontend (select: "dev-server")

---

## Reference Documentation

| Document | Link |
|----------|------|
| Main README | [README.md](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/README.md) |
| Customer SignUp Design | [README_Customer_SignUp.md](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/README_Customer_SignUp.md) |
| App Development Guide | [README_App_Development.md](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/README_App_Development.md) |
| Developer Local Setup | [README_Developer_Local_Setup.md](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/README_Developer_Local_Setup.md) |
| For Students | [README_For_Students_Graduates.md](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/README_For_Students_Graduates.md) |
| For IT Professionals | [README_For_IT_Professionals.md](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/README_For_IT_Professionals.md) |
| GitHub Workflows Guide | [README_Github_Workflows.md](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/README_Github_Workflows.md) |
| GCP Setup Guide | [README_GoogleCloud_WhatYouShouldDo.md](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/README_GoogleCloud_WhatYouShouldDo.md) |

---

## Shell Scripts Reference

If you prefer using setup scripts:

| Script | Purpose | Link |
|--------|---------|------|
| `setup_00_angular_app_create.sh` | Create Angular app | [View](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/setup_00_angular_app_create.sh) |
| `setup_01_angular_next_steps.sh` | Angular folder structure | [View](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/setup_01_angular_next_steps.sh) |
| `setup_02_accounts_feature.sh` | Angular accounts feature | [View](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/setup_02_accounts_feature.sh) |
| `setup_03_django_accounts.sh` | Django backend setup | [View](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/setup_03_django_accounts.sh) |
| `fix_01_environments.sh` | Fix environment paths | [View](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/fix_01_environments.sh) |
| `fix_02_welcome_page.sh` | Add welcome page | [View](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/fix_02_welcome_page.sh) |
| `fix_03_welcome_page.sh` | Welcome page fixes | [View](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/fix_03_welcome_page.sh) |

---

## Testing Your Setup

| Test | URL | Expected |
|------|-----|----------|
| Angular App | http://localhost:4200 | Landing page |
| Angular Register | http://localhost:4200/register | Registration form |
| Angular Login | http://localhost:4200/login | Login form |
| Django Welcome | http://localhost:8000 | API documentation page |
| Django Admin | http://localhost:8000/admin | Admin login (admin@admin.com / admin) |
| Django API | http://localhost:8000/api/v1/accounts/register/ | DRF form |

---

## Troubleshooting

If you encounter issues, check:
- [README_Github_Workflows.md - Section 9: Troubleshooting](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/README_Github_Workflows.md#9-troubleshooting-common-errors)

Common fixes already applied in the repository:
- `app.config.ts` - `withInterceptorsFromDi()` for HTTP interceptor
- `settings.py` - `ALLOWED_HOSTS = ['*']`, `CSRF_TRUSTED_ORIGINS`, WhiteNoise
- `Dockerfile` - Migrations and superuser creation on startup

---

*Last Updated: December 2025*
