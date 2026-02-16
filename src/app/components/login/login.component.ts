import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [FormsModule, CommonModule],
  template: `
    <div class="login-container">
      <div class="login-card">
        <div class="logo-section">
          <h1>EBHEMH</h1>
          <p class="subtitle">Digital Project Showcase</p>
        </div>
        
        <form (ngSubmit)="login()" class="login-form">
          <div class="input-group">
            <label for="password">Enter Password</label>
            <input 
              type="password" 
              id="password"
              [(ngModel)]="password" 
              name="password"
              placeholder="••••••••"
              required
              [class.error]="errorMessage"
            >
          </div>
          
          <div class="error-message" *ngIf="errorMessage">
            {{ errorMessage }}
          </div>
          
          <button type="submit" class="login-btn" [disabled]="!password">
            Access Dashboard
          </button>
        </form>
        
        <div class="footer-info">
          <p>Secure access to digital project portfolio</p>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .login-container {
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 20px;
    }
    
    .login-card {
      background: white;
      border-radius: 20px;
      padding: 40px;
      box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
      width: 100%;
      max-width: 400px;
      text-align: center;
    }
    
    .logo-section h1 {
      font-size: 2.5rem;
      font-weight: 700;
      color: #667eea;
      margin: 0;
      letter-spacing: -1px;
    }
    
    .subtitle {
      color: #666;
      margin: 8px 0 40px;
      font-size: 0.95rem;
    }
    
    .login-form {
      margin-bottom: 30px;
    }
    
    .input-group {
      margin-bottom: 20px;
      text-align: left;
    }
    
    .input-group label {
      display: block;
      margin-bottom: 8px;
      font-weight: 500;
      color: #333;
      font-size: 0.9rem;
    }
    
    .input-group input {
      width: 100%;
      padding: 15px;
      border: 2px solid #e1e5e9;
      border-radius: 12px;
      font-size: 1rem;
      transition: all 0.3s ease;
      box-sizing: border-box;
    }
    
    .input-group input:focus {
      outline: none;
      border-color: #667eea;
      box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }
    
    .input-group input.error {
      border-color: #e74c3c;
    }
    
    .error-message {
      color: #e74c3c;
      font-size: 0.85rem;
      margin: -15px 0 20px;
      text-align: left;
    }
    
    .login-btn {
      width: 100%;
      padding: 15px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border: none;
      border-radius: 12px;
      font-size: 1rem;
      font-weight: 600;
      cursor: pointer;
      transition: transform 0.2s ease, box-shadow 0.3s ease;
    }
    
    .login-btn:hover:not(:disabled) {
      transform: translateY(-2px);
      box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
    }
    
    .login-btn:disabled {
      opacity: 0.6;
      cursor: not-allowed;
    }
    
    .footer-info {
      color: #888;
      font-size: 0.8rem;
    }
  `]
})
export class LoginComponent {
  password: string = '';
  errorMessage: string = '';

  constructor(private authService: AuthService, private router: Router) {}

  login() {
    if (this.authService.login(this.password)) {
      this.router.navigate(['/dashboard']);
    } else {
      this.errorMessage = 'Invalid password. Please try again.';
      this.password = '';
    }
  }
}