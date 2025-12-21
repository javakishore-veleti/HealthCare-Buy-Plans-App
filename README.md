# HealthCare-Buy-Plans-App

## Objective
This repository is created to demonstrate how a real Healthcare business application is developed from scratch and evolves as a web application. It is designed for 3rd year and 4th year engineering students at my engineering college, with me presenting as an Alumni.

## "Your Health Plans" - Healthcare Insurance E-Commerce Platform

A full-stack web application that enables customers to browse, compare, and purchase healthcare insurance plans online with a seamless shopping cart experience.

**Tech Stack:** Python + Django REST Framework | Angular 17 + Bootstrap 5 | PostgreSQL/MySQL | Google Cloud Platform

---

## Table of Contents

1. [Business Scenario](#part-1-business-scenario)
2. [System Architecture Overview](#part-2-system-architecture-overview)
3. [Requirements Analysis](#part-3-requirements-analysis)
4. [Django Apps Structure](#part-4-django-apps-structure)
5. [J2EE-Style Layered Architecture](#part-5-j2ee-style-layered-architecture)
6. [Technology Stack](#part-6-technology-stack)
7. [Entity Relationship Diagram](#part-7-entity-relationship-diagram)
8. [API Endpoints Design](#part-8-api-endpoints-design)
9. [Solution Architecture](#part-9-solution-architecture)
10. [Chatbot & Workflow Architecture (Phase 2)](#part-10-chatbot--workflow-architecture-phase-2)
11. [Getting Started](#part-11-getting-started)

---

## Part 1: Business Scenario

### 1.1 CEO's Strategic Vision

**From:** Rajesh Kumar, CEO - YourHealthFirst Insurance Ltd (a fictitious company)  
**To:** Executive Leadership Team  
**Subject:** Strategic Initiative Q1 2026 - Digital Transformation

---

*"Team,*

*As we enter 2026, our healthcare insurance market is rapidly evolving. Customers expect seamless digital experiences, and our competitors are already offering online plan purchases. To maintain our market leadership and drive growth, I am announcing our top strategic priorities:*

**Strategic Objectives:**

1. **Growth** - Expand our customer base by 40% through digital channels (web, mobile, partners, airport kiosks, and other marketplaces)

2. **Customer Experience** - Enable 24/7 self-service for healthcare plan discovery and purchase

3. **Operational Efficiency** - Reduce manual processing by automating customer signup and plan enrollment

4. **Innovation** - Use AI/ML for personalized plan recommendations

**Investment:** *I have secured board approval for a ₹100 Crores (approx. $10 million) budget for this digital initiative.*

**Timeline:** *We need the first phase live within 2 months to capture the upcoming New Year season.*

*I am asking our Business Leaders and Enterprise Architecture team to collaborate and define the product scope. Let's make this happen!*

*- Rajesh Kumar, CEO"*

---

### 1.2 Business & Enterprise Architect Collaboration

**Meeting Notes: Product Definition Workshop**  
**Attendees:** Priya Sharma (VP Business), Venkat Rao (Enterprise Architect), Anita Reddy (Product Owner)

---

**Product Name:** **"Your Health Plans"**

**Product Vision:**  
A customer-facing website that allows individuals and families to search, compare, and purchase healthcare insurance plans online with a seamless shopping cart experience.

**Target Users:**

| User Type | Description |
|-----------|-------------|
| **Customer** | Individuals/families looking to buy health insurance plans |
| **Admin** | HealthFirst staff managing plans, orders, and customer queries |
| **System** | Automated workflows for payment processing and notifications |

**Core Capabilities Identified:**

```
┌─────────────────────────────────────────────────────────────────┐
│                    "YOUR HEALTH PLANS" PLATFORM                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  👤 CUSTOMER JOURNEY                                            │
│  ─────────────────────────────────────────────────────────────  │
│  [Browse Plans] → [Compare] → [Add to Cart] → [Checkout] → [Pay]│
│                                                                 │
│  🔐 ACCOUNT MANAGEMENT                                          │
│  ─────────────────────────────────────────────────────────────  │
│  [Sign Up] → [Login] → [View Profile] → [Order History]         │
│                                                                 │
│  🤖 AI ASSISTANT (Phase 2)                                      │
│  ─────────────────────────────────────────────────────────────  │
│  [Chat] → [Plan Recommendations] → [FAQ Answers]                │
│                                                                 │
│  🔧 ADMIN OPERATIONS                                            │
│  ─────────────────────────────────────────────────────────────  │
│  [Manage Plans] → [View Orders] → [Process Enrollments]         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Phase 1 Scope (2 Months - ₹40 Cr):**
- Customer signup/login
- Plan catalog browsing
- Shopping cart
- Basic checkout with payment gateway
- Admin plan management

**Phase 2 Scope (Future):**
- AI Chatbot for plan recommendations
- Workflow automation for enrollment processing
- Family plan management
- Document upload for KYC

---

### 1.3 Business Requirements Document (BRD)

**Prepared by:** Anita Reddy, Product Owner  
**Version:** 1.0

---

#### Business Requirements - "Your Health Plans" Platform

**Paragraph 1: Customer Experience Requirements**

The platform shall enable customers to create an account using their email and mobile number, with secure password-based authentication. Once logged in, customers shall be able to browse the complete catalog of healthcare plans offered by HealthFirst, including Individual Plans, Family Floater Plans, and Senior Citizen Plans. Each plan listing shall display the plan name, coverage amount, premium (monthly/annual), key benefits, and waiting periods. Customers shall be able to add one or more plans to their shopping cart, review the cart contents, modify quantities or remove items, and proceed to checkout. The checkout process shall collect the customer's personal details and redirect to a secure payment gateway for processing. Upon successful payment, the system shall generate an order confirmation and send a confirmation email to the customer. Customers shall be able to view their order history and download policy documents from their account dashboard.

**Paragraph 2: Admin and System Requirements**

The platform shall provide an administrative interface for HealthFirst staff to manage the healthcare plan catalog, including the ability to add new plans, update pricing and benefits, activate or deactivate plans, and organize plans by category. Administrators shall have access to view all customer orders, update order status (processing, approved, policy issued), and handle cancellation requests. The system shall integrate with a payment gateway to process premium payments securely, with support for credit/debit cards and UPI. For Phase 2, the platform shall include an AI-powered chatbot that can answer frequently asked questions about plans, help customers compare plans based on their requirements (age, family size, budget), and guide them through the purchase process. The chatbot shall be built using workflow automation tools available on Google Cloud Platform to orchestrate conversations and integrate with the plan recommendation engine.

---

## Part 2: System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                                         USERS                                            │
├───────────────────────────────────────────┬─────────────────────────────────────────────┤
│              👤 CUSTOMERS                  │              👨‍💼 ADMINS                       │
│     (Individuals & Families)              │        (HealthFirst Staff)                  │
└─────────────────────┬─────────────────────┴─────────────────────┬───────────────────────┘
                      │                                           │
                      ▼                                           ▼
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                            FRONTEND LAYER (Angular 17 + Bootstrap 5)                     │
├───────────────────────────────────────────┬─────────────────────────────────────────────┤
│       📱 CUSTOMER PORTAL                   │         🖥️ ADMIN PORTAL                      │
│       "yourhealthplans.com"               │         "admin.yourhealthplans.com"         │
│       ───────────────────────             │         ───────────────────────             │
│       • Plan Catalog & Search             │         • Plan Management (CRUD)            │
│       • Plan Comparison                   │         • Order Management                  │
│       • Shopping Cart                     │         • Customer Management               │
│       • Checkout & Payment                │         • Reports & Dashboard               │
│       • Order History                     │         • Chatbot Training                  │
│       • Profile Management                │                                             │
│       ───────────────────────             │         ───────────────────────             │
│       🤖 AI Chat Widget (Phase 2)         │         Deployed: Cloud Run / Firebase      │
│       Deployed: Cloud Run / Firebase      │                                             │
└─────────────────────┬─────────────────────┴─────────────────────┬───────────────────────┘
                      │                                           │
                      │            HTTPS / REST API               │
                      └─────────────────────┬─────────────────────┘
                                            ▼
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                              GCP LOAD BALANCER (Cloud Load Balancing)                    │
└─────────────────────────────────────────────┬───────────────────────────────────────────┘
                                              │
          ┌───────────────┬───────────────────┼───────────────────┬───────────────────┐
          ▼               ▼                   ▼                   ▼                   ▼
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                    BACKEND MICROSERVICES (Django REST Framework)                         │
│                                  Deployed on Cloud Run                                   │
├─────────────┬─────────────┬─────────────┬─────────────┬─────────────┬───────────────────┤
│  ACCOUNTS   │   CATALOG   │    CART     │   ORDERS    │  PAYMENTS   │    CHATBOT        │
│  SERVICE    │   SERVICE   │   SERVICE   │   SERVICE   │   SERVICE   │    SERVICE        │
│  ─────────  │  ─────────  │  ─────────  │  ─────────  │  ─────────  │   (Phase 2)       │
│  • Signup   │  • Plans    │  • Add      │  • Create   │  • Initiate │  ─────────        │
│  • Login    │  • Category │  • Update   │  • List     │  • Verify   │  • Dialogflow     │
│  • Profile  │  • Search   │  • Remove   │  • Status   │  • Webhook  │  • Intents        │
│  • JWT      │  • CRUD     │  • Clear    │  • History  │  • Refund   │  • Fulfillment    │
├─────────────┴─────────────┴─────────────┴─────────────┴─────────────┴───────────────────┤
│                              J2EE-STYLE LAYERED ARCHITECTURE                             │
│         ┌────────────┐      ┌────────────┐      ┌────────────┐      ┌────────────┐      │
│         │ API Layer  │  →   │  Service   │  →   │ DAO Layer  │  →   │   Models   │      │
│         │ (views.py) │      │  Layer     │      │ (dao.py)   │      │(models.py) │      │
│         └────────────┘      └────────────┘      └────────────┘      └────────────┘      │
└─────────────────────────────────────────────┬───────────────────────────────────────────┘
                                              │
                      ┌───────────────────────┴───────────────────────┐
                      ▼                                               ▼
┌─────────────────────────────────────────────┐ ┌─────────────────────────────────────────┐
│            DATABASE LAYER                    │ │          INTEGRATION LAYER               │
│  ─────────────────────────────────────────  │ │  ─────────────────────────────────────  │
│                                             │ │                                         │
│  🐘 Cloud SQL (PostgreSQL 15)               │ │  💳 PAYMENT GATEWAY                     │
│     ─────────────────────────               │ │     ─────────────────────               │
│     Managed PostgreSQL on GCP               │ │     WireMock (Dev/Test)                 │
│     • Auto backups                          │ │     Razorpay (Production)               │
│     • High availability                     │ │     • UPI, Cards, NetBanking            │
│                                             │ │     • Webhook notifications             │
│     ─────────────────────────               │ │                                         │
│     Tables:                                 │ │  🤖 AI & WORKFLOW (Phase 2)             │
│     • users, profiles                       │ │     ─────────────────────               │
│     • health_plans, categories              │ │     Dialogflow CX                       │
│     • carts, cart_items                     │ │     • Conversation AI                   │
│     • orders, order_items                   │ │     • Multi-turn dialogs                │
│     • payments, transactions                │ │     Cloud Workflows                     │
│                                             │ │     • Orchestration                     │
│  Alternative: MySQL 8.0                     │ │     • Event-driven automation           │
│                                             │ │     Cloud Functions                     │
│                                             │ │     • Serverless compute                │
└─────────────────────────────────────────────┘ └─────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                              DEVOPS & OBSERVABILITY                                      │
├─────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                         │
│   📂 GitHub                    🔄 CI/CD Pipeline              ☁️ GCP Services            │
│   ─────────────               ─────────────────              ─────────────────          │
│   • Source Code               GitHub Actions:                • Cloud Run                │
│   • Pull Requests             • Lint & Test                  • Cloud SQL                │
│   • Branch Protection         • Build Docker                 • Cloud Build              │
│   • Code Reviews              • Push to Artifact Registry    • Artifact Registry        │
│                               • Deploy to Cloud Run          • Secret Manager           │
│                               • Run DB Migrations            • Cloud Logging            │
│                               Cloud Build (Alternative):     • Cloud Monitoring         │
│                               • Native GCP CI/CD             • Dialogflow CX            │
│                               • Trigger on push              • Cloud Workflows          │
│                                                                                         │
└─────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## Part 3: Requirements Analysis

### 3.1 Noun-Verb Analysis

**Instructions:** Read the Business Requirements (Section 1.3) and identify:
1. **NOUNS** = Things/Entities → These become Database Tables/Models
2. **VERBS** = Actions → These become API Endpoints

---

#### NOUNS (→ Entities/Models)

| Noun | Description | Django App |
|------|-------------|------------|
| **Customer/User** | Person buying health plans | `accounts` app |
| **Admin** | HealthFirst staff member | `accounts` app |
| **HealthPlan** | Insurance plan for sale | `catalog` app |
| **Category** | Plan grouping (Individual, Family, Senior) | `catalog` app |
| **Cart** | Shopping basket for a customer | `cart` app |
| **CartItem** | Single plan entry in cart | `cart` app |
| **Order** | Completed purchase/enrollment | `orders` app |
| **OrderItem** | Single plan in an order | `orders` app |
| **Payment** | Payment transaction record | `payments` app |
| **PaymentGateway** | External payment service | Integration (WireMock) |
| **Chatbot** | AI assistant (Phase 2) | `chatbot` app |

#### VERBS (→ Actions/API Endpoints)

| Verb | Entity | API Action | HTTP Method | App |
|------|--------|------------|-------------|-----|
| create account | User | Register new customer | POST | accounts |
| log in | User | Authenticate | POST | accounts |
| log out | User | End session | POST | accounts |
| browse | HealthPlan | List all plans | GET | catalog |
| search | HealthPlan | Search plans | GET | catalog |
| view | HealthPlan | Get plan details | GET | catalog |
| add | CartItem | Add plan to cart | POST | cart |
| view | Cart | Get cart contents | GET | cart |
| modify/update | CartItem | Change quantity | PATCH | cart |
| remove | CartItem | Delete from cart | DELETE | cart |
| checkout | Cart | Initiate checkout | POST | orders |
| process | Payment | Process payment | POST | payments |
| generate | Order | Create order after payment | POST | orders |
| view | Order | Get order history | GET | orders |
| download | Order | Get policy document | GET | orders |
| add | HealthPlan | Create plan (admin) | POST | catalog |
| update | HealthPlan | Update plan (admin) | PUT | catalog |
| activate/deactivate | HealthPlan | Toggle plan status (admin) | PATCH | catalog |
| update | Order | Change order status (admin) | PATCH | orders |
| answer | Chatbot | Respond to FAQ (Phase 2) | POST | chatbot |
| recommend | Chatbot | Suggest plans (Phase 2) | POST | chatbot |

---

## Part 4: Django Apps Structure

```
healthcare_plans_bo/                # Django project (bo = back office)
├── manage.py
├── requirements.txt
├── healthcare_plans_bo/            # Project settings module
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
│
├── accounts/                       # User management app
│   ├── models.py                  # User, Profile models
│   ├── dao.py                     # Data Access Layer
│   ├── services.py                # Business Logic Layer
│   ├── api/
│   │   ├── serializers.py         # DRF Serializers
│   │   └── views.py               # API Views
│   └── urls.py
│
├── catalog/                        # Health Plans catalog app
│   ├── models.py                  # HealthPlan, Category models
│   ├── dao.py                     # Data Access Layer
│   ├── services.py                # Business Logic Layer
│   ├── api/
│   │   ├── serializers.py
│   │   └── views.py
│   └── urls.py
│
├── cart/                           # Shopping cart app
│   ├── models.py                  # Cart, CartItem models
│   ├── dao.py
│   ├── services.py
│   ├── api/
│   │   ├── serializers.py
│   │   └── views.py
│   └── urls.py
│
├── orders/                         # Order/Enrollment management app
│   ├── models.py                  # Order, OrderItem models
│   ├── dao.py
│   ├── services.py
│   ├── api/
│   │   ├── serializers.py
│   │   └── views.py
│   └── urls.py
│
└── payments/                       # Payment processing app
    ├── models.py                  # Payment, Transaction models
    ├── dao.py
    ├── services.py                # Payment gateway integration
    ├── gateway_client.py          # WireMock/Razorpay client
    ├── api/
    │   ├── serializers.py
    │   └── views.py
    └── urls.py
```

---

## Part 5: J2EE-Style Layered Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    ANGULAR FRONTEND                              │
│              (Bootstrap UI Components)                           │
└─────────────────────────┬───────────────────────────────────────┘
                          │ HTTP/REST (JSON)
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                     API LAYER                                    │
│         (views.py - DRF ViewSets/APIViews)                      │
│    • Request/Response handling                                   │
│    • Authentication/Authorization                                │
│    • Input validation (Serializers)                              │
└─────────────────────────┬───────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                   SERVICE LAYER                                  │
│              (services.py - Business Logic)                      │
│    • Business rules                                              │
│    • Transaction management                                      │
│    • Orchestration of DAO calls                                  │
└─────────────────────────┬───────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                     DAO LAYER                                    │
│           (dao.py - Data Access Objects)                         │
│    • CRUD operations                                             │
│    • Database queries                                            │
│    • No business logic here                                      │
└─────────────────────────┬───────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                   MODEL LAYER                                    │
│              (models.py - Django ORM)                            │
│    • Entity definitions                                          │
│    • Field types and constraints                                 │
│    • Relationships                                               │
└─────────────────────────┬───────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                 POSTGRESQL / MYSQL DATABASE                      │
└─────────────────────────────────────────────────────────────────┘
```

---

## Part 6: Technology Stack

| Layer | Technology | Purpose |
|-------|------------|---------|
| **Backend Framework** | Python 3.11 + Django 4.2 | Rapid development, excellent ORM, strong security |
| **REST API** | Django REST Framework | Industry standard, great documentation |
| **Customer Frontend** | Angular 17 + Bootstrap 5 | Enterprise-grade SPA framework, responsive UI |
| **Admin Frontend** | Angular 17 + Bootstrap 5 | Consistent tech stack, code reuse |
| **Database** | PostgreSQL 15 / MySQL 8.0 | ACID compliance, JSON support |
| **Cloud Platform** | Google Cloud Platform (GCP) | Enterprise-grade, excellent free tier |
| **Container Runtime** | Docker + Cloud Run | Serverless, auto-scaling, cost-effective |
| **CI/CD** | GitHub Actions + Cloud Build | Automated deployments, GCP integration |
| **Payment Gateway** | WireMock (Dev) → Razorpay (Prod) | Indian payment methods, UPI support |
| **AI/Chatbot** | Dialogflow CX + Cloud Workflows | Native GCP, enterprise conversation AI |
| **Workflow Automation** | Cloud Workflows + Cloud Functions | Serverless orchestration, event-driven |

### GCP Services Used

| Service | Purpose |
|---------|---------|
| **Cloud Run** | Host Django API & Angular apps |
| **Cloud SQL** | Managed PostgreSQL/MySQL |
| **Artifact Registry** | Docker image storage |
| **Cloud Build** | CI/CD pipeline |
| **Secret Manager** | Store credentials securely |
| **Cloud Logging** | Centralized logging |
| **Cloud Monitoring** | Metrics & alerts |
| **Dialogflow CX** | Conversational AI (Phase 2) |
| **Cloud Workflows** | Process orchestration (Phase 2) |

---

## Part 7: Entity Relationship Diagram

```
┌──────────────────┐           ┌──────────────────┐
│       USER       │           │     CATEGORY     │
├──────────────────┤           ├──────────────────┤
│ id (PK)          │           │ id (PK)          │
│ username         │           │ name             │ (Individual, Family, Senior)
│ email            │           │ description      │
│ mobile           │           │ icon_url         │
│ password         │           └────────┬─────────┘
│ is_staff (admin) │                    │
│ created_at       │                    │ 1:N
└────────┬─────────┘                    │
         │                              ▼
         │ 1:1                ┌──────────────────┐
         │                    │    HEALTH_PLAN   │
         ▼                    ├──────────────────┤
┌──────────────────┐          │ id (PK)          │
│     PROFILE      │          │ category_id (FK) │
├──────────────────┤          │ name             │ (HealthGuard Basic, etc.)
│ id (PK)          │          │ description      │
│ user_id (FK)     │          │ coverage_amount  │ (₹3L, ₹5L, ₹10L, etc.)
│ full_name        │          │ monthly_premium  │
│ date_of_birth    │          │ annual_premium   │
│ address          │          │ benefits (JSON)  │ (List of covered items)
│ city             │          │ waiting_period   │ (30 days, 2 years, etc.)
│ pincode          │          │ max_age          │
└──────────────────┘          │ is_active        │
                              │ created_at       │
         │                    └────────┬─────────┘
         │                             │
         ▼                             │
┌──────────────────┐                   │
│       CART       │                   │
├──────────────────┤                   │
│ id (PK)          │                   │
│ user_id (FK)     │                   │
│ created_at       │                   │
│ updated_at       │                   │
└────────┬─────────┘                   │
         │ 1:N                         │
         ▼                             ▼
┌─────────────────────────────────────────────────┐
│                   CART_ITEM                      │
├─────────────────────────────────────────────────┤
│ id (PK)                                         │
│ cart_id (FK)                                    │
│ plan_id (FK)                                    │
│ quantity (usually 1 for health plans)           │
│ for_members (JSON) (names, ages of covered)     │
│ added_at                                        │
└─────────────────────────────────────────────────┘

┌──────────────────┐
│      ORDER       │ (Enrollment)
├──────────────────┤
│ id (PK)          │
│ user_id (FK)     │
│ order_number     │ (YHP-2025-00001)
│ total_amount     │
│ status           │ (pending, paid, processing, approved, policy_issued, cancelled)
│ policy_start     │
│ policy_end       │
│ created_at       │
│ updated_at       │
└────────┬─────────┘
         │ 1:N
         ▼
┌─────────────────────────────────────────────────┐
│                  ORDER_ITEM                      │
├─────────────────────────────────────────────────┤
│ id (PK)                                         │
│ order_id (FK)                                   │
│ plan_id (FK)                                    │
│ plan_name (snapshot)                            │
│ coverage_amount (snapshot)                      │
│ premium_amount (snapshot)                       │
│ members_covered (JSON)                          │
│ policy_number                                   │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│                   PAYMENT                        │
├─────────────────────────────────────────────────┤
│ id (PK)                                         │
│ order_id (FK)                                   │
│ user_id (FK)                                    │
│ amount                                          │
│ currency (INR)                                  │
│ status (pending, success, failed, refunded)     │
│ payment_method (UPI, Card, NetBanking)          │
│ gateway_txn_id (Razorpay transaction ID)        │
│ gateway_response (JSON)                         │
│ created_at                                      │
│ updated_at                                      │
└─────────────────────────────────────────────────┘
```

---

## Part 8: API Endpoints Design

### Accounts App (`/api/v1/accounts/`)

| Endpoint | Method | Description | Auth |
|----------|--------|-------------|------|
| `/register/` | POST | Create new customer account | No |
| `/login/` | POST | Get JWT token | No |
| `/logout/` | POST | Invalidate token | Yes |
| `/profile/` | GET | Get current user profile | Yes |
| `/profile/` | PATCH | Update profile (KYC details) | Yes |

### Catalog App (`/api/v1/catalog/`)

| Endpoint | Method | Description | Auth |
|----------|--------|-------------|------|
| `/categories/` | GET | List plan categories | No |
| `/plans/` | GET | List all health plans | No |
| `/plans/?search=` | GET | Search plans by name | No |
| `/plans/?category=` | GET | Filter by category | No |
| `/plans/?coverage=` | GET | Filter by coverage amount | No |
| `/plans/{id}/` | GET | Plan details with benefits | No |
| `/plans/compare/` | POST | Compare multiple plans | No |
| `/plans/` | POST | Create plan | Admin |
| `/plans/{id}/` | PUT | Update plan | Admin |
| `/plans/{id}/` | PATCH | Activate/Deactivate | Admin |

### Cart App (`/api/v1/cart/`)

| Endpoint | Method | Description | Auth |
|----------|--------|-------------|------|
| `/` | GET | Get customer's cart | Yes |
| `/items/` | POST | Add plan to cart | Yes |
| `/items/{id}/` | PATCH | Update members info | Yes |
| `/items/{id}/` | DELETE | Remove plan from cart | Yes |
| `/clear/` | DELETE | Empty cart | Yes |
| `/summary/` | GET | Get cart total & summary | Yes |

### Orders App (`/api/v1/orders/`)

| Endpoint | Method | Description | Auth |
|----------|--------|-------------|------|
| `/` | GET | List customer's orders | Yes |
| `/` | POST | Create order (checkout) | Yes |
| `/{id}/` | GET | Order details | Yes |
| `/{id}/policy/` | GET | Download policy document | Yes |
| `/all/` | GET | All orders | Admin |
| `/{id}/status/` | PATCH | Update status | Admin |

### Payments App (`/api/v1/payments/`)

| Endpoint | Method | Description | Auth |
|----------|--------|-------------|------|
| `/initiate/` | POST | Start payment (get gateway URL) | Yes |
| `/verify/{txn_id}/` | GET | Verify payment status | Yes |
| `/webhook/` | POST | Gateway callback | No* |
| `/history/` | GET | Payment history | Yes |
| `/{id}/refund/` | POST | Request refund | Admin |

*Webhook secured by signature verification

### WireMock Payment Gateway (`/mock-gateway/api/v1/`)

| Endpoint | Method | Mock Response |
|----------|--------|---------------|
| `/payments/initiate` | POST | `{txn_id, redirect_url, status: "created"}` |
| `/payments/verify` | POST | `{txn_id, status: "success", amount, method}` |
| `/payments/refund` | POST | `{refund_id, status: "processed"}` |

---

## Part 9: Solution Architecture

### 9.1 Technology Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| **Backend Framework** | Django + DRF | Rapid development, excellent ORM, strong security |
| **Frontend Framework** | Angular 17 | Enterprise-grade, TypeScript, great tooling |
| **UI Library** | Bootstrap 5 | Responsive, well-documented, fast development |
| **Database** | PostgreSQL / MySQL | ACID compliance, JSON support, GCP managed |
| **Authentication** | JWT (Simple JWT) | Stateless, Angular-friendly, scalable |
| **Cloud Platform** | GCP | College partnership, excellent free tier |
| **Container** | Docker + Cloud Run | Serverless, auto-scaling, pay-per-use |
| **Mock Server** | WireMock | Simulate payment gateway locally |

### 9.2 Healthcare Plan Catalog (Sample Data)

| Plan Name | Type | Coverage | Monthly Premium | Key Benefits |
|-----------|------|----------|-----------------|--------------|
| **HealthGuard Basic** | Individual | ₹3 Lakhs | ₹499 | Hospitalization, Day Care |
| **HealthGuard Plus** | Individual | ₹5 Lakhs | ₹799 | + OPD, Health Checkup |
| **Family Floater Silver** | Family (4) | ₹10 Lakhs | ₹1,499 | All members covered |
| **Family Floater Gold** | Family (4) | ₹25 Lakhs | ₹2,999 | + Maternity, International |
| **Senior Care** | Senior (60+) | ₹5 Lakhs | ₹1,999 | Pre-existing covered |
| **Super Top-Up** | Top-Up | ₹50 Lakhs | ₹999 | Deductible: ₹5L |

---

## Part 10: Chatbot & Workflow Architecture (Phase 2)

```
     Customer                                                              
        │                                                                  
        │ "What plan is best for                                          
        │  a family of 4?"                                                
        ▼                                                                  
┌───────────────────┐                                                      
│   Chat Widget     │                                                      
│   (Angular)       │                                                      
└────────┬──────────┘                                                      
         │                                                                 
         ▼                                                                 
┌───────────────────────────────────────────────────────────────┐         
│                    DIALOGFLOW CX                               │         
│              (Conversation AI Platform)                        │         
├───────────────────────────────────────────────────────────────┤         
│  INTENTS:                                                      │         
│  • plan.recommendation    "Find best plan for me"             │         
│  • plan.compare          "Compare Plan A and Plan B"          │         
│  • plan.pricing          "How much is Family Floater?"        │         
│  • faq.coverage          "What does the plan cover?"          │         
│  • faq.claim             "How do I file a claim?"             │         
│  • cart.add              "Add this plan to my cart"           │         
│                                                                │         
│  ENTITIES:                                                     │         
│  • @plan-type     (individual, family, senior)                │         
│  • @coverage      (1L, 5L, 10L, 25L)                          │         
│  • @family-size   (1, 2, 3, 4, 5+)                            │         
│  • @age-group     (18-35, 36-50, 51-60, 60+)                  │         
└────────┬──────────────────────────────────────────────────────┘         
         │                                                                 
         │ Webhook (Fulfillment)                                          
         ▼                                                                 
┌───────────────────────────────────────────────────────────────┐         
│                   CLOUD WORKFLOWS                              │         
│            (Orchestration & Automation)                        │         
├───────────────────────────────────────────────────────────────┤         
│                                                                │         
│  workflow: recommend-plan                                      │         
│  ┌─────────────────────────────────────────────────────────┐  │         
│  │ 1. Extract user parameters (age, family size, budget)   │  │         
│  │              ▼                                          │  │         
│  │ 2. Call Catalog Service API (GET /plans?filters...)     │  │         
│  │              ▼                                          │  │         
│  │ 3. Apply recommendation logic                           │  │         
│  │              ▼                                          │  │         
│  │ 4. Format response for Dialogflow                       │  │         
│  │              ▼                                          │  │         
│  │ 5. Return top 3 recommended plans                       │  │         
│  └─────────────────────────────────────────────────────────┘  │         
│                                                                │         
│  workflow: process-enrollment                                  │         
│  ┌─────────────────────────────────────────────────────────┐  │         
│  │ 1. Receive payment webhook                              │  │         
│  │              ▼                                          │  │         
│  │ 2. Verify payment status                                │  │         
│  │              ▼                                          │  │         
│  │ 3. Update order status                                  │  │         
│  │              ▼                                          │  │         
│  │ 4. Generate policy document (Cloud Functions)           │  │         
│  │              ▼                                          │  │         
│  │ 5. Send confirmation email (SendGrid/Gmail API)         │  │         
│  │              ▼                                          │  │         
│  │ 6. Notify admin dashboard                               │  │         
│  └─────────────────────────────────────────────────────────┘  │         
│                                                                │         
└───────────────────────────────────────────────────────────────┘         
         │                                                                 
         ▼                                                                 
┌───────────────────────────────────────────────────────────────┐         
│                   CLOUD FUNCTIONS                              │         
│              (Serverless Compute)                              │         
├───────────────────────────────────────────────────────────────┤         
│  • generate-policy-pdf     Trigger: HTTP                      │         
│  • send-email-notification Trigger: Pub/Sub                   │         
│  • payment-webhook-handler Trigger: HTTP                      │         
│  • sync-dialogflow-data    Trigger: Cloud Scheduler           │         
└───────────────────────────────────────────────────────────────┘         
```

---

## Part 11: Getting Started

### Prerequisites

- Python 3.11+
- Node.js 18+ & npm
- Docker Desktop
- Git

### Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/[username]/HealthCare-Buy-Plans-App.git
cd HealthCare-Buy-Plans-App

# 2. Install dependencies and setup
npm run setup

# 3. Start all services (Docker + Backend + Frontend)
npm run dev
```

### Access Points

| Service | URL |
|---------|-----|
| Customer Portal (Angular) | http://localhost:4200 |
| Django REST API | http://localhost:8000/api/v1/ |
| Django Admin | http://localhost:8000/admin/ |
| API Documentation | http://localhost:8000/swagger/ |
| phpMyAdmin (MySQL) | http://localhost:8080 |
| pgAdmin (PostgreSQL) | http://localhost:5050 |
| WireMock (Payment Mock) | http://localhost:9090 |

### Available NPM Scripts

```bash
npm run docker:start      # Start Docker containers (DB + WireMock)
npm run docker:stop       # Stop Docker containers
npm run docker:status     # Check container status

npm run backend:install   # Install Python dependencies
npm run backend:migrate   # Run database migrations
npm run backend:start     # Start Django server (port 8000)

npm run frontend:install  # Install Angular dependencies
npm run frontend:start    # Start Angular dev server (port 4200)

npm run dev               # Start everything (Docker + Backend + Frontend)
npm run setup             # First-time setup (install all dependencies)
```

---

## Repository Structure

```
HealthCare-Buy-Plans-App/
│
├── README.md                          # This file (Design Document)
├── package.json                       # NPM scripts for orchestration
│
├── docker_start.sh                    # Shell scripts (Mac/Linux)
├── docker_stop.sh
├── docker_status.sh
├── docker_start.bat                   # Batch scripts (Windows)
├── docker_stop.bat
├── docker_status.bat
│
├── back_office/                       # Django Backend
│   └── healthcare_plans_bo/
│
├── front_end/                         # Angular Frontend
│   └── healthcare_plans_ui/
│
└── dev_ops/                           # DevOps Configurations
    └── local_development/
        ├── mysql/
        │   └── docker-compose.yml
        ├── postgres/
        │   └── docker-compose.yml
        └── wiremock/
            ├── docker-compose.yml
            └── mappings/
```

---

## License

MIT License

---

## Contributors

- Kishore Veleti - Initial Development

---

*Last Updated: December 2025*
