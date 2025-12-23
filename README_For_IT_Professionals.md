# Learning Guide for IT Professionals

## Who Is This Repository For?

If you are an **experienced IT professional** from Java/Spring, .NET, Node.js, or other technology backgrounds looking to learn **Python Django** and **Angular**, this repository demonstrates enterprise-grade patterns you already know, implemented in a new tech stack.

---

## Table of Contents

1. [Technology Comparison](#1-technology-comparison)
2. [Project Structure Mapping](#2-project-structure-mapping)
3. [Django for Spring/Java Developers](#3-django-for-springjava-developers)
4. [Django for .NET Developers](#4-django-for-net-developers)
5. [Django for Node.js Developers](#5-django-for-nodejs-developers)
6. [Angular Modern Practices](#6-angular-modern-practices)
7. [GCP for AWS/Azure Developers](#7-gcp-for-awsazure-developers)
8. [Enterprise Patterns in Python](#8-enterprise-patterns-in-python)
9. [Testing Strategies](#9-testing-strategies)
10. [Performance & Scalability](#10-performance--scalability)
11. [Security Best Practices](#11-security-best-practices)
12. [Migration Strategies](#12-migration-strategies)

---

## 1. Technology Comparison

### 1.1 Full Stack Comparison

| Layer | Java/Spring | .NET | Node.js | This Repo (Python) |
|-------|-------------|------|---------|-------------------|
| **Language** | Java 17+ | C# 12 | JavaScript/TypeScript | Python 3.11 |
| **Backend Framework** | Spring Boot | ASP.NET Core | Express/NestJS | Django 4.2 |
| **REST API** | Spring MVC | Web API | Express Router | Django REST Framework |
| **ORM** | JPA/Hibernate | Entity Framework | Sequelize/Prisma | Django ORM |
| **Dependency Injection** | Spring IoC | .NET DI | InversifyJS | Manual / Django Services |
| **Authentication** | Spring Security | Identity | Passport.js | Django Auth + JWT |
| **Frontend** | React/Angular | Angular/Blazor | React/Vue | Angular 17 |
| **Database Migration** | Flyway/Liquibase | EF Migrations | Knex/Prisma | Django Migrations |
| **Testing** | JUnit/Mockito | xUnit/Moq | Jest | pytest/Django Test |
| **Cloud** | AWS/Azure/GCP | Azure | AWS/GCP | GCP Cloud Run |

---

### 1.2 Framework Philosophy Comparison

| Aspect | Spring Boot | ASP.NET Core | Django |
|--------|-------------|--------------|--------|
| **Philosophy** | Enterprise, Flexible | Enterprise, Integrated | Batteries Included |
| **Configuration** | Annotations + YAML | Attributes + JSON | Python Settings |
| **Convention** | Convention over Config | Convention over Config | Explicit over Implicit |
| **Learning Curve** | Steep | Moderate | Gentle |
| **Boilerplate** | High | Moderate | Low |
| **Magic** | High (proxies, AOP) | Moderate | Low (explicit) |

---

### 1.3 Why Python/Django?

As an experienced developer, you might wonder why learn Django:

| Reason | Explanation |
|--------|-------------|
| **Startup Ecosystem** | Many startups use Python/Django for rapid development |
| **Data Science Integration** | Seamless integration with pandas, numpy, ML libraries |
| **Scripting & Automation** | Python is the #1 language for DevOps, automation |
| **Readability** | Python's clean syntax makes code reviews faster |
| **Hiring Market** | High demand for Python developers globally |
| **Full Stack Capability** | Django handles everything: ORM, Auth, Admin, APIs |

---

## 2. Project Structure Mapping

### 2.1 Spring Boot vs Django Structure

```
Spring Boot Project                    Django Project
──────────────────                    ──────────────
src/                                  healthcare_plans_bo/
├── main/                             ├── manage.py
│   ├── java/                         ├── healthcare_plans_bo/
│   │   └── com/healthfirst/         │   ├── settings.py      (application.yml)
│   │       ├── Application.java      │   ├── urls.py          (Router config)
│   │       ├── config/               │   └── wsgi.py          (Server entry)
│   │       │   └── SecurityConfig    │
│   │       ├── accounts/             ├── accounts/            (Spring @Service package)
│   │       │   ├── User.java         │   ├── models.py        (@Entity classes)
│   │       │   ├── UserRepository    │   ├── dao.py           (@Repository)
│   │       │   ├── UserService       │   ├── services.py      (@Service)
│   │       │   ├── UserController    │   ├── api/
│   │       │   └── UserDTO           │   │   ├── views.py     (@RestController)
│   │       │                         │   │   └── serializers  (DTOs)
│   │       └── catalog/              │   └── urls.py          (@RequestMapping)
│   │           ├── HealthPlan.java   │
│   │           ├── PlanRepository    ├── catalog/
│   │           ├── PlanService       │   ├── models.py
│   │           └── PlanController    │   ├── dao.py
│   │                                 │   ├── services.py
│   └── resources/                    │   └── api/
│       └── application.yml           │
│                                     └── requirements.txt     (pom.xml)
└── test/
    └── java/
```

---

### 2.2 ASP.NET Core vs Django Structure

```
ASP.NET Core Project                   Django Project
────────────────────                  ──────────────
src/
├── HealthFirst.API/                  healthcare_plans_bo/
│   ├── Program.cs                    ├── manage.py
│   ├── appsettings.json              ├── healthcare_plans_bo/
│   ├── Controllers/                  │   ├── settings.py
│   │   ├── AccountsController.cs     │   └── urls.py
│   │   └── CatalogController.cs      │
│   └── Startup.cs                    ├── accounts/
│                                     │   ├── models.py
├── HealthFirst.Core/                 │   ├── dao.py
│   ├── Entities/                     │   ├── services.py
│   │   ├── User.cs                   │   └── api/
│   │   └── HealthPlan.cs             │       ├── views.py
│   ├── Interfaces/                   │       └── serializers.py
│   │   ├── IUserRepository.cs        │
│   │   └── IUserService.cs           ├── catalog/
│   └── Services/                     │   ├── models.py
│       └── UserService.cs            │   ├── dao.py
│                                     │   ├── services.py
├── HealthFirst.Infrastructure/       │   └── api/
│   └── Repositories/                 │
│       └── UserRepository.cs         └── requirements.txt
│
└── HealthFirst.sln
```

---

## 3. Django for Spring/Java Developers

### 3.1 Annotations → Decorators

**Spring (Annotations):**
```java
@RestController
@RequestMapping("/api/v1/accounts")
public class AccountsController {
    
    @Autowired
    private UserService userService;
    
    @PostMapping("/register")
    public ResponseEntity<UserDTO> register(@Valid @RequestBody RegisterRequest request) {
        User user = userService.register(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(new UserDTO(user));
    }
    
    @GetMapping("/profile")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<UserDTO> getProfile(@AuthenticationPrincipal User user) {
        return ResponseEntity.ok(new UserDTO(user));
    }
}
```

**Django (Decorators & Classes):**
```python
# accounts/api/views.py
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from ..services import AccountsService

class RegisterView(APIView):
    permission_classes = [AllowAny]  # Similar to @PreAuthorize("permitAll()")
    
    def post(self, request):
        serializer = RegisterSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({'error': serializer.errors}, status=400)
        
        user, profile = AccountsService.register_user(**serializer.validated_data)
        return Response({'id': user.id, 'email': user.email}, status=201)


class ProfileView(APIView):
    permission_classes = [IsAuthenticated]  # Similar to @PreAuthorize("isAuthenticated()")
    
    def get(self, request):
        # request.user is like @AuthenticationPrincipal
        return Response(UserSerializer(request.user).data)
```

---

### 3.2 JPA Entity → Django Model

**Spring JPA:**
```java
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(unique = true, nullable = false)
    private String email;
    
    @Column(length = 15)
    private String mobile;
    
    @Column(name = "is_active")
    private Boolean isActive = true;
    
    @OneToOne(mappedBy = "user", cascade = CascadeType.ALL)
    private UserProfile profile;
    
    @CreationTimestamp
    private LocalDateTime createdAt;
    
    // Getters, Setters, Constructors
}
```

**Django Model:**
```python
# accounts/models.py
from django.db import models
from django.contrib.auth.models import AbstractBaseUser

class User(AbstractBaseUser):
    email = models.EmailField(unique=True)  # @Column(unique=true)
    mobile = models.CharField(max_length=15)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)  # @CreationTimestamp
    
    class Meta:
        db_table = 'users'  # @Table(name = "users")
    
    # No getters/setters needed - Python properties are automatic


class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    full_name = models.CharField(max_length=255)
    
    class Meta:
        db_table = 'user_profiles'
```

---

### 3.3 Spring Repository → Django DAO

**Spring Repository:**
```java
@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
    boolean existsByEmail(String email);
    
    @Query("SELECT u FROM User u WHERE u.isActive = true")
    List<User> findAllActive();
}
```

**Django DAO:**
```python
# accounts/dao.py
from typing import Optional, List
from .models import User

class UserDAO:
    @staticmethod
    def find_by_id(user_id: int) -> Optional[User]:
        try:
            return User.objects.get(id=user_id)
        except User.DoesNotExist:
            return None
    
    @staticmethod
    def find_by_email(email: str) -> Optional[User]:
        try:
            return User.objects.get(email=email)
        except User.DoesNotExist:
            return None
    
    @staticmethod
    def exists_by_email(email: str) -> bool:
        return User.objects.filter(email=email).exists()
    
    @staticmethod
    def find_all_active() -> List[User]:
        return list(User.objects.filter(is_active=True))
    
    @staticmethod
    def save(user: User) -> User:
        user.save()
        return user
```

---

### 3.4 Spring Service → Django Service

**Spring Service:**
```java
@Service
@Transactional
public class UserService {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    public User register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new EmailExistsException("Email already exists");
        }
        
        User user = new User();
        user.setEmail(request.getEmail());
        user.setMobile(request.getMobile());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        
        UserProfile profile = new UserProfile();
        profile.setFullName(request.getFullName());
        profile.setUser(user);
        
        user.setProfile(profile);
        
        return userRepository.save(user);
    }
}
```

**Django Service:**
```python
# accounts/services.py
from django.db import transaction
from .dao import UserDAO, UserProfileDAO
from .models import User, UserProfile

class AccountsService:
    
    @staticmethod
    @transaction.atomic  # Similar to @Transactional
    def register_user(email: str, mobile: str, password: str, full_name: str):
        # Check if email exists
        if UserDAO.exists_by_email(email):
            raise ValueError('Email already exists')
        
        # Create user (password is automatically hashed by create_user)
        user = User.objects.create_user(
            email=email,
            mobile=mobile,
            password=password
        )
        
        # Create profile
        profile = UserProfileDAO.create(user=user, full_name=full_name)
        
        return user, profile
```

---

### 3.5 Spring Security → Django JWT

**Spring Security Config:**
```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf().disable()
            .cors().and()
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/v1/accounts/register", "/api/v1/accounts/login").permitAll()
                .requestMatchers("/api/v1/catalog/**").permitAll()
                .anyRequest().authenticated()
            )
            .oauth2ResourceServer(oauth2 -> oauth2.jwt());
        
        return http.build();
    }
}
```

**Django Settings:**
```python
# settings.py
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticated',
    ),
}

SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(minutes=60),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=7),
    'AUTH_HEADER_TYPES': ('Bearer',),
}

# Per-view permissions (like @PreAuthorize)
# In views.py:
class PublicView(APIView):
    permission_classes = [AllowAny]  # permitAll()

class ProtectedView(APIView):
    permission_classes = [IsAuthenticated]  # authenticated()
```

---

## 4. Django for .NET Developers

### 4.1 Controllers → Views

**ASP.NET Controller:**
```csharp
[ApiController]
[Route("api/v1/[controller]")]
public class AccountsController : ControllerBase
{
    private readonly IUserService _userService;
    
    public AccountsController(IUserService userService)
    {
        _userService = userService;
    }
    
    [HttpPost("register")]
    [AllowAnonymous]
    public async Task<ActionResult<UserDto>> Register([FromBody] RegisterRequest request)
    {
        if (!ModelState.IsValid)
            return BadRequest(ModelState);
        
        var user = await _userService.RegisterAsync(request);
        return CreatedAtAction(nameof(GetProfile), new { id = user.Id }, new UserDto(user));
    }
    
    [HttpGet("profile")]
    [Authorize]
    public async Task<ActionResult<UserDto>> GetProfile()
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        var user = await _userService.GetByIdAsync(int.Parse(userId));
        return Ok(new UserDto(user));
    }
}
```

**Django View:**
```python
# accounts/api/views.py
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated

class RegisterView(APIView):
    permission_classes = [AllowAny]  # [AllowAnonymous]
    
    def post(self, request):
        serializer = RegisterSerializer(data=request.data)
        if not serializer.is_valid():
            return Response(serializer.errors, status=400)  # BadRequest(ModelState)
        
        user, profile = AccountsService.register_user(**serializer.validated_data)
        return Response({
            'id': user.id,
            'email': user.email
        }, status=201)  # CreatedAtAction


class ProfileView(APIView):
    permission_classes = [IsAuthenticated]  # [Authorize]
    
    def get(self, request):
        # request.user is like User.FindFirstValue(ClaimTypes.NameIdentifier)
        user = request.user
        return Response(UserSerializer(user).data)
```

---

### 4.2 Entity Framework → Django ORM

**EF Core Entity:**
```csharp
public class User
{
    public int Id { get; set; }
    
    [Required]
    [MaxLength(255)]
    public string Email { get; set; }
    
    [MaxLength(15)]
    public string Mobile { get; set; }
    
    public bool IsActive { get; set; } = true;
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    
    // Navigation property
    public UserProfile Profile { get; set; }
}

// DbContext
public class AppDbContext : DbContext
{
    public DbSet<User> Users { get; set; }
    public DbSet<UserProfile> UserProfiles { get; set; }
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<User>()
            .HasIndex(u => u.Email)
            .IsUnique();
        
        modelBuilder.Entity<User>()
            .HasOne(u => u.Profile)
            .WithOne(p => p.User)
            .HasForeignKey<UserProfile>(p => p.UserId);
    }
}
```

**Django Model:**
```python
# accounts/models.py
from django.db import models

class User(models.Model):
    email = models.EmailField(max_length=255, unique=True)  # [Required], HasIndex().IsUnique()
    mobile = models.CharField(max_length=15)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'users'


class UserProfile(models.Model):
    user = models.OneToOneField(  # HasOne().WithOne()
        User, 
        on_delete=models.CASCADE,  # .OnDelete(DeleteBehavior.Cascade)
        related_name='profile'
    )
    full_name = models.CharField(max_length=255)
    
    class Meta:
        db_table = 'user_profiles'
```

---

### 4.3 EF Migrations → Django Migrations

**EF Core:**
```bash
# Create migration
dotnet ef migrations add AddUserTable

# Apply migration
dotnet ef database update

# Rollback
dotnet ef database update PreviousMigration
```

**Django:**
```bash
# Create migration
python manage.py makemigrations

# Apply migration
python manage.py migrate

# Rollback (by migration name)
python manage.py migrate accounts 0001_initial
```

---

### 4.4 Dependency Injection Comparison

**ASP.NET Core DI:**
```csharp
// Program.cs
builder.Services.AddScoped<IUserRepository, UserRepository>();
builder.Services.AddScoped<IUserService, UserService>();

// Controller
public class AccountsController : ControllerBase
{
    private readonly IUserService _userService;
    
    public AccountsController(IUserService userService)  // Constructor injection
    {
        _userService = userService;
    }
}
```

**Django (No DI container, explicit dependencies):**
```python
# accounts/services.py
class AccountsService:
    # Static methods - no instance needed
    # Dependencies are explicit module imports
    
    @staticmethod
    def register_user(email: str, mobile: str, password: str, full_name: str):
        # Direct use of DAO - explicit dependency
        if UserDAO.exists_by_email(email):
            raise ValueError('Email already exists')
        
        user = UserDAO.create(email=email, mobile=mobile, password=password)
        profile = UserProfileDAO.create(user=user, full_name=full_name)
        return user, profile


# Or use class-based with constructor injection
class AccountsService:
    def __init__(self, user_dao=None, profile_dao=None):
        self.user_dao = user_dao or UserDAO()
        self.profile_dao = profile_dao or UserProfileDAO()
    
    def register_user(self, email: str, mobile: str, password: str, full_name: str):
        if self.user_dao.exists_by_email(email):
            raise ValueError('Email already exists')
        # ...
```

---

## 5. Django for Node.js Developers

### 5.1 Express Routes → Django URLs

**Express.js:**
```javascript
// routes/accounts.js
const express = require('express');
const router = express.Router();
const accountsController = require('../controllers/accountsController');
const authMiddleware = require('../middleware/auth');

router.post('/register', accountsController.register);
router.post('/login', accountsController.login);
router.get('/profile', authMiddleware, accountsController.getProfile);
router.patch('/profile', authMiddleware, accountsController.updateProfile);

module.exports = router;

// app.js
app.use('/api/v1/accounts', accountsRoutes);
```

**Django:**
```python
# accounts/urls.py
from django.urls import path
from .api.views import RegisterView, LoginView, ProfileView

urlpatterns = [
    path('register/', RegisterView.as_view(), name='register'),
    path('login/', LoginView.as_view(), name='login'),
    path('profile/', ProfileView.as_view(), name='profile'),  # Auth handled in view
]

# healthcare_plans_bo/urls.py
from django.urls import path, include

urlpatterns = [
    path('api/v1/accounts/', include('accounts.urls')),
]
```

---

### 5.2 Express Controller → Django View

**Express Controller:**
```javascript
// controllers/accountsController.js
const UserService = require('../services/userService');

exports.register = async (req, res) => {
    try {
        const { email, mobile, password, fullName } = req.body;
        
        // Validation
        if (!email || !password) {
            return res.status(400).json({ error: 'Email and password required' });
        }
        
        const user = await UserService.register({ email, mobile, password, fullName });
        
        res.status(201).json({
            id: user.id,
            email: user.email,
            message: 'Registration successful'
        });
    } catch (error) {
        if (error.message === 'Email already exists') {
            return res.status(400).json({ error: error.message });
        }
        res.status(500).json({ error: 'Internal server error' });
    }
};

exports.getProfile = async (req, res) => {
    try {
        const user = await UserService.getById(req.user.id);
        res.json(user);
    } catch (error) {
        res.status(500).json({ error: 'Internal server error' });
    }
};
```

**Django View:**
```python
# accounts/api/views.py
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from ..services import AccountsService
from .serializers import RegisterSerializer, UserSerializer

class RegisterView(APIView):
    permission_classes = [AllowAny]
    
    def post(self, request):
        # Validation via Serializer (like Joi in Node.js)
        serializer = RegisterSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({'error': serializer.errors}, status=400)
        
        try:
            user, profile = AccountsService.register_user(
                email=serializer.validated_data['email'],
                mobile=serializer.validated_data['mobile'],
                password=serializer.validated_data['password'],
                full_name=serializer.validated_data['full_name']
            )
            
            return Response({
                'id': user.id,
                'email': user.email,
                'message': 'Registration successful'
            }, status=201)
            
        except ValueError as e:
            return Response({'error': str(e)}, status=400)


class ProfileView(APIView):
    permission_classes = [IsAuthenticated]  # Like authMiddleware
    
    def get(self, request):
        # request.user is set by JWT authentication (like req.user in Express)
        return Response(UserSerializer(request.user).data)
```

---

### 5.3 Sequelize → Django ORM

**Sequelize Model:**
```javascript
// models/User.js
const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
    const User = sequelize.define('User', {
        email: {
            type: DataTypes.STRING(255),
            allowNull: false,
            unique: true,
            validate: {
                isEmail: true
            }
        },
        mobile: {
            type: DataTypes.STRING(15)
        },
        password: {
            type: DataTypes.STRING(255),
            allowNull: false
        },
        isActive: {
            type: DataTypes.BOOLEAN,
            defaultValue: true
        }
    }, {
        tableName: 'users',
        timestamps: true,
        createdAt: 'created_at',
        updatedAt: 'updated_at'
    });
    
    User.associate = (models) => {
        User.hasOne(models.UserProfile, { foreignKey: 'userId', as: 'profile' });
    };
    
    return User;
};

// Usage
const user = await User.findOne({ where: { email } });
const users = await User.findAll({ where: { isActive: true } });
```

**Django Model:**
```python
# accounts/models.py
from django.db import models

class User(models.Model):
    email = models.EmailField(max_length=255, unique=True)
    mobile = models.CharField(max_length=15)
    password = models.CharField(max_length=255)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'users'


# Usage (in DAO)
user = User.objects.get(email=email)  # findOne
users = User.objects.filter(is_active=True)  # findAll with where
```

---

### 5.4 Async/Await Comparison

**Node.js (Async by default):**
```javascript
exports.register = async (req, res) => {
    const user = await UserService.register(req.body);
    const profile = await ProfileService.create(user.id, req.body.fullName);
    res.status(201).json(user);
};
```

**Django (Sync by default, async optional):**
```python
# Synchronous (default, simpler)
class RegisterView(APIView):
    def post(self, request):
        user, profile = AccountsService.register_user(**request.data)
        return Response({'id': user.id}, status=201)


# Asynchronous (Django 4.1+, for high concurrency)
from adrf.views import APIView  # Django Async REST Framework

class RegisterView(APIView):
    async def post(self, request):
        user, profile = await AccountsService.register_user_async(**request.data)
        return Response({'id': user.id}, status=201)
```

---

## 6. Angular Modern Practices

### 6.1 Angular 17+ Changes

If you've used Angular before, here's what's new:

| Feature | Old Way (Angular 14-) | New Way (Angular 17+) |
|---------|----------------------|----------------------|
| **Components** | NgModules required | Standalone components |
| **Control Flow** | `*ngIf`, `*ngFor` | `@if`, `@for` blocks |
| **Lazy Loading** | Module-based | Component-based |
| **Signals** | Not available | Reactive primitives |
| **SSR** | Angular Universal | Built-in SSR |

---

### 6.2 Standalone Components

**Old (Module-based):**
```typescript
// app.module.ts
@NgModule({
    declarations: [LoginComponent, RegisterComponent],
    imports: [CommonModule, ReactiveFormsModule, RouterModule],
    exports: [LoginComponent]
})
export class AccountsModule {}

// login.component.ts
@Component({
    selector: 'app-login',
    templateUrl: './login.component.html'
})
export class LoginComponent {}
```

**New (Standalone):**
```typescript
// login.component.ts
@Component({
    selector: 'app-login',
    standalone: true,
    imports: [CommonModule, ReactiveFormsModule, RouterLink],
    templateUrl: './login.component.html'
})
export class LoginComponent {}

// app.routes.ts (no module needed)
export const routes: Routes = [
    {
        path: 'login',
        loadComponent: () => import('./features/accounts/login/login.component')
            .then(m => m.LoginComponent)
    }
];
```

---

### 6.3 New Control Flow

**Old:**
```html
<div *ngIf="isLoading; else content">
    <spinner></spinner>
</div>
<ng-template #content>
    <div *ngFor="let plan of plans; trackBy: trackByPlanId">
        {{ plan.name }}
    </div>
</ng-template>
```

**New (Angular 17+):**
```html
@if (isLoading) {
    <spinner></spinner>
} @else {
    @for (plan of plans; track plan.id) {
        <div>{{ plan.name }}</div>
    } @empty {
        <div>No plans found</div>
    }
}
```

---

### 6.4 Signals (New Reactivity)

**Old (RxJS Observables):**
```typescript
export class ProfileComponent implements OnInit {
    user$: Observable<User>;
    
    constructor(private authService: AuthService) {}
    
    ngOnInit() {
        this.user$ = this.authService.currentUser$;
    }
}

// Template
<div *ngIf="user$ | async as user">
    {{ user.email }}
</div>
```

**New (Signals):**
```typescript
export class ProfileComponent {
    user = signal<User | null>(null);
    isLoading = signal(true);
    
    // Computed values
    userEmail = computed(() => this.user()?.email ?? 'Not logged in');
    
    constructor(private authService: AuthService) {
        effect(() => {
            // Runs when user signal changes
            console.log('User changed:', this.user());
        });
    }
}

// Template
<div>{{ userEmail() }}</div>
```

---

## 7. GCP for AWS/Azure Developers

### 7.1 Service Mapping

| Purpose | AWS | Azure | GCP (This Repo) |
|---------|-----|-------|-----------------|
| **Container Hosting** | ECS/Fargate | Container Apps | Cloud Run |
| **Managed Database** | RDS | Azure SQL | Cloud SQL |
| **Container Registry** | ECR | ACR | Artifact Registry |
| **Secrets** | Secrets Manager | Key Vault | Secret Manager |
| **CI/CD** | CodePipeline | Azure DevOps | Cloud Build |
| **Serverless Functions** | Lambda | Functions | Cloud Functions |
| **API Gateway** | API Gateway | API Management | Cloud Endpoints |
| **Load Balancer** | ALB/ELB | Load Balancer | Cloud Load Balancing |
| **Logging** | CloudWatch | Monitor | Cloud Logging |
| **Monitoring** | CloudWatch | Monitor | Cloud Monitoring |
| **IAM** | IAM | Azure AD | Cloud IAM |

---

### 7.2 Cloud Run vs ECS vs Container Apps

| Feature | AWS ECS/Fargate | Azure Container Apps | GCP Cloud Run |
|---------|-----------------|---------------------|---------------|
| **Scaling** | Manual/Auto | Auto | Auto (to zero) |
| **Pricing** | Per vCPU/memory | Per vCPU/memory | Per request |
| **Cold Start** | Warm containers | Warm containers | Cold start possible |
| **Max Timeout** | No limit | 30 min | 60 min |
| **Concurrency** | Configurable | Configurable | Up to 1000/instance |

---

### 7.3 Deployment Command Comparison

**AWS ECS:**
```bash
# Build and push
aws ecr get-login-password | docker login --username AWS --password-stdin $ECR_URL
docker build -t my-app .
docker tag my-app:latest $ECR_URL/my-app:latest
docker push $ECR_URL/my-app:latest

# Deploy
aws ecs update-service --cluster my-cluster --service my-service --force-new-deployment
```

**Azure Container Apps:**
```bash
# Build and push
az acr login --name myregistry
docker build -t my-app .
docker tag my-app myregistry.azurecr.io/my-app:latest
docker push myregistry.azurecr.io/my-app:latest

# Deploy
az containerapp update --name my-app --resource-group my-rg --image myregistry.azurecr.io/my-app:latest
```

**GCP Cloud Run:**
```bash
# Build and push
gcloud auth configure-docker asia-south1-docker.pkg.dev
docker build -t my-app .
docker tag my-app asia-south1-docker.pkg.dev/project-id/repo/my-app:latest
docker push asia-south1-docker.pkg.dev/project-id/repo/my-app:latest

# Deploy
gcloud run deploy my-app --image asia-south1-docker.pkg.dev/project-id/repo/my-app:latest --region asia-south1
```

---

## 8. Enterprise Patterns in Python

### 8.1 Repository Pattern (DAO)

```python
# accounts/dao.py
from typing import Optional, List, Protocol
from .models import User

# Interface (Protocol in Python)
class UserRepositoryProtocol(Protocol):
    def find_by_id(self, user_id: int) -> Optional[User]: ...
    def find_by_email(self, email: str) -> Optional[User]: ...
    def save(self, user: User) -> User: ...
    def delete(self, user: User) -> None: ...

# Implementation
class UserDAO:
    @staticmethod
    def find_by_id(user_id: int) -> Optional[User]:
        try:
            return User.objects.select_related('profile').get(id=user_id)
        except User.DoesNotExist:
            return None
    
    @staticmethod
    def find_by_email(email: str) -> Optional[User]:
        try:
            return User.objects.get(email=email)
        except User.DoesNotExist:
            return None
    
    @staticmethod
    def save(user: User) -> User:
        user.save()
        return user
    
    @staticmethod
    def delete(user: User) -> None:
        user.delete()
```

---

### 8.2 Service Layer Pattern

```python
# accounts/services.py
from django.db import transaction
from typing import Tuple
from .dao import UserDAO, UserProfileDAO
from .models import User, UserProfile

class AccountsService:
    """
    Service layer containing business logic.
    Similar to @Service in Spring or Service classes in .NET.
    """
    
    @staticmethod
    @transaction.atomic  # @Transactional equivalent
    def register_user(
        email: str, 
        mobile: str, 
        password: str, 
        full_name: str
    ) -> Tuple[User, UserProfile]:
        """
        Register a new user with profile.
        
        Business Rules:
        1. Email must be unique
        2. Password must meet complexity requirements (handled in serializer)
        3. Profile is created automatically with user
        
        Raises:
            ValueError: If email already exists
        """
        # Business Rule: Check email uniqueness
        if UserDAO.exists_by_email(email):
            raise ValueError('Email already exists')
        
        # Create user
        user = UserDAO.create(email=email, mobile=mobile, password=password)
        
        # Create profile (business rule: every user has a profile)
        profile = UserProfileDAO.create(user=user, full_name=full_name)
        
        return user, profile
    
    @staticmethod
    def authenticate(email: str, password: str) -> Optional[User]:
        """
        Authenticate user with email and password.
        """
        user = UserDAO.find_by_email(email)
        
        if user and user.check_password(password) and user.is_active:
            return user
        
        return None
```

---

### 8.3 DTO Pattern (Serializers)

```python
# accounts/api/serializers.py
from rest_framework import serializers

# Request DTO
class RegisterRequestSerializer(serializers.Serializer):
    """
    Similar to RegisterRequest DTO in Java/C#.
    Handles validation and deserialization.
    """
    email = serializers.EmailField()
    mobile = serializers.CharField(max_length=15)
    password = serializers.CharField(min_length=8, write_only=True)
    full_name = serializers.CharField(max_length=255)
    
    def validate_mobile(self, value):
        """Custom validation (like @Valid annotations)"""
        if not value.isdigit() or len(value) != 10:
            raise serializers.ValidationError('Mobile must be 10 digits')
        return value


# Response DTO
class UserResponseSerializer(serializers.ModelSerializer):
    """
    Similar to UserDTO/UserResponse in Java/C#.
    Handles serialization of model to JSON.
    """
    profile = UserProfileSerializer(read_only=True)
    
    class Meta:
        model = User
        fields = ['id', 'email', 'mobile', 'is_active', 'created_at', 'profile']
        read_only_fields = ['id', 'created_at']
```

---

### 8.4 Unit of Work Pattern

```python
# Django's transaction.atomic is the Unit of Work pattern
from django.db import transaction

class OrderService:
    @staticmethod
    @transaction.atomic
    def create_order(user: User, cart: Cart) -> Order:
        """
        Creates order from cart.
        All operations succeed or all fail (atomic).
        """
        # Create order
        order = OrderDAO.create(user=user, total=cart.total)
        
        # Create order items from cart items
        for cart_item in cart.items.all():
            OrderItemDAO.create(
                order=order,
                plan=cart_item.plan,
                amount=cart_item.plan.premium
            )
        
        # Clear cart
        CartDAO.clear(cart)
        
        # If any operation fails, everything rolls back
        return order
```

---

## 9. Testing Strategies

### 9.1 Test Structure Comparison

| Test Type | Java/Spring | .NET | Django |
|-----------|-------------|------|--------|
| **Unit Test** | JUnit + Mockito | xUnit + Moq | pytest + unittest.mock |
| **Integration Test** | @SpringBootTest | WebApplicationFactory | Django TestCase |
| **API Test** | MockMvc | HttpClient | DRF APITestCase |
| **DB Test** | @DataJpaTest | InMemory DB | TestCase (SQLite) |

---

### 9.2 Django Test Examples

```python
# accounts/tests/test_services.py
from django.test import TestCase
from unittest.mock import patch, MagicMock
from ..services import AccountsService
from ..models import User

class AccountsServiceTest(TestCase):
    """Unit tests for AccountsService"""
    
    def test_register_user_success(self):
        """Test successful user registration"""
        user, profile = AccountsService.register_user(
            email='test@example.com',
            mobile='9876543210',
            password='password123',
            full_name='Test User'
        )
        
        self.assertEqual(user.email, 'test@example.com')
        self.assertEqual(profile.full_name, 'Test User')
    
    def test_register_user_duplicate_email(self):
        """Test registration with existing email fails"""
        # Create first user
        AccountsService.register_user(
            email='test@example.com',
            mobile='9876543210',
            password='password123',
            full_name='Test User'
        )
        
        # Try to create duplicate
        with self.assertRaises(ValueError) as context:
            AccountsService.register_user(
                email='test@example.com',
                mobile='1234567890',
                password='password456',
                full_name='Another User'
            )
        
        self.assertEqual(str(context.exception), 'Email already exists')


# accounts/tests/test_views.py
from rest_framework.test import APITestCase
from rest_framework import status

class RegisterViewTest(APITestCase):
    """Integration tests for Register API"""
    
    def test_register_api_success(self):
        """Test POST /api/v1/accounts/register/"""
        data = {
            'email': 'test@example.com',
            'mobile': '9876543210',
            'password': 'password123',
            'full_name': 'Test User'
        }
        
        response = self.client.post('/api/v1/accounts/register/', data)
        
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data['email'], 'test@example.com')
    
    def test_register_api_invalid_email(self):
        """Test validation error for invalid email"""
        data = {
            'email': 'invalid-email',
            'mobile': '9876543210',
            'password': 'password123',
            'full_name': 'Test User'
        }
        
        response = self.client.post('/api/v1/accounts/register/', data)
        
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
```

---

## 10. Performance & Scalability

### 10.1 Django ORM Optimization

```python
# ❌ Bad: N+1 query problem
users = User.objects.all()
for user in users:
    print(user.profile.full_name)  # Separate query for each user!

# ✅ Good: Use select_related (JOIN)
users = User.objects.select_related('profile').all()
for user in users:
    print(user.profile.full_name)  # Single query with JOIN

# ✅ Good: Use prefetch_related (for reverse FK / M2M)
orders = Order.objects.prefetch_related('items').all()
for order in orders:
    for item in order.items.all():  # Already loaded
        print(item.plan_name)
```

---

### 10.2 Caching

```python
# settings.py
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.redis.RedisCache',
        'LOCATION': 'redis://localhost:6379/1',
    }
}

# services.py
from django.core.cache import cache

class CatalogService:
    @staticmethod
    def get_all_plans():
        cache_key = 'all_health_plans'
        plans = cache.get(cache_key)
        
        if plans is None:
            plans = list(HealthPlan.objects.filter(is_active=True))
            cache.set(cache_key, plans, timeout=3600)  # 1 hour
        
        return plans
```

---

### 10.3 Database Indexing

```python
# models.py
class HealthPlan(models.Model):
    name = models.CharField(max_length=255, db_index=True)  # Index for search
    category = models.ForeignKey(Category, on_delete=models.CASCADE)
    coverage_amount = models.IntegerField(db_index=True)  # Index for filtering
    is_active = models.BooleanField(default=True, db_index=True)
    
    class Meta:
        indexes = [
            models.Index(fields=['category', 'is_active']),  # Composite index
            models.Index(fields=['coverage_amount', 'monthly_premium']),
        ]
```

---

## 11. Security Best Practices

### 11.1 Django Security Checklist

```python
# settings.py (Production)

# HTTPS
SECURE_SSL_REDIRECT = True
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')

# Cookies
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True

# HSTS
SECURE_HSTS_SECONDS = 31536000
SECURE_HSTS_INCLUDE_SUBDOMAINS = True

# Content Security
SECURE_CONTENT_TYPE_NOSNIFF = True
X_FRAME_OPTIONS = 'DENY'

# Password validation
AUTH_PASSWORD_VALIDATORS = [
    {'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
     'OPTIONS': {'min_length': 8}},
    {'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator'},
    {'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator'},
]
```

---

### 11.2 Input Validation

```python
# serializers.py
from rest_framework import serializers
import re

class RegisterSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(min_length=8, max_length=128)
    mobile = serializers.CharField(max_length=15)
    
    def validate_password(self, value):
        """Ensure password complexity"""
        if not re.search(r'[A-Z]', value):
            raise serializers.ValidationError('Password must contain uppercase')
        if not re.search(r'[0-9]', value):
            raise serializers.ValidationError('Password must contain number')
        return value
    
    def validate_mobile(self, value):
        """Sanitize and validate mobile"""
        # Remove any non-digit characters
        clean_mobile = re.sub(r'\D', '', value)
        if len(clean_mobile) != 10:
            raise serializers.ValidationError('Mobile must be 10 digits')
        return clean_mobile
```

---

## 12. Migration Strategies

### 12.1 Migrating from Spring Boot to Django

| Step | Action |
|------|--------|
| 1 | Map Java entities to Django models |
| 2 | Convert JPA repositories to DAO classes |
| 3 | Translate @Service classes to services.py |
| 4 | Convert @RestController to DRF views |
| 5 | Migrate application.yml to settings.py |
| 6 | Update build from Maven/Gradle to pip/requirements.txt |
| 7 | Replace Spring Security with Django JWT |
| 8 | Update CI/CD pipeline |

---

### 12.2 Migrating from .NET to Django

| Step | Action |
|------|--------|
| 1 | Convert EF entities to Django models |
| 2 | Replace DbContext with Django ORM |
| 3 | Translate service classes to Python |
| 4 | Convert Controllers to DRF APIViews |
| 5 | Migrate appsettings.json to settings.py |
| 6 | Update from NuGet to pip |
| 7 | Replace Identity with Django Auth |
| 8 | Update Azure DevOps to GitHub Actions |

---

### 12.3 Running Both During Migration

```yaml
# docker-compose.yml - Run both systems during migration
version: '3.8'
services:
  legacy-spring:
    image: legacy-spring-app:latest
    ports:
      - "8081:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=migration
  
  new-django:
    image: new-django-app:latest
    ports:
      - "8000:8000"
    environment:
      - DJANGO_SETTINGS_MODULE=healthcare_plans_bo.settings
  
  nginx:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    # Route traffic based on path or header
```

---

## Summary: Quick Reference

### Command Comparison

| Task | Spring Boot | .NET | Django |
|------|-------------|------|--------|
| Create project | `spring init` | `dotnet new webapi` | `django-admin startproject` |
| Create app/module | Package structure | Project/folder | `python manage.py startapp` |
| Run dev server | `./mvnw spring-boot:run` | `dotnet run` | `python manage.py runserver` |
| Run tests | `./mvnw test` | `dotnet test` | `python manage.py test` |
| Create migration | Flyway/Liquibase | `dotnet ef migrations add` | `python manage.py makemigrations` |
| Apply migration | Flyway/Liquibase | `dotnet ef database update` | `python manage.py migrate` |
| Shell/REPL | `jshell` | `dotnet script` | `python manage.py shell` |

---

## Next Steps

1. **Clone this repository** and explore the code structure
2. **Compare patterns** you know with Django implementations
3. **Run the application** locally using `npm run setup && npm run start`
4. **Deploy to GCP** using the GitHub Actions workflows
5. **Extend the project** with your own features

---

*Happy Learning! 💼*

---

*Last Updated: December 2025*
