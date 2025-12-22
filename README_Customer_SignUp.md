# Customer SignUp/Login Feature

## Objective

This document focuses on **Phase 1, Feature 1: Customer SignUp/Login** - a standalone feature that can be completed within a 2-hour workshop session.

---

## Workshop Agenda (2 Hours)

| Time | Duration | Activity |
|------|----------|----------|
| 0:00 | 5 min | Welcome & Introduction |
| 0:05 | 10 min | Business Requirements for SignUp/Login |
| 0:15 | 15 min | Noun-Verb Analysis - Identify Entities & Actions |
| 0:30 | 15 min | Data Model Design |
| 0:45 | 20 min | Setup Local Environment (Docker + Database) |
| 1:05 | 25 min | Django REST API Implementation |
| 1:30 | 15 min | Angular UI Overview |
| 1:45 | 10 min | Liquibase & GitHub Workflows Overview |
| 1:55 | 5 min | Q&A and Wrap-up |

---

## Part 1: Business Requirements

### 1.1 Feature Scope

From the CEO's strategic initiative:

> **Customer Experience** - Enable 24/7 self-service for healthcare plan discovery and purchase

The first step is allowing customers to **create an account** and **log in** to the platform.

### 1.2 User Stories

| ID | As a... | I want to... | So that... |
|----|---------|--------------|------------|
| US-001 | Customer | create an account with my email and mobile number | I can access the platform |
| US-002 | Customer | log in with my email and password | I can access my account securely |
| US-003 | Customer | log out from my account | my session is ended securely |
| US-004 | Customer | view my profile information | I can verify my details |
| US-005 | Customer | update my profile information | I can keep my details current |

### 1.3 Acceptance Criteria

**SignUp (US-001):**
- Customer provides: email, mobile number, password, full name
- Email must be unique in the system
- Mobile number must be 10 digits
- Password must be at least 8 characters
- System creates account and returns success message
- System returns error if email already exists

**Login (US-002):**
- Customer provides: email and password
- System validates credentials
- System returns JWT token on success
- System returns error on invalid credentials

**Logout (US-003):**
- Customer sends request with valid JWT token
- System invalidates the token
- System returns success message

**View Profile (US-004):**
- Customer sends request with valid JWT token
- System returns user profile information

**Update Profile (US-005):**
- Customer sends request with valid JWT token and updated data
- System updates profile and returns updated information

---

## Part 2: Noun-Verb Analysis

### 2.1 How to Identify Nouns and Verbs

Read the User Stories and Acceptance Criteria above.

- **Nouns** = Things/Objects → These become **Database Tables**
- **Verbs** = Actions → These become **API Endpoints**

### 2.2 Identified Nouns

| Noun | Description |
|------|-------------|
| Customer | Person who uses the platform |
| Account | Customer's login credentials |
| Email | Unique identifier for login |
| Mobile Number | Customer's phone number |
| Password | Secret key for authentication |
| Profile | Customer's personal information |
| JWT Token | Security token for authenticated requests |

### 2.3 Identified Verbs

| Verb | Description |
|------|-------------|
| Create Account | Register a new customer |
| Log In | Authenticate and get access |
| Log Out | End the session |
| View Profile | See personal information |
| Update Profile | Change personal information |
| Validate | Check if credentials are correct |

### 2.4 Mapping to Technical Components

| Nouns → | Database Tables |
|---------|-----------------|
| Customer + Account | `users` table |
| Profile | `user_profiles` table |

| Verbs → | API Endpoints |
|---------|---------------|
| Create Account | POST `/api/v1/accounts/register/` |
| Log In | POST `/api/v1/accounts/login/` |
| Log Out | POST `/api/v1/accounts/logout/` |
| View Profile | GET `/api/v1/accounts/profile/` |
| Update Profile | PATCH `/api/v1/accounts/profile/` |

---

## Part 3: Entities (Data Models)

### 3.1 Entity Relationship Diagram

```
┌─────────────────────────────────────┐
│              USERS                   │
├─────────────────────────────────────┤
│ id                                  │
│ email                               │
│ mobile                              │
│ password_hash                       │
│ is_active                           │
│ is_staff                            │
│ created_at                          │
│ updated_at                          │
└─────────────────┬───────────────────┘
                  │
                  │ One-to-One
                  ▼
┌─────────────────────────────────────┐
│          USER_PROFILES               │
├─────────────────────────────────────┤
│ id                                  │
│ user_id (links to users)            │
│ full_name                           │
│ date_of_birth                       │
│ gender                              │
│ address_line1                       │
│ address_line2                       │
│ city                                │
│ state                               │
│ pincode                             │
│ created_at                          │
│ updated_at                          │
└─────────────────────────────────────┘
```

### 3.2 Table: users

This table stores customer login credentials.

| Column | Type | Description |
|--------|------|-------------|
| id | Number (Auto) | Unique identifier |
| email | Text (255) | Login email - must be unique |
| mobile | Text (15) | Mobile number - 10 digits |
| password_hash | Text (255) | Encrypted password |
| is_active | Yes/No | Is account active? |
| is_staff | Yes/No | Is admin user? |
| created_at | Date & Time | When account was created |
| updated_at | Date & Time | When account was last updated |

### 3.3 Table: user_profiles

This table stores customer personal information.

| Column | Type | Description |
|--------|------|-------------|
| id | Number (Auto) | Unique identifier |
| user_id | Number | Links to users table |
| full_name | Text (255) | Customer's full name |
| date_of_birth | Date | Date of birth |
| gender | Text (10) | Male / Female / Other |
| address_line1 | Text (255) | Street address |
| address_line2 | Text (255) | Apartment, floor, etc. |
| city | Text (100) | City name |
| state | Text (100) | State name |
| pincode | Text (10) | PIN code - 6 digits |
| created_at | Date & Time | When profile was created |
| updated_at | Date & Time | When profile was last updated |

---

## Part 4: Django REST APIs

### 4.1 API Overview

| API | Method | URL | Description | Authentication |
|-----|--------|-----|-------------|----------------|
| Register | POST | `/api/v1/accounts/register/` | Create new account | Not required |
| Login | POST | `/api/v1/accounts/login/` | Get JWT token | Not required |
| Logout | POST | `/api/v1/accounts/logout/` | End session | Required |
| Get Profile | GET | `/api/v1/accounts/profile/` | View profile | Required |
| Update Profile | PATCH | `/api/v1/accounts/profile/` | Edit profile | Required |

### 4.2 Register API

**What customer sends:**
- email
- mobile
- password
- full_name

**What system returns (Success):**
- id
- email
- message: "Registration successful"

**What system returns (Error):**
- error: "Email already exists"

### 4.3 Login API

**What customer sends:**
- email
- password

**What system returns (Success):**
- access_token (JWT token for making authenticated requests)
- refresh_token (JWT token for getting new access token)
- expires_in (seconds until token expires)

**What system returns (Error):**
- error: "Invalid credentials"

### 4.4 Logout API

**What customer sends:**
- Authorization header with JWT token

**What system returns:**
- message: "Logout successful"

### 4.5 Get Profile API

**What customer sends:**
- Authorization header with JWT token

**What system returns:**
- All profile information (email, mobile, full_name, address, etc.)

### 4.6 Update Profile API

**What customer sends:**
- Authorization header with JWT token
- Fields to update (any combination of: full_name, date_of_birth, gender, address, city, state, pincode)

**What system returns:**
- Updated profile information

---

## Part 5: Angular UI Pages

### 5.1 Pages Overview

| Page | URL | Description |
|------|-----|-------------|
| Registration Page | `/register` | Form to create new account |
| Login Page | `/login` | Form to sign in |
| Profile Page | `/profile` | View and edit profile |

### 5.2 Registration Page

**What customer sees:**
- Form with fields: Email, Mobile Number, Password, Confirm Password, Full Name
- "Register" button
- Link to Login page ("Already have an account? Login here")

**What happens:**
- Customer fills the form and clicks "Register"
- Angular calls the Register API
- On success: Shows success message and redirects to Login page
- On error: Shows error message (e.g., "Email already exists")

### 5.3 Login Page

**What customer sees:**
- Form with fields: Email, Password
- "Login" button
- Link to Registration page ("Don't have an account? Register here")

**What happens:**
- Customer fills the form and clicks "Login"
- Angular calls the Login API
- On success: Stores JWT token and redirects to Profile page
- On error: Shows error message ("Invalid email or password")

### 5.4 Profile Page

**What customer sees:**
- Display of current profile information
- "Edit" button to enable editing
- Form fields (disabled by default): Full Name, Date of Birth, Gender, Address, City, State, Pincode
- "Save" and "Cancel" buttons (visible when editing)
- "Logout" button

**What happens:**
- On page load: Angular calls Get Profile API and displays data
- On "Edit" click: Form fields become editable
- On "Save" click: Angular calls Update Profile API
- On "Logout" click: Angular calls Logout API and redirects to Login page

---

## Part 6: Database Migration & Deployment

### 6.1 Database Migration with Liquibase

| Environment | Database | Trigger |
|-------------|----------|---------|
| Local | MySQL or PostgreSQL (Docker) | Manual command |
| GCP Dev | Cloud SQL (PostgreSQL) | On-demand GitHub Workflow |
| GCP Production | Cloud SQL (PostgreSQL) | On-demand GitHub Workflow (with approval) |

### 6.2 GitHub Workflows (On-Demand)

We use **manual trigger** instead of automatic because database changes need careful review before applying.

| Workflow | Purpose | Trigger |
|----------|---------|---------|
| Run DB Migration (Dev) | Apply Liquibase changes to dev | Manual |
| Run DB Migration (Prod) | Apply Liquibase changes to prod | Manual (with approval) |
| Deploy Backend (Dev) | Deploy Django to GCP dev | Manual |
| Deploy Backend (Prod) | Deploy Django to GCP prod | Manual (with approval) |
| Deploy Frontend (Dev) | Deploy Angular to GCP dev | Manual |
| Deploy Frontend (Prod) | Deploy Angular to GCP prod | Manual (with approval) |

---

## Summary

| Component | Technology | Purpose |
|-----------|------------|---------|
| Database Tables | MySQL / PostgreSQL | Store user data |
| Database Migration | Liquibase | Manage table changes |
| Backend API | Django REST Framework | Handle business logic |
| Frontend UI | Angular + Bootstrap | User interface |
| Deployment | GitHub Workflows | Deploy to GCP (on-demand) |

---

## Next Steps

After completing this feature, we will implement:
1. **Health Plan Catalog** - Browse and search plans
2. **Shopping Cart** - Add plans to cart
3. **Checkout & Payment** - Purchase plans

---

*This document is part of the HealthCare-Buy-Plans-App workshop.*
