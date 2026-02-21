import { Routes } from '@angular/router';
import { LoginComponent } from './components/login/login.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { AuthGuard } from './services/auth.guard';
import { Component, OnInit } from '@angular/core';

// Simple redirect component for Neo Bank
@Component({
  template: '<div>Redirecting to Neo Bank...</div>',
  standalone: true
})
export class NeoBankRedirectComponent implements OnInit {
  ngOnInit() {
    window.location.href = 'https://ebhemh.com/neo-bank/';
  }
}

export const routes: Routes = [
  { path: '', redirectTo: '/login', pathMatch: 'full' },
  { path: 'login', component: LoginComponent },
  {
    path: 'dashboard',
    component: DashboardComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'page/dashboard',
    component: DashboardComponent,
    canActivate: [AuthGuard]
  },
  { 
    path: 'neo-bank', 
    component: NeoBankRedirectComponent,
    pathMatch: 'full' 
  },
  { path: '**', redirectTo: '/login' }
];
