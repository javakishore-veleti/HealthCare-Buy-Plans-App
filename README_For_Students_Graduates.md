# Learning Guide for Students & Graduates

## Who Is This Repository For?

If you are a **Computer Science/Engineering student** or **fresh graduate** aspiring to master professional software development, this repository will teach you how real-world applications are built from business idea to production deployment.

---

## Table of Contents

1. [Business Analysis](#1-business-analysis)
2. [System Design](#2-system-design)
3. [Backend Development](#3-backend-development)
4. [Frontend Development](#4-frontend-development)
5. [API Integration](#5-api-integration)
6. [Database Design](#6-database-design)
7. [Authentication](#7-authentication)
8. [Version Control](#8-version-control)
9. [Cloud Deployment](#9-cloud-deployment)
10. [CI/CD Pipelines](#10-cicd-pipelines)
11. [Professional Practices](#11-professional-practices)

---

## 1. Business Analysis

### What You'll Learn
How to read a Business Requirements Document (BRD) and convert it to technical design.

---

### 1.1 How It Starts: The CEO's Vision

In real companies, software projects don't start with code. They start with a **business need**. A CEO or business leader identifies a problem or opportunity. In our case, the CEO of YourHealthFirst Insurance Ltd noticed that:

- Customers want to buy health insurance online (not visit offices)
- Competitors already have websites for buying plans
- The company is losing customers because they don't have a digital platform

The CEO writes a memo or email to the leadership team explaining the vision, budget (₹100 Crores), and timeline (2 months). This document is called the **Strategic Vision** or **Executive Brief**. As a developer, you may never write this, but understanding it helps you know WHY you are building what you're building.

---

### 1.2 Product Manager Creates the Product Definition

After the CEO's vision, a **Product Manager (PM)** takes over. The PM's job is to define WHAT we are building. They conduct meetings with business leaders, talk to potential customers, and study competitors. The output is a **Product Definition Document** that includes:

- **Product Name:** "Your Health Plans"
- **Target Users:** Customers (buying insurance), Admins (managing plans)
- **Core Features:** Browse plans, add to cart, checkout, payment
- **Phases:** Phase 1 (basic features), Phase 2 (AI chatbot)

The PM doesn't write code but decides what features are needed. As a developer, you'll receive requirements from the PM and need to understand the product context.

---

### 1.3 Product Owner Writes the BRD

The **Product Owner (PO)** works closely with developers. They take the PM's product definition and write detailed **Business Requirements Documents (BRD)**. A BRD describes the system in plain English paragraphs. For example:

> "The platform shall enable customers to create an account using their email and mobile number, with secure password-based authentication. Once logged in, customers shall be able to browse the complete catalog of healthcare plans offered by HealthFirst, including Individual Plans, Family Floater Plans, and Senior Citizen Plans."

Notice the language: "shall enable", "shall be able to". This is formal requirements language. Each sentence describes ONE requirement. As a developer, you need to read these paragraphs carefully and extract what the system must do.

---

### 1.4 User Stories for Development Team

For day-to-day development, the PO converts BRD paragraphs into **User Stories**. A user story follows this format:

```
As a [type of user],
I want to [do something],
So that [I get some benefit].
```

**Example User Stories from our BRD:**

| ID | User Story | Acceptance Criteria |
|----|------------|---------------------|
| US-001 | As a customer, I want to create an account with email and mobile, so that I can access the platform | - Email must be unique<br>- Mobile must be 10 digits<br>- Password must be 8+ characters |
| US-002 | As a customer, I want to browse health plans, so that I can find a suitable plan | - Show plan name, coverage, premium<br>- Filter by category<br>- Sort by price |
| US-003 | As a customer, I want to add plans to cart, so that I can purchase multiple plans | - Show cart total<br>- Allow quantity changes<br>- Remove items |

**In This Repository:** See the main [README.md](README.md) Section 1.3 for the complete BRD and Section 3.1 for user stories.

---

## 2. System Design

### What You'll Learn
Noun-Verb analysis to identify entities and actions from requirements.

---

### 2.1 From English to Technical Design

How do you convert English paragraphs (BRD) into database tables and API endpoints? Professional developers use **Noun-Verb Analysis**. This is a simple but powerful technique:

- **NOUNS** in the requirements become **Database Tables** (Entities)
- **VERBS** in the requirements become **API Endpoints** (Actions)

---

### 2.2 Finding Nouns (Entities)

Read this BRD sentence:
> "The platform shall enable **customers** to create an **account** using their **email** and **mobile number**, with secure **password**-based authentication."

The nouns are: Customer, Account, Email, Mobile Number, Password

Now read this sentence:
> "Once logged in, **customers** shall be able to browse the complete catalog of **healthcare plans** offered by HealthFirst, including **Individual Plans**, **Family Floater Plans**, and **Senior Citizen Plans**."

More nouns: Healthcare Plan, Category (Individual, Family, Senior)

Continue this process for the entire BRD. You'll find these nouns:

| Noun | Becomes | Database Table |
|------|---------|----------------|
| Customer | Entity | `users` |
| Account | Entity | `users` (same as customer) |
| Profile | Entity | `user_profiles` |
| Healthcare Plan | Entity | `health_plans` |
| Category | Entity | `categories` |
| Cart | Entity | `carts` |
| Cart Item | Entity | `cart_items` |
| Order | Entity | `orders` |
| Payment | Entity | `payments` |

---

### 2.3 Finding Verbs (Actions)

Now look for verbs in the same sentences:

> "The platform shall enable customers to **create** an account..."
> "...customers shall be able to **browse** the complete catalog..."
> "Customers shall be able to **add** one or more plans to their shopping **cart**..."
> "...and **proceed** to checkout."

The verbs are: Create, Browse, Add, Proceed (Checkout)

| Verb | Entity | API Endpoint | HTTP Method |
|------|--------|--------------|-------------|
| Create account | User | `/api/v1/accounts/register/` | POST |
| Login | User | `/api/v1/accounts/login/` | POST |
| Browse | Health Plan | `/api/v1/catalog/plans/` | GET |
| Search | Health Plan | `/api/v1/catalog/plans/?search=` | GET |
| Add to cart | Cart Item | `/api/v1/cart/items/` | POST |
| Checkout | Order | `/api/v1/orders/` | POST |
| Pay | Payment | `/api/v1/payments/initiate/` | POST |

---

### 2.4 Entity Relationship Diagram (ERD)

Once you have entities, you need to define relationships between them:

- One **Customer** has one **Profile** (1:1)
- One **Customer** has one **Cart** (1:1)
- One **Cart** has many **Cart Items** (1:N)
- One **Category** has many **Health Plans** (1:N)
- One **Customer** has many **Orders** (1:N)
- One **Order** has many **Order Items** (1:N)
- One **Order** has one **Payment** (1:1)

**In This Repository:** See [README.md](README.md) Section 7 for the complete ERD diagram.

---

## 3. Backend Development

### What You'll Learn
Python Django REST Framework with layered architecture (API → Service → DAO → Model).

---

### 3.1 Why Layered Architecture?

In college projects, you might write all code in one file. In professional projects, code is organized into **layers**. Each layer has a specific responsibility:

```
┌─────────────────────────────────────┐
│           API Layer                  │  ← Handles HTTP requests/responses
│         (views.py)                   │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│         Service Layer                │  ← Contains business logic
│        (services.py)                 │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│           DAO Layer                  │  ← Handles database operations
│          (dao.py)                    │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│          Model Layer                 │  ← Defines database tables
│         (models.py)                  │
└─────────────────────────────────────┘
```

**Why separate layers?**

1. **Easier to test:** You can test business logic without the database
2. **Easier to maintain:** Change database code without touching API code
3. **Team collaboration:** Different developers can work on different layers
4. **Reusability:** Same service can be used by multiple APIs

---

### 3.2 Model Layer (models.py)

This layer defines your database tables using Django ORM (Object-Relational Mapping). Instead of writing SQL, you write Python classes:

```python
# accounts/models.py
class User(AbstractBaseUser):
    email = models.EmailField(unique=True)
    mobile = models.CharField(max_length=15)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
```

Django automatically converts this to SQL:
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE,
    mobile VARCHAR(15),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);
```

---

### 3.3 DAO Layer (dao.py)

DAO = Data Access Object. This layer contains all database queries. No business logic, just CRUD operations:

```python
# accounts/dao.py
class UserDAO:
    @staticmethod
    def get_by_email(email: str) -> Optional[User]:
        try:
            return User.objects.get(email=email)
        except User.DoesNotExist:
            return None
    
    @staticmethod
    def create(email: str, mobile: str, password: str) -> User:
        return User.objects.create_user(
            email=email,
            mobile=mobile,
            password=password
        )
    
    @staticmethod
    def email_exists(email: str) -> bool:
        return User.objects.filter(email=email).exists()
```

---

### 3.4 Service Layer (services.py)

This layer contains **business logic**. It uses DAO to access database and applies business rules:

```python
# accounts/services.py
class AccountsService:
    @staticmethod
    def register_user(email: str, mobile: str, password: str, full_name: str):
        # Business Rule 1: Check if email already exists
        if UserDAO.email_exists(email):
            raise ValueError('Email already exists')
        
        # Business Rule 2: Create user
        user = UserDAO.create(email=email, mobile=mobile, password=password)
        
        # Business Rule 3: Create profile
        profile = UserProfileDAO.create(user=user, full_name=full_name)
        
        return user, profile
```

---

### 3.5 API Layer (views.py)

This layer handles HTTP requests and responses. It uses Service layer for business logic:

```python
# accounts/api/views.py
class RegisterView(APIView):
    permission_classes = [AllowAny]
    
    def post(self, request):
        # 1. Validate input
        serializer = RegisterSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({'error': serializer.errors}, status=400)
        
        # 2. Call service layer
        try:
            user, profile = AccountsService.register_user(
                email=serializer.validated_data['email'],
                mobile=serializer.validated_data['mobile'],
                password=serializer.validated_data['password'],
                full_name=serializer.validated_data['full_name']
            )
        except ValueError as e:
            return Response({'error': str(e)}, status=400)
        
        # 3. Return response
        return Response({
            'id': user.id,
            'email': user.email,
            'message': 'Registration successful'
        }, status=201)
```

**In This Repository:** See `back_office/accounts/` folder for complete implementation.

---

## 4. Frontend Development

### What You'll Learn
Angular 17 with Bootstrap 5, component architecture, services, and routing.

---

### 4.1 What is Angular?

Angular is a **frontend framework** for building Single Page Applications (SPA). Unlike traditional websites where each click loads a new page from the server, Angular loads once and then updates the page dynamically using JavaScript.

**Key Concepts:**

| Concept | What It Is | Example |
|---------|------------|---------|
| **Component** | A reusable UI piece | Login form, Navigation bar, Plan card |
| **Service** | Shared business logic | API calls, authentication |
| **Module** | Group of related components | AccountsModule, CatalogModule |
| **Routing** | Navigation between pages | /login → /profile → /catalog |

---

### 4.2 Angular Project Structure

```
healthcare_plans_ui/
├── src/
│   ├── app/
│   │   ├── core/                    # Singleton services
│   │   │   ├── auth/
│   │   │   │   └── auth.service.ts  # Login, logout, token management
│   │   │   ├── guards/
│   │   │   │   └── auth.guard.ts    # Protect routes
│   │   │   └── interceptors/
│   │   │       └── auth.interceptor.ts  # Add JWT to requests
│   │   │
│   │   ├── features/                # Feature modules
│   │   │   ├── accounts/
│   │   │   │   ├── login/
│   │   │   │   ├── register/
│   │   │   │   └── profile/
│   │   │   ├── catalog/
│   │   │   ├── cart/
│   │   │   └── checkout/
│   │   │
│   │   ├── shared/                  # Reusable components
│   │   │   └── components/
│   │   │
│   │   ├── app.routes.ts            # Route definitions
│   │   └── app.config.ts            # App configuration
│   │
│   └── environments/
│       ├── environment.ts           # Dev config
│       └── environment.prod.ts      # Prod config
```

---

### 4.3 Component Example: Login

A component has 3 files:

**1. login.component.ts** (Logic)
```typescript
@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent {
  loginForm: FormGroup;
  
  constructor(
    private authService: AuthService,
    private router: Router
  ) {
    this.loginForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      password: ['', [Validators.required]]
    });
  }
  
  onSubmit(): void {
    this.authService.login(this.loginForm.value).subscribe({
      next: () => this.router.navigate(['/profile']),
      error: (err) => this.errorMessage = 'Invalid credentials'
    });
  }
}
```

**2. login.component.html** (Template)
```html
<div class="form-container">
  <h2>Welcome Back</h2>
  
  <form [formGroup]="loginForm" (ngSubmit)="onSubmit()">
    <div class="mb-3">
      <label>Email</label>
      <input type="email" formControlName="email" class="form-control">
    </div>
    
    <div class="mb-3">
      <label>Password</label>
      <input type="password" formControlName="password" class="form-control">
    </div>
    
    <button type="submit" class="btn btn-primary">Login</button>
  </form>
</div>
```

**3. login.component.scss** (Styles)
```scss
.form-container {
  max-width: 400px;
  margin: 2rem auto;
  padding: 2rem;
}
```

**In This Repository:** See `front_end_code/healthcare_plans_ui/src/app/features/accounts/` for complete implementation.

---

## 5. API Integration

### What You'll Learn
How Angular communicates with Django using HTTP client and JWT authentication.

---

### 5.1 The Communication Flow

```
┌─────────────────┐         HTTP Request          ┌─────────────────┐
│                 │  ─────────────────────────▶   │                 │
│  Angular App    │      POST /api/v1/login/      │   Django API    │
│  (Browser)      │      {email, password}        │   (Server)      │
│                 │                               │                 │
│                 │  ◀─────────────────────────   │                 │
│                 │         HTTP Response         │                 │
│                 │    {access_token, ...}        │                 │
└─────────────────┘                               └─────────────────┘
     Port 4200                                         Port 8000
```

---

### 5.2 Angular Service for API Calls

```typescript
// core/auth/auth.service.ts
@Injectable({ providedIn: 'root' })
export class AuthService {
  private apiUrl = 'http://localhost:8000/api/v1/accounts';
  
  constructor(private http: HttpClient) {}
  
  login(data: {email: string, password: string}): Observable<LoginResponse> {
    return this.http.post<LoginResponse>(`${this.apiUrl}/login/`, data)
      .pipe(
        tap(response => {
          // Store token in localStorage
          localStorage.setItem('access_token', response.access_token);
        })
      );
  }
  
  getProfile(): Observable<UserProfile> {
    return this.http.get<UserProfile>(`${this.apiUrl}/profile/`);
  }
}
```

---

### 5.3 HTTP Interceptor for JWT

Every authenticated request needs the JWT token in the header. Instead of adding it manually to every request, we use an **Interceptor**:

```typescript
// core/interceptors/auth.interceptor.ts
@Injectable()
export class AuthInterceptor implements HttpInterceptor {
  
  intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    const token = localStorage.getItem('access_token');
    
    if (token) {
      request = request.clone({
        setHeaders: {
          Authorization: `Bearer ${token}`
        }
      });
    }
    
    return next.handle(request);
  }
}
```

**What happens:**

1. User logs in → Django returns JWT token
2. Angular stores token in localStorage
3. User requests profile → Interceptor adds token to header
4. Django verifies token → Returns profile data

---

### 5.4 CORS: Why Angular Can't Talk to Django (Initially)

When Angular (port 4200) tries to call Django (port 8000), the browser blocks it. This is a security feature called **CORS** (Cross-Origin Resource Sharing).

**Solution:** Configure Django to allow requests from Angular:

```python
# Django settings.py
CORS_ALLOWED_ORIGINS = [
    'http://localhost:4200',  # Angular dev server
]
```

**In This Repository:** See `back_office/healthcare_plans_bo/settings.py` for CORS configuration.

---

## 6. Database Design

### What You'll Learn
Entity Relationship Diagrams, PostgreSQL/MySQL, and database migrations.

---

### 6.1 Choosing a Database

| Database | When to Use | In This Project |
|----------|-------------|-----------------|
| **SQLite** | Learning, small projects, single user | Local development |
| **PostgreSQL** | Production, complex queries, JSON support | GCP Cloud SQL |
| **MySQL** | Production, widely used, good performance | Alternative option |

For learning, SQLite is perfect because:
- No installation needed (comes with Python)
- Database is just a file (`db.sqlite3`)
- Same SQL syntax works in PostgreSQL/MySQL

---

### 6.2 Django Migrations

When you change models, you need to update the database. Django handles this with **migrations**:

```bash
# Step 1: Create migration file
python manage.py makemigrations

# Output: accounts/migrations/0001_initial.py

# Step 2: Apply migration to database
python manage.py migrate

# Output: Creating table users... OK
```

**Migration file example:**
```python
# accounts/migrations/0001_initial.py
class Migration(migrations.Migration):
    operations = [
        migrations.CreateModel(
            name='User',
            fields=[
                ('id', models.BigAutoField(primary_key=True)),
                ('email', models.EmailField(unique=True)),
                ('mobile', models.CharField(max_length=15)),
                ('password', models.CharField(max_length=128)),
            ],
        ),
    ]
```

---

### 6.3 Database Relationships

**One-to-One (1:1):** One User has exactly one Profile
```python
class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
```

**One-to-Many (1:N):** One Category has many Health Plans
```python
class HealthPlan(models.Model):
    category = models.ForeignKey(Category, on_delete=models.CASCADE)
```

**Many-to-Many (M:N):** Not used in this project, but example:
```python
class HealthPlan(models.Model):
    benefits = models.ManyToManyField(Benefit)
```

**In This Repository:** See `back_office/accounts/models.py` for complete model definitions.

---

## 7. Authentication

### What You'll Learn
JWT (JSON Web Tokens) for secure login/logout.

---

### 7.1 What is JWT?

JWT is a secure way to authenticate users without storing sessions on the server. It works like this:

```
1. User sends email + password to /login
2. Server verifies credentials
3. Server creates a JWT token (encoded string)
4. Server sends token to user
5. User stores token in browser (localStorage)
6. User sends token with every request (in header)
7. Server verifies token and responds
```

---

### 7.2 JWT Token Structure

A JWT has 3 parts separated by dots:

```
eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3MDM...
|_______________________|_______________________________|___
        Header                    Payload               Signature
```

**Header:** Algorithm used (HS256)
**Payload:** User data (user_id, expiry time)
**Signature:** Verification that token wasn't tampered

---

### 7.3 Django JWT Setup

```python
# settings.py
INSTALLED_APPS = [
    'rest_framework_simplejwt',
]

REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
}

SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(minutes=60),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=7),
}
```

---

### 7.4 Protected Endpoints

```python
# Unprotected - anyone can access
class RegisterView(APIView):
    permission_classes = [AllowAny]

# Protected - only logged-in users can access
class ProfileView(APIView):
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        # request.user is automatically set from JWT token
        return Response({'email': request.user.email})
```

**In This Repository:** See `back_office/healthcare_plans_bo/settings.py` for JWT configuration.

---

## 8. Version Control

### What You'll Learn
Git workflow, branching, and pull requests.

---

### 8.1 Why Git?

Git tracks every change to your code. Benefits:

- **History:** See who changed what and when
- **Collaboration:** Multiple developers work together
- **Branches:** Work on features without breaking main code
- **Rollback:** Undo mistakes easily

---

### 8.2 Basic Git Commands

```bash
# Clone repository
git clone https://github.com/username/HealthCare-Buy-Plans-App.git

# Check status
git status

# Stage changes
git add .

# Commit changes
git commit -m "Add login feature"

# Push to GitHub
git push origin main

# Pull latest changes
git pull origin main
```

---

### 8.3 Branching Strategy

```
main (production)
  │
  ├── develop (integration)
  │     │
  │     ├── feature/user-login
  │     │
  │     ├── feature/health-plans-catalog
  │     │
  │     └── feature/shopping-cart
  │
  └── hotfix/payment-bug
```

**Workflow:**

1. Create branch: `git checkout -b feature/user-login`
2. Write code and commit
3. Push branch: `git push origin feature/user-login`
4. Create Pull Request on GitHub
5. Team reviews code
6. Merge to develop
7. Test on develop
8. Merge to main for production

---

### 8.4 Good Commit Messages

**Bad:**
```
git commit -m "fix"
git commit -m "update"
git commit -m "changes"
```

**Good:**
```
git commit -m "Add user registration API endpoint"
git commit -m "Fix email validation in RegisterSerializer"
git commit -m "Update JWT token expiry to 60 minutes"
```

**In This Repository:** Check the commit history to see examples of good commit messages.

---

## 9. Cloud Deployment

### What You'll Learn
Google Cloud Platform (Cloud Run, Artifact Registry, Cloud SQL).

---

### 9.1 Why Cloud?

Instead of buying and managing servers, cloud platforms provide:

- **Scalability:** Handle 1 or 1 million users automatically
- **Reliability:** 99.9% uptime guarantee
- **Security:** Managed firewalls, encryption
- **Cost:** Pay only for what you use

---

### 9.2 GCP Services We Use

| Service | Purpose | Alternative |
|---------|---------|-------------|
| **Cloud Run** | Run Docker containers | AWS ECS, Azure Container Apps |
| **Artifact Registry** | Store Docker images | Docker Hub, AWS ECR |
| **Cloud SQL** | Managed PostgreSQL/MySQL | AWS RDS, Azure SQL |
| **Secret Manager** | Store passwords securely | AWS Secrets Manager |

---

### 9.3 How Cloud Run Works

```
┌─────────────────────────────────────────────────────────────┐
│                        CLOUD RUN                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. You push Docker image to Artifact Registry              │
│                                                             │
│  2. Cloud Run pulls the image                               │
│                                                             │
│  3. Cloud Run starts container(s) when requests come        │
│                                                             │
│  4. Cloud Run stops containers when no requests (save $)    │
│                                                             │
│  5. Cloud Run auto-scales: more requests = more containers  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

### 9.4 Deployment Flow

```
Developer Machine          GitHub              GCP
       │                     │                  │
       │  git push           │                  │
       │────────────────────▶│                  │
       │                     │                  │
       │                     │  Trigger Action  │
       │                     │─────────────────▶│
       │                     │                  │
       │                     │  Build Docker    │
       │                     │  Push Image      │
       │                     │  Deploy to       │
       │                     │  Cloud Run       │
       │                     │                  │
       │                     │  ✅ Deployed!    │
       │                     │◀─────────────────│
```

**In This Repository:** See `.github/workflows/deploy-django.yml` for complete deployment workflow.

---

## 10. CI/CD Pipelines

### What You'll Learn
GitHub Actions for automated build and deployment.

---

### 10.1 What is CI/CD?

**CI (Continuous Integration):** Automatically build and test code when pushed

**CD (Continuous Deployment):** Automatically deploy code when tests pass

```
Push Code → Build → Test → Deploy
   │          │       │       │
   │          │       │       └── CD
   │          └───────┴────────── CI
```

---

### 10.2 GitHub Actions Workflow

```yaml
# .github/workflows/deploy-django.yml
name: Deploy Django Backend

on:
  workflow_dispatch:  # Manual trigger
    inputs:
      environment:
        description: 'Select environment'
        type: choice
        options:
          - dev-server
          - qa-server
          - prod-server

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Build Docker image
        run: docker build -t my-app .
      
      - name: Push to Artifact Registry
        run: docker push gcr.io/project/my-app
      
      - name: Deploy to Cloud Run
        run: gcloud run deploy my-app --image gcr.io/project/my-app
```

---

### 10.3 Environment Strategy

| Environment | Purpose | When to Deploy |
|-------------|---------|----------------|
| **dev-server** | Developer testing | After every feature |
| **qa-server** | QA team testing | After feature complete |
| **pre-prod** | Final testing | Before production |
| **prod-server** | Live users | After all approvals |

**In This Repository:** See `.github/workflows/` folder for all deployment workflows.

---

## 11. Professional Practices

### What You'll Learn
Code organization, environment configuration, and documentation.

---

### 11.1 Environment Configuration

Never hardcode passwords or API keys. Use environment variables:

**Bad:**
```python
DATABASE_PASSWORD = "my_secret_password"  # 🚫 Never do this!
```

**Good:**
```python
DATABASE_PASSWORD = os.getenv('DATABASE_PASSWORD')  # ✅ Read from environment
```

**Local development:** Use `.env` file
```
# .env (never commit this file!)
DATABASE_PASSWORD=my_secret_password
SECRET_KEY=django-insecure-abc123
```

**Production:** Use Secret Manager or environment variables set in Cloud Run

---

### 11.2 Code Organization

```
✅ Good Structure:
accounts/
├── models.py      # Database models only
├── dao.py         # Database queries only
├── services.py    # Business logic only
├── api/
│   ├── views.py   # HTTP handling only
│   └── serializers.py  # Validation only
└── tests/
    ├── test_models.py
    ├── test_services.py
    └── test_views.py

🚫 Bad Structure:
accounts/
├── views.py       # Everything mixed together!
└── models.py
```

---

### 11.3 Documentation

Every project needs:

| Document | Purpose | Audience |
|----------|---------|----------|
| **README.md** | Project overview, setup instructions | New developers |
| **API Documentation** | Endpoint details, request/response | Frontend developers |
| **Architecture Diagram** | System overview | Technical leads |
| **Deployment Guide** | How to deploy | DevOps team |

---

### 11.4 Code Comments

**Bad comments:** (explain what)
```python
# Loop through users
for user in users:
    # Check if active
    if user.is_active:
        # Send email
        send_email(user)
```

**Good comments:** (explain why)
```python
# Only send promotional emails to active users to comply with GDPR
# Inactive users have opted out of marketing communications
for user in users:
    if user.is_active:
        send_email(user)
```

---

## Summary: Your Learning Journey

```
Week 1: Foundations
├── Understand Business Requirements (BRD)
├── Learn Noun-Verb Analysis
└── Design Database Schema (ERD)

Week 2: Backend Development
├── Setup Django Project
├── Create Models (models.py)
├── Implement DAO Layer (dao.py)
├── Implement Service Layer (services.py)
└── Create REST APIs (views.py)

Week 3: Frontend Development
├── Setup Angular Project
├── Create Components
├── Create Services
├── Implement Routing
└── Integrate with Django API

Week 4: DevOps & Deployment
├── Dockerize Applications
├── Setup GitHub Actions
├── Deploy to GCP Cloud Run
└── Configure CI/CD Pipeline
```

---

## Next Steps

1. **Clone this repository** and run it locally
2. **Follow the workshop agenda** in the main README
3. **Build each feature** step by step
4. **Deploy to GCP** using GitHub Actions
5. **Extend the project** with your own features

---

## Questions?

If you have questions while learning:

1. Check the main [README.md](README.md) for detailed documentation
2. Look at the code comments in each file
3. Create an Issue on GitHub
4. Reach out to the workshop presenter

---

*Happy Learning! 🎓*

---

*Last Updated: December 2025*
