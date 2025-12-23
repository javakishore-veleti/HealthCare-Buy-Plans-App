# Django & Angular Configurations Guide

## Overview

This guide explains the key configurations in Django and Angular that enable them to communicate with each other - both in local development and on GCP Cloud Run.

**Reference Repository:** https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App

---

## Table of Contents

1. [Architecture Overview](#1-architecture-overview)
2. [Local Development Communication](#2-local-development-communication)
3. [GCP Cloud Run Communication](#3-gcp-cloud-run-communication)
4. [Angular Configurations](#4-angular-configurations)
5. [Django Configurations](#5-django-configurations)
6. [Configuration Files Reference](#6-configuration-files-reference)

---

## 1. Architecture Overview

### 1.1 How Angular Talks to Django

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           COMMUNICATION FLOW                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────────────┐         HTTP Request          ┌─────────────────┐    │
│   │                 │   ─────────────────────────▶  │                 │    │
│   │  Angular App    │   POST /api/v1/accounts/login │   Django API    │    │
│   │  (Frontend)     │   Authorization: Bearer JWT   │   (Backend)     │    │
│   │                 │                               │                 │    │
│   │                 │   ◀─────────────────────────  │                 │    │
│   │                 │        JSON Response          │                 │    │
│   └─────────────────┘   {access_token, user_data}   └─────────────────┘    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 1.2 Key Configuration Areas

| Area | Angular | Django |
|------|---------|--------|
| **API URL** | `environment.ts` | N/A |
| **CORS** | N/A | `settings.py` |
| **CSRF** | N/A | `settings.py` |
| **JWT Token** | `AuthInterceptor` | `settings.py` |
| **Allowed Hosts** | N/A | `settings.py` |

---

## 2. Local Development Communication

### 2.1 Local Setup

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         LOCAL DEVELOPMENT                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   Developer Machine                                                         │
│   ┌─────────────────────────────────────────────────────────────────────┐  │
│   │                                                                     │  │
│   │   ┌─────────────────┐              ┌─────────────────┐             │  │
│   │   │  Angular Dev    │   HTTP       │  Django Dev     │             │  │
│   │   │  Server         │ ──────────▶  │  Server         │             │  │
│   │   │                 │              │                 │             │  │
│   │   │  localhost:4200 │              │  localhost:8000 │             │  │
│   │   └─────────────────┘              └─────────────────┘             │  │
│   │         │                                   │                       │  │
│   │         │                                   │                       │  │
│   │         ▼                                   ▼                       │  │
│   │   Browser renders              SQLite Database                      │  │
│   │   UI components                (db.sqlite3)                         │  │
│   │                                                                     │  │
│   └─────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 2.2 Local URLs

| Service | URL |
|---------|-----|
| Angular App | `http://localhost:4200` |
| Django API | `http://localhost:8000/api/v1/` |
| Django Admin | `http://localhost:8000/admin/` |

### 2.3 Angular → Django (Local)

**Angular calls Django at:** `http://localhost:8000/api/v1/`

**Configuration in Angular:**
```
File: src/environments/environment.ts

apiBaseUrl: 'http://localhost:8000/api/v1'
```

**Django must allow Angular's origin:**
```
File: healthcare_plans_bo/settings.py

CORS_ALLOWED_ORIGINS = [
    'http://localhost:4200',
    'http://127.0.0.1:4200',
]
```

---

## 3. GCP Cloud Run Communication

### 3.1 Cloud Run Setup

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           GCP CLOUD RUN                                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   Google Cloud Platform                                                     │
│   ┌─────────────────────────────────────────────────────────────────────┐  │
│   │                                                                     │  │
│   │   ┌─────────────────┐              ┌─────────────────┐             │  │
│   │   │  Angular        │   HTTPS      │  Django         │             │  │
│   │   │  Cloud Run      │ ──────────▶  │  Cloud Run      │             │  │
│   │   │                 │              │                 │             │  │
│   │   │ healthcare-     │              │ healthcare-     │             │  │
│   │   │ plans-ui-dev    │              │ plans-api-dev   │             │  │
│   │   │ -xxx.run.app    │              │ -xxx.run.app    │             │  │
│   │   └─────────────────┘              └─────────────────┘             │  │
│   │         │                                   │                       │  │
│   │         │                                   │                       │  │
│   │         ▼                                   ▼                       │  │
│   │   Static files                     SQLite (in container)            │  │
│   │   served by Nginx                  or Cloud SQL (PostgreSQL)        │  │
│   │                                                                     │  │
│   └─────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 3.2 Cloud Run URLs

| Service | URL Pattern |
|---------|-------------|
| Angular App | `https://healthcare-plans-ui-{env}-{hash}.run.app` |
| Django API | `https://healthcare-plans-api-{env}-{hash}.run.app` |

### 3.3 Angular → Django (Cloud Run)

**Angular calls Django at:** `https://healthcare-plans-api-dev-xxx.run.app/api/v1/`

**Configuration set during deployment:**
```
File: src/environments/environment.ts (updated by GitHub workflow)

apiBaseUrl: 'https://healthcare-plans-api-dev-xxx.run.app/api/v1'
```

**Django must allow Cloud Run origins:**
```
File: healthcare_plans_bo/settings.py

ALLOWED_HOSTS = ['*']

CSRF_TRUSTED_ORIGINS = [
    'https://*.run.app',
    'https://*.a.run.app',
]

CORS_ALLOWED_ORIGINS = [
    'http://localhost:4200',      # Local dev
    'https://*.run.app',          # Cloud Run
]

# Or allow all for workshop:
CORS_ALLOW_ALL_ORIGINS = True
```

---

## 4. Angular Configurations

### 4.1 Environment Configuration

| File | Purpose |
|------|---------|
| `src/environments/environment.ts` | API URL for development |
| `src/environments/environment.prod.ts` | API URL for production |

**Key Setting:**
```typescript
export const environment = {
  production: false,
  apiBaseUrl: 'http://localhost:8000/api/v1'  // Django API URL
};
```

📄 **Reference:** [environment.ts](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/front_end_code/healthcare_plans_ui/src/environments/environment.ts)

---

### 4.2 Auth Service

| File | Purpose |
|------|---------|
| `src/app/core/auth/auth.service.ts` | Makes HTTP calls to Django API |

**Key Points:**
- Reads `apiBaseUrl` from environment
- Stores JWT token in `localStorage`
- Provides `login()`, `register()`, `logout()`, `getProfile()` methods

📄 **Reference:** [auth.service.ts](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/front_end_code/healthcare_plans_ui/src/app/core/auth/auth.service.ts)

---

### 4.3 Auth Interceptor

| File | Purpose |
|------|---------|
| `src/app/core/interceptors/auth.interceptor.ts` | Adds JWT token to every HTTP request |

**Key Points:**
- Intercepts all outgoing HTTP requests
- Adds `Authorization: Bearer <token>` header
- Automatically applied to all API calls

📄 **Reference:** [auth.interceptor.ts](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/front_end_code/healthcare_plans_ui/src/app/core/interceptors/auth.interceptor.ts)

---

### 4.4 App Configuration

| File | Purpose |
|------|---------|
| `src/app/app.config.ts` | Registers HTTP client and interceptor |

**Key Setting:**
```typescript
provideHttpClient(withInterceptorsFromDi())  // Enables interceptors
```

📄 **Reference:** [app.config.ts](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/front_end_code/healthcare_plans_ui/src/app/app.config.ts)

---

## 5. Django Configurations

### 5.1 Settings Overview

All Django configurations are in `healthcare_plans_bo/settings.py`:

📄 **Reference:** [settings.py](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/back_office/healthcare_plans_bo/settings.py)

---

### 5.2 CORS Configuration

**Purpose:** Allow Angular (different origin) to call Django API

| Setting | Purpose |
|---------|---------|
| `CORS_ALLOWED_ORIGINS` | List of allowed frontend URLs |
| `CORS_ALLOW_ALL_ORIGINS` | Allow any origin (dev only) |
| `CORS_ALLOW_CREDENTIALS` | Allow cookies/auth headers |

**Required Middleware:**
```python
MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',  # Must be near top
    ...
]
```

---

### 5.3 CSRF Configuration

**Purpose:** Protect against Cross-Site Request Forgery attacks

| Setting | Purpose |
|---------|---------|
| `CSRF_TRUSTED_ORIGINS` | Origins that can make POST requests |

**For Cloud Run:**
```python
CSRF_TRUSTED_ORIGINS = [
    'https://*.run.app',
    'https://*.a.run.app',
]
```

---

### 5.4 Allowed Hosts

**Purpose:** Which hostnames Django will respond to

| Setting | Purpose |
|---------|---------|
| `ALLOWED_HOSTS` | List of valid hostnames |

**For Cloud Run (workshop):**
```python
ALLOWED_HOSTS = ['*']  # Allow all for workshop
```

---

### 5.5 JWT Configuration

**Purpose:** Configure JSON Web Token authentication

| Setting | Purpose |
|---------|---------|
| `ACCESS_TOKEN_LIFETIME` | How long access token is valid |
| `REFRESH_TOKEN_LIFETIME` | How long refresh token is valid |
| `AUTH_HEADER_TYPES` | Expected header format (Bearer) |

📄 **Reference:** See `SIMPLE_JWT` section in [settings.py](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/back_office/healthcare_plans_bo/settings.py)

---

### 5.6 Static Files (WhiteNoise)

**Purpose:** Serve CSS/JS files in production

| Setting | Purpose |
|---------|---------|
| `STATIC_ROOT` | Where to collect static files |
| `WhiteNoiseMiddleware` | Serves static files efficiently |

**Required for Django Admin to load properly on Cloud Run.**

---

## 6. Configuration Files Reference

### 6.1 Angular Files

| File | Purpose | Link |
|------|---------|------|
| `environment.ts` | API URL configuration | [View](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/front_end_code/healthcare_plans_ui/src/environments/environment.ts) |
| `auth.service.ts` | HTTP calls to Django | [View](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/front_end_code/healthcare_plans_ui/src/app/core/auth/auth.service.ts) |
| `auth.interceptor.ts` | JWT token injection | [View](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/front_end_code/healthcare_plans_ui/src/app/core/interceptors/auth.interceptor.ts) |
| `app.config.ts` | HTTP client setup | [View](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/front_end_code/healthcare_plans_ui/src/app/app.config.ts) |

### 6.2 Django Files

| File | Purpose | Link |
|------|---------|------|
| `settings.py` | All Django settings | [View](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/back_office/healthcare_plans_bo/settings.py) |
| `urls.py` | API route configuration | [View](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/back_office/healthcare_plans_bo/urls.py) |
| `requirements.txt` | Python dependencies | [View](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/back_office/requirements.txt) |

### 6.3 Deployment Files

| File | Purpose | Link |
|------|---------|------|
| `Dockerfile` | Django container config | [View](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/back_office/Dockerfile) |
| `deploy-angular.yml` | Angular deployment workflow | [View](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/.github/workflows/deploy-angular.yml) |
| `deploy-django.yml` | Django deployment workflow | [View](https://github.com/javakishore-veleti/HealthCare-Buy-Plans-App/blob/main/.github/workflows/deploy-django.yml) |

---

## Quick Reference

### Local Development

| Component | URL | Configuration |
|-----------|-----|---------------|
| Angular | `http://localhost:4200` | `environment.ts` |
| Django | `http://localhost:8000` | `settings.py` |
| API Base | `http://localhost:8000/api/v1` | Both |

### GCP Cloud Run

| Component | URL | Configuration |
|-----------|-----|---------------|
| Angular | `https://healthcare-plans-ui-dev-xxx.run.app` | GitHub workflow sets API URL |
| Django | `https://healthcare-plans-api-dev-xxx.run.app` | `ALLOWED_HOSTS`, `CSRF_TRUSTED_ORIGINS` |
| API Base | `https://healthcare-plans-api-dev-xxx.run.app/api/v1` | Both |

---

*Last Updated: December 2025*
