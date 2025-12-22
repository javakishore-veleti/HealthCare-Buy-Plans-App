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
