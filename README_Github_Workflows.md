# GitHub Workflows Guide

## Overview

This repository uses **GitHub Actions** for CI/CD (Continuous Integration/Continuous Deployment). GitHub Actions automates building, testing, and deploying the application to Google Cloud Platform.

---

## Table of Contents

1. [What is GitHub Actions?](#1-what-is-github-actions)
2. [Workflows in This Repository](#2-workflows-in-this-repository)
3. [GCP Initial Setup Workflow](#3-gcp-initial-setup-workflow)
4. [Deploy Django Backend Workflow](#4-deploy-django-backend-workflow)
5. [Deploy Angular Frontend Workflow](#5-deploy-angular-frontend-workflow)
6. [GCP Destroy Resources Workflow](#6-gcp-destroy-resources-workflow)
7. [Setting Up GitHub Secrets](#7-setting-up-github-secrets)
8. [How to Run Workflows](#8-how-to-run-workflows)
9. [Troubleshooting Common Errors](#9-troubleshooting-common-errors)
10. [Best Practices](#10-best-practices)

---

## 1. What is GitHub Actions?

### 1.1 Introduction

GitHub Actions is a CI/CD platform built into GitHub. It allows you to automate tasks when certain events happen in your repository (like pushing code or creating a pull request).

```
┌─────────────────────────────────────────────────────────────────┐
│                     GITHUB ACTIONS FLOW                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   Developer                GitHub                  GCP          │
│      │                        │                     │           │
│      │  git push              │                     │           │
│      │───────────────────────▶│                     │           │
│      │                        │                     │           │
│      │                        │  Trigger Workflow   │           │
│      │                        │────────────────────▶│           │
│      │                        │                     │           │
│      │                        │  Build Docker       │           │
│      │                        │  Push Image         │           │
│      │                        │  Deploy to Cloud Run│           │
│      │                        │                     │           │
│      │                        │  ✅ Success         │           │
│      │                        │◀────────────────────│           │
│      │  Notification          │                     │           │
│      │◀───────────────────────│                     │           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

### 1.2 Key Concepts

| Concept | Description | Example |
|---------|-------------|---------|
| **Workflow** | Automated process defined in YAML file | `deploy-django.yml` |
| **Event** | Trigger that starts a workflow | `push`, `pull_request`, `workflow_dispatch` |
| **Job** | Set of steps that run on same machine | `build`, `test`, `deploy` |
| **Step** | Individual task in a job | `Checkout code`, `Build Docker image` |
| **Runner** | Server that runs the workflow | `ubuntu-latest`, `windows-latest` |
| **Secret** | Encrypted variable for sensitive data | `GCP_SA_KEY`, `GCP_PROJECT_ID` |

---

### 1.3 Workflow File Location

All workflow files are stored in:
```
.github/
└── workflows/
    ├── gcp-initial-setup.yml      # One-time GCP setup
    ├── deploy-django.yml          # Deploy Django backend
    ├── deploy-angular.yml         # Deploy Angular frontend
    └── gcp-destroy-all.yml        # Cleanup resources
```

---

## 2. Workflows in This Repository

### 2.1 Workflow Summary

| Workflow | File | Purpose | Trigger |
|----------|------|---------|---------|
| **GCP Initial Setup** | `gcp-initial-setup.yml` | Enable APIs, create resources | Manual |
| **Deploy Django Backend** | `deploy-django.yml` | Build & deploy Django to Cloud Run | Manual |
| **Deploy Angular Frontend** | `deploy-angular.yml` | Build & deploy Angular to Cloud Run | Manual |
| **GCP Destroy Resources** | `gcp-destroy-all.yml` | Delete resources to save costs | Manual |

---

### 2.2 Environment Strategy

All deployment workflows support multiple environments:

| Environment | Purpose | When to Use |
|-------------|---------|-------------|
| **dev-server** | Development testing | After each feature branch merge |
| **qa-server** | QA team testing | After features are complete |
| **pre-prod-server** | Pre-production testing | Before production release |
| **prod-server** | Live production | After all approvals |

```
┌─────────────────────────────────────────────────────────────────┐
│                    DEPLOYMENT PIPELINE                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Feature Branch ──▶ dev-server ──▶ qa-server ──▶ prod-server   │
│                          │              │              │        │
│                     Developer       QA Team        Users        │
│                      Testing        Testing        Live         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 3. GCP Initial Setup Workflow

### 3.1 Purpose

This workflow sets up all required GCP resources **before** you can deploy your application. Run this **once** when setting up the project.

**File:** `.github/workflows/gcp-initial-setup.yml`

---

### 3.2 What It Does

| Step | Action | Details |
|------|--------|---------|
| 1 | Enable GCP APIs | Artifact Registry, Cloud Run, Cloud SQL, Secret Manager |
| 2 | Create Artifact Registry | Docker image repository named `healthcare-plans` |
| 3 | Create Cloud SQL (Optional) | PostgreSQL instances for each environment |
| 4 | Create Secrets (Optional) | Django secret keys and DB passwords |

---

### 3.3 Dropdown Options

```
┌─────────────────────────────────────────────┐
│  Select setup to run *                      │
├─────────────────────────────────────────────┤
│  ┌─────────────────────────────────────┐   │
│  │ all (Complete Setup)              ▼ │   │
│  ├─────────────────────────────────────┤   │
│  │ all (Complete Setup)                │   │
│  │ enable-apis-only                    │   │
│  │ create-artifact-registry-only       │   │
│  │ create-cloud-sql-only               │   │
│  │ create-secrets-only                 │   │
│  └─────────────────────────────────────┘   │
└─────────────────────────────────────────────┘
```

| Option | What It Does |
|--------|--------------|
| **all (Complete Setup)** | Runs all steps - use for first-time setup |
| **enable-apis-only** | Only enables required GCP APIs |
| **create-artifact-registry-only** | Only creates Docker repository |
| **create-cloud-sql-only** | Only creates database instances |
| **create-secrets-only** | Only creates Secret Manager secrets |

---

### 3.4 APIs Enabled

| API | Purpose |
|-----|---------|
| `artifactregistry.googleapis.com` | Store Docker images |
| `run.googleapis.com` | Run containers (Cloud Run) |
| `sqladmin.googleapis.com` | Managed databases (Cloud SQL) |
| `secretmanager.googleapis.com` | Store secrets securely |
| `cloudbuild.googleapis.com` | Build Docker images |
| `compute.googleapis.com` | Virtual machines, networking |
| `servicenetworking.googleapis.com` | VPC networking for Cloud SQL |

---

### 3.5 When to Run

- ✅ **First time** setting up the project
- ✅ When you need to **add missing resources**
- ✅ After **deleting resources** and need to recreate
- ❌ Not needed for regular deployments

---

## 4. Deploy Django Backend Workflow

### 4.1 Purpose

Builds and deploys the Django REST API to Google Cloud Run.

**File:** `.github/workflows/deploy-django.yml`

---

### 4.2 What It Does

```
┌─────────────────────────────────────────────────────────────────┐
│                  DEPLOY DJANGO WORKFLOW                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Step 1: Checkout Code                                          │
│     └── git clone repository                                    │
│                                                                 │
│  Step 2: Set Environment Variables                              │
│     └── Configure based on selected environment                 │
│                                                                 │
│  Step 3: Authenticate to GCP                                    │
│     └── Use service account credentials                         │
│                                                                 │
│  Step 4: Build Docker Image                                     │
│     └── docker build -t healthcare-plans-api-{env}              │
│                                                                 │
│  Step 5: Push to Artifact Registry                              │
│     └── docker push to asia-south1-docker.pkg.dev               │
│                                                                 │
│  Step 6: Run Migrations (Optional)                              │
│     └── python manage.py migrate                                │
│                                                                 │
│  Step 7: Deploy to Cloud Run                                    │
│     └── gcloud run deploy                                       │
│                                                                 │
│  Step 8: Output URL                                             │
│     └── https://healthcare-plans-api-{env}-xxx.run.app          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

### 4.3 Dropdown Options

```
┌─────────────────────────────────────────────┐
│  Run workflow                               │
├─────────────────────────────────────────────┤
│  Branch: main                          ▼    │
│                                             │
│  Select deployment environment *            │
│  ┌─────────────────────────────────────┐   │
│  │ dev-server                        ▼ │   │
│  ├─────────────────────────────────────┤   │
│  │ dev-server                          │   │
│  │ qa-server                           │   │
│  │ pre-prod-server                     │   │
│  │ prod-server                         │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ☑ Run database migrations?                 │
│                                             │
│  [Run workflow]                             │
└─────────────────────────────────────────────┘
```

---

### 4.4 Environment Configuration

| Environment | Service Name | Min Instances | Max Instances | Memory | CPU |
|-------------|--------------|---------------|---------------|--------|-----|
| **dev-server** | `healthcare-plans-api-dev` | 0 | 2 | 512Mi | 1 |
| **qa-server** | `healthcare-plans-api-qa` | 0 | 3 | 512Mi | 1 |
| **pre-prod-server** | `healthcare-plans-api-preprod` | 1 | 5 | 1Gi | 2 |
| **prod-server** | `healthcare-plans-api-prod` | 2 | 10 | 2Gi | 2 |

**Note:** 
- `Min Instances = 0` means the service scales to zero when not in use (saves cost)
- `Min Instances > 0` keeps containers always running (no cold start, higher cost)

---

### 4.5 Output

After successful deployment:
```
==========================================
✅ Deployment Complete!
==========================================

Environment: dev-server
Service: healthcare-plans-api-dev
URL: https://healthcare-plans-api-dev-rkltlgdlva-el.a.run.app
Image: asia-south1-docker.pkg.dev/project-id/healthcare-plans/healthcare-plans-api-dev:abc123
Migrations: true
```

---

## 5. Deploy Angular Frontend Workflow

### 5.1 Purpose

Builds and deploys the Angular frontend to Google Cloud Run.

**File:** `.github/workflows/deploy-angular.yml`

---

### 5.2 What It Does

```
┌─────────────────────────────────────────────────────────────────┐
│                  DEPLOY ANGULAR WORKFLOW                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Step 1: Checkout Code                                          │
│     └── git clone repository                                    │
│                                                                 │
│  Step 2: Set Environment Variables                              │
│     └── Set API_URL based on environment                        │
│                                                                 │
│  Step 3: Setup Node.js                                          │
│     └── Install Node.js 20                                      │
│                                                                 │
│  Step 4: Install Dependencies                                   │
│     └── npm ci                                                  │
│                                                                 │
│  Step 5: Update Environment Config                              │
│     └── Set API URL in environment.ts                           │
│                                                                 │
│  Step 6: Build Angular App                                      │
│     └── ng build --configuration={env}                          │
│                                                                 │
│  Step 7: Create Dockerfile & nginx.conf                         │
│     └── Nginx to serve static files                             │
│                                                                 │
│  Step 8: Build Docker Image                                     │
│     └── docker build -t healthcare-plans-ui-{env}               │
│                                                                 │
│  Step 9: Push to Artifact Registry                              │
│     └── docker push to asia-south1-docker.pkg.dev               │
│                                                                 │
│  Step 10: Deploy to Cloud Run                                   │
│     └── gcloud run deploy                                       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

### 5.3 Environment Configuration

| Environment | API URL | Build Config |
|-------------|---------|--------------|
| **dev-server** | `https://healthcare-plans-api-dev-xxx.run.app` | development |
| **qa-server** | `https://healthcare-plans-api-qa-xxx.run.app` | qa |
| **pre-prod-server** | `https://healthcare-plans-api-preprod-xxx.run.app` | preprod |
| **prod-server** | `https://healthcare-plans-api-prod-xxx.run.app` | production |

---

### 5.4 How Angular Connects to Django

The workflow automatically updates the Angular environment file with the correct API URL:

```typescript
// Generated environment.{env}.ts
export const environment = {
  production: true,  // false for dev
  apiBaseUrl: 'https://healthcare-plans-api-dev-xxx.run.app/api/v1',
  appName: 'Your Health Plans',
  environment: 'dev-server'
};
```

---

## 6. GCP Destroy Resources Workflow

### 6.1 Purpose

Deletes GCP resources to **stop incurring costs**. Use this when you're done testing or want to clean up.

**File:** `.github/workflows/gcp-destroy-all.yml`

---

### 6.2 Safety Features

This workflow has multiple safety features to prevent accidental deletion:

```
┌─────────────────────────────────────────────┐
│  Run workflow                               │
├─────────────────────────────────────────────┤
│                                             │
│  Select what to destroy *                   │
│  ┌─────────────────────────────────────┐   │
│  │ all (DESTROY EVERYTHING)          ▼ │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  Select environment *                       │
│  ┌─────────────────────────────────────┐   │
│  │ dev                               ▼ │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  Type "DESTROY" to confirm *                │
│  ┌─────────────────────────────────────┐   │
│  │ DESTROY                             │   │  ⚠️ Must type exactly
│  └─────────────────────────────────────┘   │
│                                             │
│  [Run workflow]                             │
└─────────────────────────────────────────────┘
```

**Safety Check:** You must type `DESTROY` (all caps) to confirm. Any other value will abort the workflow.

---

### 6.3 Dropdown Options

**What to Destroy:**

| Option | Deletes |
|--------|---------|
| **all (DESTROY EVERYTHING)** | Cloud Run + Cloud SQL + Docker Images + Secrets |
| **cloud-run-only** | Cloud Run services only |
| **cloud-sql-only** | Cloud SQL databases only |
| **artifact-registry-only** | Docker images only |
| **secrets-only** | Secret Manager secrets only |

**Environment:**

| Option | Scope |
|--------|-------|
| **all** | All environments (dev, qa, preprod, prod) |
| **dev** | Only dev resources |
| **qa** | Only qa resources |
| **preprod** | Only preprod resources |
| **prod** | Only prod resources |

---

### 6.4 What Gets Deleted

| Resource Type | Resource Names |
|---------------|----------------|
| **Cloud Run Services** | `healthcare-plans-api-{env}`, `healthcare-plans-ui-{env}` |
| **Cloud Run Jobs** | `migrate-db-{env}` |
| **Cloud SQL Instances** | `healthcare-plans-db-{env}` |
| **Docker Images** | All images in `healthcare-plans` repository |
| **Secrets** | `healthcare-plans-{env}-django-secret-key`, `healthcare-plans-{env}-db-password` |

---

### 6.5 When to Use

- ✅ End of workshop/demo - clean up to avoid charges
- ✅ Delete unused environments (e.g., delete qa after testing)
- ✅ Start fresh - delete everything and redeploy
- ⚠️ **Never run on prod** unless you really mean it!

---

## 7. Setting Up GitHub Secrets

### 7.1 Required Secrets

| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `GCP_PROJECT_ID` | Your GCP project ID | GCP Console → Project dropdown |
| `GCP_SA_KEY` | Service Account JSON key | See steps below |

---

### 7.2 Creating Service Account (GCP Console)

**Step 1:** Go to GCP Console → **IAM & Admin** → **Service Accounts**

**Step 2:** Click **+ CREATE SERVICE ACCOUNT**

**Step 3:** Fill in details:
- **Name:** `healthcare-buy-plans-app-github-sa`
- **Description:** `Service account for GitHub Actions deployments`

**Step 4:** Grant roles:
- Cloud Run Admin
- Storage Admin
- Artifact Registry Administrator
- Service Account User
- Cloud SQL Admin
- Cloud SQL Client
- Secret Manager Admin

**Step 5:** Create key:
- Click on the service account
- Go to **KEYS** tab
- Click **ADD KEY** → **Create new key**
- Select **JSON**
- Download the file

---

### 7.3 Adding Secrets to GitHub

**Step 1:** Go to your GitHub repository

**Step 2:** Click **Settings** → **Secrets and variables** → **Actions**

**Step 3:** Click **New repository secret**

**Step 4:** Add secrets:

| Name | Value |
|------|-------|
| `GCP_PROJECT_ID` | `your-gcp-project-id` |
| `GCP_SA_KEY` | *Paste entire JSON content from downloaded file* |

---

## 8. How to Run Workflows

### 8.1 Manual Trigger (workflow_dispatch)

All workflows in this repository use `workflow_dispatch` - they must be triggered manually:

**Step 1:** Go to your GitHub repository

**Step 2:** Click **Actions** tab

**Step 3:** Select the workflow (e.g., "Deploy Django Backend")

**Step 4:** Click **Run workflow**

**Step 5:** Fill in the options (environment, migrations, etc.)

**Step 6:** Click **Run workflow** button

---

### 8.2 Viewing Workflow Progress

After triggering:

1. Click on the running workflow
2. Click on the job (e.g., "Deploy to dev-server")
3. View real-time logs for each step
4. Green checkmark = success, Red X = failure

---

### 8.3 Typical Deployment Sequence

For a new project, run workflows in this order:

```
1. GCP Initial Setup (select: "all (Complete Setup)")
      │
      ▼
2. Deploy Django Backend (select: "dev-server")
      │
      ▼
3. Deploy Angular Frontend (select: "dev-server")
      │
      ▼
4. Test the application
      │
      ▼
5. Repeat steps 2-4 for qa-server, pre-prod-server, prod-server
```

---

## 9. Troubleshooting Common Errors

### 9.1 Authentication Errors

**Error:**
```
google-github-actions/auth failed with: the GitHub Action workflow must specify 
exactly one of "workload_identity_provider" or "credentials_json"
```

**Solution:** 
- Make sure `GCP_SA_KEY` secret is added to GitHub
- Verify the JSON is complete (not truncated)

---

### 9.2 Permission Denied

**Error:**
```
permission: artifactregistry.repositories.create
reason: IAM_PERMISSION_DENIED
```

**Solution:**
- Add **Artifact Registry Administrator** role to service account
- Wait 1-2 minutes for permission to propagate

---

### 9.3 API Not Enabled

**Error:**
```
Artifact Registry API has not been used in project xxx before or it is disabled
```

**Solution:**
- Run the **GCP Initial Setup** workflow with "enable-apis-only" option
- Or manually enable the API in GCP Console

---

### 9.4 Repository Not Found

**Error:**
```
Repository "healthcare-plans" not found
```

**Solution:**
- Run the **GCP Initial Setup** workflow with "create-artifact-registry-only" option

---

### 9.5 ALLOWED_HOSTS Error

**Error:**
```
DisallowedHost at /
Invalid HTTP_HOST header: 'xxx.run.app'
```

**Solution:**
- Update `settings.py`:
```python
ALLOWED_HOSTS = ['*']  # For workshop
# Or specific hosts for production
```

---

### 9.6 CSRF Error

**Error:**
```
CSRF verification failed. Request aborted.
Origin checking failed - https://xxx.run.app does not match any trusted origins.
```

**Solution:**
- Add to `settings.py`:
```python
CSRF_TRUSTED_ORIGINS = [
    'https://*.run.app',
    'https://*.a.run.app',
]
```

---

### 9.7 Static Files Not Loading

**Error:** Django Admin CSS not loading (unstyled page)

**Solution:**
1. Add `whitenoise` to `requirements.txt`
2. Update `settings.py`:
```python
STATIC_ROOT = BASE_DIR / 'staticfiles'
MIDDLEWARE.insert(1, 'whitenoise.middleware.WhiteNoiseMiddleware')
```

---

### 9.8 Database Table Not Found

**Error:**
```
OperationalError: no such table: users
```

**Solution:**
- Update `Dockerfile` to run migrations on startup:
```dockerfile
CMD python manage.py migrate --noinput && \
    DJANGO_SUPERUSER_PASSWORD=admin python manage.py createsuperuser --noinput --email admin@admin.com --mobile 1234567890 || true && \
    exec gunicorn ...
```

---

## 10. Best Practices

### 10.1 Workflow Best Practices

| Practice | Why |
|----------|-----|
| **Use environment dropdown** | Prevents accidental production deployments |
| **Run GCP Setup first** | Creates required resources before deploy |
| **Test in dev first** | Catch issues before they reach production |
| **Use destroy workflow** | Clean up resources to save costs |
| **Check logs on failure** | GitHub shows detailed error messages |

---

### 10.2 Security Best Practices

| Practice | Why |
|----------|-----|
| **Never commit secrets** | Use GitHub Secrets instead |
| **Limit service account roles** | Principle of least privilege |
| **Use different service accounts per environment** | Isolate production access |
| **Rotate keys periodically** | Reduce risk of compromised keys |

---

### 10.3 Cost Management

| Practice | Savings |
|----------|---------|
| **Set min_instances=0 for dev** | No cost when idle |
| **Delete unused environments** | Use destroy workflow |
| **Use SQLite for dev** | No Cloud SQL cost |
| **Monitor billing alerts** | GCP Console → Billing → Budgets |

---

## Quick Reference

### Workflow Commands

| Action | Workflow | Option |
|--------|----------|--------|
| First-time setup | GCP Initial Setup | all (Complete Setup) |
| Deploy backend | Deploy Django Backend | Select environment |
| Deploy frontend | Deploy Angular Frontend | Select environment |
| Delete dev resources | GCP Destroy Resources | dev + DESTROY |
| Delete all resources | GCP Destroy Resources | all + DESTROY |

### Service URLs (After Deployment)

| Service | URL Pattern |
|---------|-------------|
| Django API (dev) | `https://healthcare-plans-api-dev-{hash}.run.app` |
| Angular UI (dev) | `https://healthcare-plans-ui-dev-{hash}.run.app` |
| Django Admin | `https://healthcare-plans-api-dev-{hash}.run.app/admin/` |

### Default Credentials

| Portal | Email | Password |
|--------|-------|----------|
| Django Admin | admin@admin.com | admin |

---

*Last Updated: December 2025*
