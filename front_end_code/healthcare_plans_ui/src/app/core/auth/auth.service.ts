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
