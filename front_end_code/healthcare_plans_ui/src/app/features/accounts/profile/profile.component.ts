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
