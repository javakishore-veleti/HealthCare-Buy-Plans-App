#!/bin/bash

# =============================================================================
# setup_02_accounts_feature.sh
# Purpose: Create accounts feature - signup, login, profile components
# Run this AFTER: setup_01_angular_next_steps.sh
# =============================================================================

echo "=========================================="
echo "Angular Setup - Step 02: Accounts Feature"
echo "=========================================="

# Navigate to Angular app folder
cd front_end_code/healthcare_plans_ui

# -----------------------------------------
# Step 1: Create User Model
# -----------------------------------------
echo ""
echo "[Step 1] Creating User model..."

cat > src/app/models/user.model.ts << 'EOF'
export interface User {
  id: number;
  email: string;
  mobile: string;
  is_active: boolean;
  is_staff: boolean;
  created_at: string;
  updated_at: string;
}

export interface UserProfile {
  id: number;
  user_id: number;
  full_name: string;
  date_of_birth: string | null;
  gender: string | null;
  address_line1: string | null;
  address_line2: string | null;
  city: string | null;
  state: string | null;
  pincode: string | null;
  created_at: string;
  updated_at: string;
}

export interface UserWithProfile extends User {
  profile: UserProfile;
}
EOF

echo "    ✓ user.model.ts created"

# -----------------------------------------
# Step 2: Create Auth Models
# -----------------------------------------
echo ""
echo "[Step 2] Creating Auth models..."

cat > src/app/models/auth.model.ts << 'EOF'
export interface RegisterRequest {
  email: string;
  mobile: string;
  password: string;
  full_name: string;
}

export interface RegisterResponse {
  id: number;
  email: string;
  message: string;
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface LoginResponse {
  access_token: string;
  refresh_token: string;
  expires_in: number;
}

export interface LogoutResponse {
  message: string;
}

export interface ProfileUpdateRequest {
  full_name?: string;
  date_of_birth?: string;
  gender?: string;
  address_line1?: string;
  address_line2?: string;
  city?: string;
  state?: string;
  pincode?: string;
}

export interface ApiError {
  error: string;
  details?: { [key: string]: string[] };
}
EOF

echo "    ✓ auth.model.ts created"

# -----------------------------------------
# Step 3: Create Models Index
# -----------------------------------------
echo ""
echo "[Step 3] Creating models index..."

cat > src/app/models/index.ts << 'EOF'
export * from './user.model';
export * from './auth.model';
EOF

echo "    ✓ models/index.ts created"

# -----------------------------------------
# Step 4: Create Auth Service
# -----------------------------------------
echo ""
echo "[Step 4] Creating Auth service..."

cat > src/app/core/auth/auth.service.ts << 'EOF'
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject, Observable, tap } from 'rxjs';
import { environment } from '../../../environments/environment';
import {
  RegisterRequest,
  RegisterResponse,
  LoginRequest,
  LoginResponse,
  LogoutResponse,
  UserWithProfile,
  ProfileUpdateRequest
} from '../../models';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private apiUrl = `${environment.apiBaseUrl}/accounts`;
  private currentUserSubject = new BehaviorSubject<UserWithProfile | null>(null);
  
  currentUser$ = this.currentUserSubject.asObservable();

  constructor(private http: HttpClient) {
    this.loadStoredUser();
  }

  private loadStoredUser(): void {
    const token = localStorage.getItem('access_token');
    if (token) {
      this.getProfile().subscribe({
        next: (user) => this.currentUserSubject.next(user),
        error: () => this.logout()
      });
    }
  }

  register(data: RegisterRequest): Observable<RegisterResponse> {
    return this.http.post<RegisterResponse>(`${this.apiUrl}/register/`, data);
  }

  login(data: LoginRequest): Observable<LoginResponse> {
    return this.http.post<LoginResponse>(`${this.apiUrl}/login/`, data).pipe(
      tap((response) => {
        localStorage.setItem('access_token', response.access_token);
        localStorage.setItem('refresh_token', response.refresh_token);
        this.loadStoredUser();
      })
    );
  }

  logout(): Observable<LogoutResponse> {
    return this.http.post<LogoutResponse>(`${this.apiUrl}/logout/`, {}).pipe(
      tap(() => {
        localStorage.removeItem('access_token');
        localStorage.removeItem('refresh_token');
        this.currentUserSubject.next(null);
      })
    );
  }

  getProfile(): Observable<UserWithProfile> {
    return this.http.get<UserWithProfile>(`${this.apiUrl}/profile/`);
  }

  updateProfile(data: ProfileUpdateRequest): Observable<UserWithProfile> {
    return this.http.patch<UserWithProfile>(`${this.apiUrl}/profile/`, data).pipe(
      tap((user) => this.currentUserSubject.next(user))
    );
  }

  isLoggedIn(): boolean {
    return !!localStorage.getItem('access_token');
  }

  getToken(): string | null {
    return localStorage.getItem('access_token');
  }
}
EOF

echo "    ✓ auth.service.ts created"

# -----------------------------------------
# Step 5: Create Auth Guard
# -----------------------------------------
echo ""
echo "[Step 5] Creating Auth guard..."

cat > src/app/core/guards/auth.guard.ts << 'EOF'
import { Injectable } from '@angular/core';
import { CanActivate, Router } from '@angular/router';
import { AuthService } from '../auth/auth.service';

@Injectable({
  providedIn: 'root'
})
export class AuthGuard implements CanActivate {

  constructor(
    private authService: AuthService,
    private router: Router
  ) {}

  canActivate(): boolean {
    if (this.authService.isLoggedIn()) {
      return true;
    }
    this.router.navigate(['/login']);
    return false;
  }
}
EOF

echo "    ✓ auth.guard.ts created"

# -----------------------------------------
# Step 6: Create Guest Guard (redirect if logged in)
# -----------------------------------------
echo ""
echo "[Step 6] Creating Guest guard..."

cat > src/app/core/guards/guest.guard.ts << 'EOF'
import { Injectable } from '@angular/core';
import { CanActivate, Router } from '@angular/router';
import { AuthService } from '../auth/auth.service';

@Injectable({
  providedIn: 'root'
})
export class GuestGuard implements CanActivate {

  constructor(
    private authService: AuthService,
    private router: Router
  ) {}

  canActivate(): boolean {
    if (!this.authService.isLoggedIn()) {
      return true;
    }
    this.router.navigate(['/profile']);
    return false;
  }
}
EOF

echo "    ✓ guest.guard.ts created"

# -----------------------------------------
# Step 7: Create Auth Interceptor
# -----------------------------------------
echo ""
echo "[Step 7] Creating Auth interceptor..."

cat > src/app/core/interceptors/auth.interceptor.ts << 'EOF'
import { Injectable } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor
} from '@angular/common/http';
import { Observable } from 'rxjs';
import { AuthService } from '../auth/auth.service';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {

  constructor(private authService: AuthService) {}

  intercept(request: HttpRequest<unknown>, next: HttpHandler): Observable<HttpEvent<unknown>> {
    const token = this.authService.getToken();
    
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
EOF

echo "    ✓ auth.interceptor.ts created"

# -----------------------------------------
# Step 8: Create Registration Component
# -----------------------------------------
echo ""
echo "[Step 8] Creating Registration component..."

mkdir -p src/app/features/accounts/register

cat > src/app/features/accounts/register/register.component.ts << 'EOF'
import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../../../core/auth/auth.service';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterLink],
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.scss']
})
export class RegisterComponent {
  registerForm: FormGroup;
  isLoading = false;
  errorMessage = '';
  successMessage = '';

  constructor(
    private fb: FormBuilder,
    private authService: AuthService,
    private router: Router
  ) {
    this.registerForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      mobile: ['', [Validators.required, Validators.pattern('^[0-9]{10}$')]],
      password: ['', [Validators.required, Validators.minLength(8)]],
      confirmPassword: ['', [Validators.required]],
      full_name: ['', [Validators.required, Validators.maxLength(255)]]
    }, { validators: this.passwordMatchValidator });
  }

  passwordMatchValidator(form: FormGroup) {
    const password = form.get('password');
    const confirmPassword = form.get('confirmPassword');
    
    if (password && confirmPassword && password.value !== confirmPassword.value) {
      confirmPassword.setErrors({ passwordMismatch: true });
    }
    return null;
  }

  onSubmit(): void {
    if (this.registerForm.invalid) {
      this.registerForm.markAllAsTouched();
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';
    this.successMessage = '';

    const { confirmPassword, ...registerData } = this.registerForm.value;

    this.authService.register(registerData).subscribe({
      next: (response) => {
        this.isLoading = false;
        this.successMessage = response.message;
        setTimeout(() => {
          this.router.navigate(['/login']);
        }, 2000);
      },
      error: (error) => {
        this.isLoading = false;
        this.errorMessage = error.error?.error || 'Registration failed. Please try again.';
      }
    });
  }

  get f() {
    return this.registerForm.controls;
  }
}
EOF

cat > src/app/features/accounts/register/register.component.html << 'EOF'
<div class="container">
  <div class="form-container">
    <h2 class="text-center mb-4">Create Account</h2>
    <p class="text-center text-muted mb-4">Join Your Health Plans today</p>

    <!-- Success Message -->
    <div *ngIf="successMessage" class="alert alert-success" role="alert">
      {{ successMessage }}
    </div>

    <!-- Error Message -->
    <div *ngIf="errorMessage" class="alert alert-danger" role="alert">
      {{ errorMessage }}
    </div>

    <form [formGroup]="registerForm" (ngSubmit)="onSubmit()">
      <!-- Full Name -->
      <div class="mb-3">
        <label for="full_name" class="form-label">Full Name</label>
        <input
          type="text"
          class="form-control"
          id="full_name"
          formControlName="full_name"
          [class.is-invalid]="f['full_name'].touched && f['full_name'].invalid"
          placeholder="Enter your full name"
        >
        <div class="invalid-feedback" *ngIf="f['full_name'].touched && f['full_name'].errors">
          <span *ngIf="f['full_name'].errors['required']">Full name is required</span>
        </div>
      </div>

      <!-- Email -->
      <div class="mb-3">
        <label for="email" class="form-label">Email Address</label>
        <input
          type="email"
          class="form-control"
          id="email"
          formControlName="email"
          [class.is-invalid]="f['email'].touched && f['email'].invalid"
          placeholder="Enter your email"
        >
        <div class="invalid-feedback" *ngIf="f['email'].touched && f['email'].errors">
          <span *ngIf="f['email'].errors['required']">Email is required</span>
          <span *ngIf="f['email'].errors['email']">Please enter a valid email</span>
        </div>
      </div>

      <!-- Mobile -->
      <div class="mb-3">
        <label for="mobile" class="form-label">Mobile Number</label>
        <input
          type="tel"
          class="form-control"
          id="mobile"
          formControlName="mobile"
          [class.is-invalid]="f['mobile'].touched && f['mobile'].invalid"
          placeholder="Enter 10-digit mobile number"
        >
        <div class="invalid-feedback" *ngIf="f['mobile'].touched && f['mobile'].errors">
          <span *ngIf="f['mobile'].errors['required']">Mobile number is required</span>
          <span *ngIf="f['mobile'].errors['pattern']">Please enter a valid 10-digit mobile number</span>
        </div>
      </div>

      <!-- Password -->
      <div class="mb-3">
        <label for="password" class="form-label">Password</label>
        <input
          type="password"
          class="form-control"
          id="password"
          formControlName="password"
          [class.is-invalid]="f['password'].touched && f['password'].invalid"
          placeholder="Enter password (min 8 characters)"
        >
        <div class="invalid-feedback" *ngIf="f['password'].touched && f['password'].errors">
          <span *ngIf="f['password'].errors['required']">Password is required</span>
          <span *ngIf="f['password'].errors['minlength']">Password must be at least 8 characters</span>
        </div>
      </div>

      <!-- Confirm Password -->
      <div class="mb-3">
        <label for="confirmPassword" class="form-label">Confirm Password</label>
        <input
          type="password"
          class="form-control"
          id="confirmPassword"
          formControlName="confirmPassword"
          [class.is-invalid]="f['confirmPassword'].touched && f['confirmPassword'].invalid"
          placeholder="Confirm your password"
        >
        <div class="invalid-feedback" *ngIf="f['confirmPassword'].touched && f['confirmPassword'].errors">
          <span *ngIf="f['confirmPassword'].errors['required']">Please confirm your password</span>
          <span *ngIf="f['confirmPassword'].errors['passwordMismatch']">Passwords do not match</span>
        </div>
      </div>

      <!-- Submit Button -->
      <div class="d-grid mb-3">
        <button
          type="submit"
          class="btn btn-primary btn-lg"
          [disabled]="isLoading"
        >
          <span *ngIf="isLoading" class="spinner-border spinner-border-sm me-2" role="status"></span>
          {{ isLoading ? 'Creating Account...' : 'Register' }}
        </button>
      </div>

      <!-- Login Link -->
      <p class="text-center mb-0">
        Already have an account? <a routerLink="/login" class="text-decoration-none">Login here</a>
      </p>
    </form>
  </div>
</div>
EOF

cat > src/app/features/accounts/register/register.component.scss << 'EOF'
// Register component specific styles
EOF

echo "    ✓ register.component.ts created"
echo "    ✓ register.component.html created"
echo "    ✓ register.component.scss created"

# -----------------------------------------
# Step 9: Create Login Component
# -----------------------------------------
echo ""
echo "[Step 9] Creating Login component..."

mkdir -p src/app/features/accounts/login

cat > src/app/features/accounts/login/login.component.ts << 'EOF'
import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../../../core/auth/auth.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterLink],
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent {
  loginForm: FormGroup;
  isLoading = false;
  errorMessage = '';

  constructor(
    private fb: FormBuilder,
    private authService: AuthService,
    private router: Router
  ) {
    this.loginForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      password: ['', [Validators.required]]
    });
  }

  onSubmit(): void {
    if (this.loginForm.invalid) {
      this.loginForm.markAllAsTouched();
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';

    this.authService.login(this.loginForm.value).subscribe({
      next: () => {
        this.isLoading = false;
        this.router.navigate(['/profile']);
      },
      error: (error) => {
        this.isLoading = false;
        this.errorMessage = error.error?.error || 'Invalid email or password';
      }
    });
  }

  get f() {
    return this.loginForm.controls;
  }
}
EOF

cat > src/app/features/accounts/login/login.component.html << 'EOF'
<div class="container">
  <div class="form-container">
    <h2 class="text-center mb-4">Welcome Back</h2>
    <p class="text-center text-muted mb-4">Login to Your Health Plans</p>

    <!-- Error Message -->
    <div *ngIf="errorMessage" class="alert alert-danger" role="alert">
      {{ errorMessage }}
    </div>

    <form [formGroup]="loginForm" (ngSubmit)="onSubmit()">
      <!-- Email -->
      <div class="mb-3">
        <label for="email" class="form-label">Email Address</label>
        <input
          type="email"
          class="form-control"
          id="email"
          formControlName="email"
          [class.is-invalid]="f['email'].touched && f['email'].invalid"
          placeholder="Enter your email"
        >
        <div class="invalid-feedback" *ngIf="f['email'].touched && f['email'].errors">
          <span *ngIf="f['email'].errors['required']">Email is required</span>
          <span *ngIf="f['email'].errors['email']">Please enter a valid email</span>
        </div>
      </div>

      <!-- Password -->
      <div class="mb-3">
        <label for="password" class="form-label">Password</label>
        <input
          type="password"
          class="form-control"
          id="password"
          formControlName="password"
          [class.is-invalid]="f['password'].touched && f['password'].invalid"
          placeholder="Enter your password"
        >
        <div class="invalid-feedback" *ngIf="f['password'].touched && f['password'].errors">
          <span *ngIf="f['password'].errors['required']">Password is required</span>
        </div>
      </div>

      <!-- Submit Button -->
      <div class="d-grid mb-3">
        <button
          type="submit"
          class="btn btn-primary btn-lg"
          [disabled]="isLoading"
        >
          <span *ngIf="isLoading" class="spinner-border spinner-border-sm me-2" role="status"></span>
          {{ isLoading ? 'Logging in...' : 'Login' }}
        </button>
      </div>

      <!-- Register Link -->
      <p class="text-center mb-0">
        Don't have an account? <a routerLink="/register" class="text-decoration-none">Register here</a>
      </p>
    </form>
  </div>
</div>
EOF

cat > src/app/features/accounts/login/login.component.scss << 'EOF'
// Login component specific styles
EOF

echo "    ✓ login.component.ts created"
echo "    ✓ login.component.html created"
echo "    ✓ login.component.scss created"

# -----------------------------------------
# Step 10: Create Profile Component
# -----------------------------------------
echo ""
echo "[Step 10] Creating Profile component..."

mkdir -p src/app/features/accounts/profile

cat > src/app/features/accounts/profile/profile.component.ts << 'EOF'
import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../../../core/auth/auth.service';
import { UserWithProfile } from '../../../models';

@Component({
  selector: 'app-profile',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.scss']
})
export class ProfileComponent implements OnInit {
  profileForm: FormGroup;
  user: UserWithProfile | null = null;
  isLoading = false;
  isEditing = false;
  isSaving = false;
  errorMessage = '';
  successMessage = '';

  constructor(
    private fb: FormBuilder,
    private authService: AuthService,
    private router: Router
  ) {
    this.profileForm = this.fb.group({
      full_name: ['', [Validators.required, Validators.maxLength(255)]],
      date_of_birth: [''],
      gender: [''],
      address_line1: ['', [Validators.maxLength(255)]],
      address_line2: ['', [Validators.maxLength(255)]],
      city: ['', [Validators.maxLength(100)]],
      state: ['', [Validators.maxLength(100)]],
      pincode: ['', [Validators.pattern('^[0-9]{6}$')]]
    });
  }

  ngOnInit(): void {
    this.loadProfile();
  }

  loadProfile(): void {
    this.isLoading = true;
    this.authService.getProfile().subscribe({
      next: (user) => {
        this.user = user;
        this.populateForm(user);
        this.isLoading = false;
      },
      error: (error) => {
        this.isLoading = false;
        this.errorMessage = 'Failed to load profile';
        if (error.status === 401) {
          this.router.navigate(['/login']);
        }
      }
    });
  }

  populateForm(user: UserWithProfile): void {
    this.profileForm.patchValue({
      full_name: user.profile?.full_name || '',
      date_of_birth: user.profile?.date_of_birth || '',
      gender: user.profile?.gender || '',
      address_line1: user.profile?.address_line1 || '',
      address_line2: user.profile?.address_line2 || '',
      city: user.profile?.city || '',
      state: user.profile?.state || '',
      pincode: user.profile?.pincode || ''
    });
  }

  toggleEdit(): void {
    this.isEditing = !this.isEditing;
    this.errorMessage = '';
    this.successMessage = '';
    
    if (!this.isEditing && this.user) {
      this.populateForm(this.user);
    }
  }

  onSubmit(): void {
    if (this.profileForm.invalid) {
      this.profileForm.markAllAsTouched();
      return;
    }

    this.isSaving = true;
    this.errorMessage = '';
    this.successMessage = '';

    this.authService.updateProfile(this.profileForm.value).subscribe({
      next: (user) => {
        this.user = user;
        this.isSaving = false;
        this.isEditing = false;
        this.successMessage = 'Profile updated successfully';
      },
      error: (error) => {
        this.isSaving = false;
        this.errorMessage = error.error?.error || 'Failed to update profile';
      }
    });
  }

  logout(): void {
    this.authService.logout().subscribe({
      next: () => {
        this.router.navigate(['/login']);
      },
      error: () => {
        localStorage.removeItem('access_token');
        localStorage.removeItem('refresh_token');
        this.router.navigate(['/login']);
      }
    });
  }

  get f() {
    return this.profileForm.controls;
  }
}
EOF

cat > src/app/features/accounts/profile/profile.component.html << 'EOF'
<div class="container">
  <div class="form-container" style="max-width: 600px;">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2 class="mb-0">My Profile</h2>
      <button class="btn btn-outline-danger btn-sm" (click)="logout()">
        Logout
      </button>
    </div>

    <!-- Loading -->
    <div *ngIf="isLoading" class="text-center py-5">
      <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">Loading...</span>
      </div>
      <p class="mt-2 text-muted">Loading profile...</p>
    </div>

    <!-- Profile Content -->
    <div *ngIf="!isLoading">
      <!-- Success Message -->
      <div *ngIf="successMessage" class="alert alert-success" role="alert">
        {{ successMessage }}
      </div>

      <!-- Error Message -->
      <div *ngIf="errorMessage" class="alert alert-danger" role="alert">
        {{ errorMessage }}
      </div>

      <!-- Account Info (Read-only) -->
      <div class="card mb-4">
        <div class="card-header bg-light">
          <strong>Account Information</strong>
        </div>
        <div class="card-body">
          <div class="row">
            <div class="col-md-6 mb-2">
              <small class="text-muted">Email</small>
              <p class="mb-0">{{ user?.email }}</p>
            </div>
            <div class="col-md-6 mb-2">
              <small class="text-muted">Mobile</small>
              <p class="mb-0">{{ user?.mobile }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Profile Form -->
      <div class="card">
        <div class="card-header bg-light d-flex justify-content-between align-items-center">
          <strong>Personal Information</strong>
          <button
            *ngIf="!isEditing"
            class="btn btn-primary btn-sm"
            (click)="toggleEdit()"
          >
            Edit
          </button>
        </div>
        <div class="card-body">
          <form [formGroup]="profileForm" (ngSubmit)="onSubmit()">
            <!-- Full Name -->
            <div class="mb-3">
              <label for="full_name" class="form-label">Full Name</label>
              <input
                type="text"
                class="form-control"
                id="full_name"
                formControlName="full_name"
                [readonly]="!isEditing"
                [class.is-invalid]="isEditing && f['full_name'].touched && f['full_name'].invalid"
              >
              <div class="invalid-feedback" *ngIf="f['full_name'].errors">
                <span *ngIf="f['full_name'].errors['required']">Full name is required</span>
              </div>
            </div>

            <div class="row">
              <!-- Date of Birth -->
              <div class="col-md-6 mb-3">
                <label for="date_of_birth" class="form-label">Date of Birth</label>
                <input
                  type="date"
                  class="form-control"
                  id="date_of_birth"
                  formControlName="date_of_birth"
                  [readonly]="!isEditing"
                >
              </div>

              <!-- Gender -->
              <div class="col-md-6 mb-3">
                <label for="gender" class="form-label">Gender</label>
                <select
                  class="form-select"
                  id="gender"
                  formControlName="gender"
                  [attr.disabled]="!isEditing ? true : null"
                >
                  <option value="">Select Gender</option>
                  <option value="Male">Male</option>
                  <option value="Female">Female</option>
                  <option value="Other">Other</option>
                </select>
              </div>
            </div>

            <!-- Address Line 1 -->
            <div class="mb-3">
              <label for="address_line1" class="form-label">Address Line 1</label>
              <input
                type="text"
                class="form-control"
                id="address_line1"
                formControlName="address_line1"
                [readonly]="!isEditing"
                placeholder="Street address"
              >
            </div>

            <!-- Address Line 2 -->
            <div class="mb-3">
              <label for="address_line2" class="form-label">Address Line 2</label>
              <input
                type="text"
                class="form-control"
                id="address_line2"
                formControlName="address_line2"
                [readonly]="!isEditing"
                placeholder="Apartment, floor, etc."
              >
            </div>

            <div class="row">
              <!-- City -->
              <div class="col-md-4 mb-3">
                <label for="city" class="form-label">City</label>
                <input
                  type="text"
                  class="form-control"
                  id="city"
                  formControlName="city"
                  [readonly]="!isEditing"
                >
              </div>

              <!-- State -->
              <div class="col-md-4 mb-3">
                <label for="state" class="form-label">State</label>
                <input
                  type="text"
                  class="form-control"
                  id="state"
                  formControlName="state"
                  [readonly]="!isEditing"
                >
              </div>

              <!-- Pincode -->
              <div class="col-md-4 mb-3">
                <label for="pincode" class="form-label">Pincode</label>
                <input
                  type="text"
                  class="form-control"
                  id="pincode"
                  formControlName="pincode"
                  [readonly]="!isEditing"
                  [class.is-invalid]="isEditing && f['pincode'].touched && f['pincode'].invalid"
                  placeholder="6 digits"
                >
                <div class="invalid-feedback" *ngIf="f['pincode'].errors">
                  <span *ngIf="f['pincode'].errors['pattern']">Pincode must be 6 digits</span>
                </div>
              </div>
            </div>

            <!-- Action Buttons -->
            <div *ngIf="isEditing" class="d-flex gap-2">
              <button
                type="submit"
                class="btn btn-primary"
                [disabled]="isSaving"
              >
                <span *ngIf="isSaving" class="spinner-border spinner-border-sm me-2" role="status"></span>
                {{ isSaving ? 'Saving...' : 'Save Changes' }}
              </button>
              <button
                type="button"
                class="btn btn-outline-secondary"
                (click)="toggleEdit()"
                [disabled]="isSaving"
              >
                Cancel
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
EOF

cat > src/app/features/accounts/profile/profile.component.scss << 'EOF'
// Profile component specific styles
.card {
  border: 1px solid #dee2e6;
  
  .card-header {
    font-size: 0.9rem;
  }
}

input[readonly], select[disabled] {
  background-color: #f8f9fa;
  cursor: default;
}
EOF

echo "    ✓ profile.component.ts created"
echo "    ✓ profile.component.html created"
echo "    ✓ profile.component.scss created"

# -----------------------------------------
# Step 11: Update App Routes
# -----------------------------------------
echo ""
echo "[Step 11] Creating app routes..."

cat > src/app/app.routes.ts << 'EOF'
import { Routes } from '@angular/router';
import { AuthGuard } from './core/guards/auth.guard';
import { GuestGuard } from './core/guards/guest.guard';

export const routes: Routes = [
  {
    path: '',
    redirectTo: '/login',
    pathMatch: 'full'
  },
  {
    path: 'register',
    loadComponent: () => import('./features/accounts/register/register.component')
      .then(m => m.RegisterComponent),
    canActivate: [GuestGuard]
  },
  {
    path: 'login',
    loadComponent: () => import('./features/accounts/login/login.component')
      .then(m => m.LoginComponent),
    canActivate: [GuestGuard]
  },
  {
    path: 'profile',
    loadComponent: () => import('./features/accounts/profile/profile.component')
      .then(m => m.ProfileComponent),
    canActivate: [AuthGuard]
  },
  {
    path: '**',
    redirectTo: '/login'
  }
];
EOF

echo "    ✓ app.routes.ts created"

# -----------------------------------------
# Step 12: Update App Config
# -----------------------------------------
echo ""
echo "[Step 12] Updating app config..."

cat > src/app/app.config.ts << 'EOF'
import { ApplicationConfig } from '@angular/core';
import { provideRouter } from '@angular/router';
import { provideHttpClient, withInterceptors, HTTP_INTERCEPTORS } from '@angular/common/http';
import { routes } from './app.routes';
import { AuthInterceptor } from './core/interceptors/auth.interceptor';

export const appConfig: ApplicationConfig = {
  providers: [
    provideRouter(routes),
    provideHttpClient(),
    {
      provide: HTTP_INTERCEPTORS,
      useClass: AuthInterceptor,
      multi: true
    }
  ]
};
EOF

echo "    ✓ app.config.ts created"

# -----------------------------------------
# Step 13: Update App Component
# -----------------------------------------
echo ""
echo "[Step 13] Updating app component..."

cat > src/app/app.component.ts << 'EOF'
import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, RouterOutlet],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  title = 'Your Health Plans';
}
EOF

cat > src/app/app.component.html << 'EOF'
<!-- Navigation Header -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container">
    <a class="navbar-brand" href="#">
      <strong>Your Health Plans</strong>
    </a>
  </div>
</nav>

<!-- Main Content -->
<main class="py-4">
  <router-outlet></router-outlet>
</main>

<!-- Footer -->
<footer class="bg-light py-3 mt-auto">
  <div class="container text-center text-muted">
    <small>&copy; 2026 YourHealthFirst Insurance Ltd. All rights reserved.</small>
  </div>
</footer>
EOF

cat > src/app/app.component.scss << 'EOF'
// App component styles
:host {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

main {
  flex: 1;
}
EOF

echo "    ✓ app.component.ts updated"
echo "    ✓ app.component.html updated"
echo "    ✓ app.component.scss updated"

# -----------------------------------------
# Summary
# -----------------------------------------
echo ""
echo "=========================================="
echo "Accounts Feature Setup Complete!"
echo "=========================================="
echo ""
echo "Created Files:"
echo ""
echo "Models:"
echo "  ✓ src/app/models/user.model.ts"
echo "  ✓ src/app/models/auth.model.ts"
echo "  ✓ src/app/models/index.ts"
echo ""
echo "Core:"
echo "  ✓ src/app/core/auth/auth.service.ts"
echo "  ✓ src/app/core/guards/auth.guard.ts"
echo "  ✓ src/app/core/guards/guest.guard.ts"
echo "  ✓ src/app/core/interceptors/auth.interceptor.ts"
echo ""
echo "Components:"
echo "  ✓ src/app/features/accounts/register/*"
echo "  ✓ src/app/features/accounts/login/*"
echo "  ✓ src/app/features/accounts/profile/*"
echo ""
echo "App Configuration:"
echo "  ✓ src/app/app.routes.ts"
echo "  ✓ src/app/app.config.ts"
echo "  ✓ src/app/app.component.*"
echo ""
echo "Routes Available:"
echo "  /register  - Registration page"
echo "  /login     - Login page"
echo "  /profile   - Profile page (requires login)"
echo ""
echo "Next Steps:"
echo "  1. Run: cd front_end_code/healthcare_plans_ui"
echo "  2. Run: ng serve"
echo "  3. Open: http://localhost:4200"
echo ""
echo "Note: APIs will return errors until Django backend is ready."
echo ""
