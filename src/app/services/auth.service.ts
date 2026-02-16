import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private readonly correctPassword = 'ebhemh2026'; // You can change this password
  private isAuthenticated = false;

  constructor() {
    // Check if user is already logged in (from localStorage)
    this.isAuthenticated = localStorage.getItem('ebhemh_authenticated') === 'true';
  }

  login(password: string): boolean {
    if (password === this.correctPassword) {
      this.isAuthenticated = true;
      localStorage.setItem('ebhemh_authenticated', 'true');
      return true;
    }
    return false;
  }

  logout(): void {
    this.isAuthenticated = false;
    localStorage.removeItem('ebhemh_authenticated');
  }

  isLoggedIn(): boolean {
    return this.isAuthenticated;
  }

  // Method to change password (for admin use)
  changePassword(newPassword: string): void {
    // In a real app, this would be handled server-side
    console.log('Password change would be handled server-side');
  }
}