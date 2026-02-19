import { Component, OnInit } from '@angular/core';
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { AuthService } from '../../services/auth.service';

interface Project {
  id: number;
  title: string;
  description: string;
  type: 'trading-app' | 'web-app' | 'mobile-app' | 'ai-project';
  status: 'concept' | 'in-progress' | 'demo-ready' | 'completed';
  technologies: string[];
  demoUrl?: string;
  imageUrl?: string;
}

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="dashboard-container">
      <header class="dashboard-header">
        <div class="header-content">
          <div class="logo-section">
            <h1>EBHEMH</h1>
            <span class="subtitle">Digital Project Showcase</span>
          </div>
          <button class="logout-btn" (click)="logout()">
            <span>🚪</span> Logout
          </button>
        </div>
      </header>

      <main class="dashboard-main">
        <section class="welcome-section">
          <h2>Welcome to Your Project Portfolio</h2>
          <p>Here are your digital project ideas and demos</p>
        </section>

        <section class="projects-section">
          <div class="section-header">
            <h3>🚀 Featured Projects</h3>
            <div class="project-filters">
              <button 
                class="filter-btn" 
                [class.active]="selectedFilter === 'all'"
                (click)="filterProjects('all')"
              >
                All
              </button>
              <button 
                class="filter-btn" 
                [class.active]="selectedFilter === 'trading-app'"
                (click)="filterProjects('trading-app')"
              >
                Trading Apps
              </button>
              <button 
                class="filter-btn" 
                [class.active]="selectedFilter === 'web-app'"
                (click)="filterProjects('web-app')"
              >
                Web Apps
              </button>
              <button 
                class="filter-btn" 
                [class.active]="selectedFilter === 'mobile-app'"
                (click)="filterProjects('mobile-app')"
              >
                Mobile Apps
              </button>
            </div>
          </div>

          <div class="projects-grid">
            <div class="project-card" *ngFor="let project of filteredProjects">
              <div class="project-image">
                <div class="project-type-badge">{{ getProjectTypeLabel(project.type) }}</div>
                <div class="project-status" [class]="project.status">
                  {{ getStatusLabel(project.status) }}
                </div>
              </div>
              
              <div class="project-content">
                <h4>{{ project.title }}</h4>
                <p>{{ project.description }}</p>
                
                <div class="project-technologies">
                  <span class="tech-badge" *ngFor="let tech of project.technologies">
                    {{ tech }}
                  </span>
                </div>
                
                <div class="project-actions">
                  <button 
                    class="demo-btn" 
                    *ngIf="project.demoUrl"
                    (click)="openDemo(project)"
                  >
                    🎮 View Demo
                  </button>
                  <button class="details-btn" (click)="viewDetails(project)">
                    📝 Details
                  </button>
                </div>
              </div>
            </div>
          </div>
        </section>

        <!-- Flutter Demo Section -->
        <section class="flutter-demo-section" *ngIf="showFlutterDemo">
          <div class="demo-header">
            <h3>🎯 Interactive Flutter Demo</h3>
            <button class="close-demo" (click)="closeFlutterDemo()">✕</button>
          </div>
          
          <div class="flutter-demo-container">
            <iframe 
              [src]="flutterDemoUrl" 
              frameborder="0"
              width="100%"
              height="600"
              class="flutter-iframe"
            ></iframe>
          </div>
        </section>
      </main>
    </div>
  `,
  styles: [`
    .dashboard-container {
      min-height: 100vh;
      background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
    }

    .dashboard-header {
      background: white;
      box-shadow: 0 2px 20px rgba(0, 0, 0, 0.05);
      padding: 0;
    }

    .header-content {
      max-width: 1200px;
      margin: 0 auto;
      padding: 20px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .logo-section h1 {
      font-size: 1.8rem;
      font-weight: 700;
      color: #667eea;
      margin: 0;
    }

    .subtitle {
      color: #666;
      font-size: 0.85rem;
      font-weight: 400;
    }

    .logout-btn {
      background: #f8f9fa;
      border: 1px solid #dee2e6;
      border-radius: 8px;
      padding: 10px 16px;
      cursor: pointer;
      transition: all 0.2s ease;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .logout-btn:hover {
      background: #e9ecef;
      transform: translateY(-1px);
    }

    .dashboard-main {
      max-width: 1200px;
      margin: 0 auto;
      padding: 40px 20px;
    }

    .welcome-section {
      text-align: center;
      margin-bottom: 60px;
    }

    .welcome-section h2 {
      font-size: 2.5rem;
      font-weight: 600;
      color: #2c3e50;
      margin-bottom: 16px;
    }

    .welcome-section p {
      font-size: 1.1rem;
      color: #7f8c8d;
    }

    .section-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 30px;
      flex-wrap: wrap;
      gap: 20px;
    }

    .section-header h3 {
      font-size: 1.5rem;
      color: #2c3e50;
      margin: 0;
    }

    .project-filters {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
    }

    .filter-btn {
      padding: 8px 16px;
      border: 2px solid #e9ecef;
      background: white;
      border-radius: 20px;
      cursor: pointer;
      transition: all 0.3s ease;
      font-weight: 500;
    }

    .filter-btn.active,
    .filter-btn:hover {
      background: #667eea;
      color: white;
      border-color: #667eea;
    }

    .projects-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
      gap: 30px;
      margin-bottom: 60px;
    }

    .project-card {
      background: white;
      border-radius: 16px;
      box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
      overflow: hidden;
      transition: all 0.3s ease;
    }

    .project-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
    }

    .project-image {
      height: 200px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      position: relative;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 3rem;
    }

    .project-type-badge {
      position: absolute;
      top: 15px;
      left: 15px;
      background: rgba(255, 255, 255, 0.9);
      padding: 5px 12px;
      border-radius: 20px;
      font-size: 0.8rem;
      font-weight: 600;
      color: #667eea;
    }

    .project-status {
      position: absolute;
      top: 15px;
      right: 15px;
      padding: 5px 12px;
      border-radius: 20px;
      font-size: 0.75rem;
      font-weight: 600;
      text-transform: uppercase;
    }

    .project-status.concept { background: #ffeaa7; color: #fdcb6e; }
    .project-status.in-progress { background: #74b9ff; color: white; }
    .project-status.demo-ready { background: #00b894; color: white; }
    .project-status.completed { background: #6c5ce7; color: white; }

    .project-content {
      padding: 25px;
    }

    .project-content h4 {
      font-size: 1.3rem;
      font-weight: 600;
      color: #2c3e50;
      margin: 0 0 12px;
    }

    .project-content p {
      color: #7f8c8d;
      line-height: 1.6;
      margin: 0 0 20px;
    }

    .project-technologies {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      margin-bottom: 20px;
    }

    .tech-badge {
      background: #f8f9fa;
      color: #495057;
      padding: 4px 12px;
      border-radius: 12px;
      font-size: 0.8rem;
      font-weight: 500;
    }

    .project-actions {
      display: flex;
      gap: 12px;
    }

    .demo-btn, .details-btn {
      padding: 10px 16px;
      border-radius: 8px;
      border: none;
      cursor: pointer;
      font-weight: 600;
      transition: all 0.2s ease;
      flex: 1;
    }

    .demo-btn {
      background: #667eea;
      color: white;
    }

    .demo-btn:hover {
      background: #5a67d8;
      transform: translateY(-1px);
    }

    .details-btn {
      background: #f8f9fa;
      color: #495057;
      border: 1px solid #dee2e6;
    }

    .details-btn:hover {
      background: #e9ecef;
      transform: translateY(-1px);
    }

    .flutter-demo-section {
      background: white;
      border-radius: 16px;
      box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
      margin-top: 40px;
      overflow: hidden;
    }

    .demo-header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 20px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .demo-header h3 {
      margin: 0;
      font-size: 1.3rem;
    }

    .close-demo {
      background: rgba(255, 255, 255, 0.2);
      border: none;
      color: white;
      width: 32px;
      height: 32px;
      border-radius: 50%;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.2rem;
    }

    .close-demo:hover {
      background: rgba(255, 255, 255, 0.3);
    }

    .flutter-demo-container {
      padding: 0;
    }

    .flutter-iframe {
      border: none;
      width: 100%;
      background: #f8f9fa;
    }

    @media (max-width: 768px) {
      .projects-grid {
        grid-template-columns: 1fr;
        gap: 20px;
      }
      
      .section-header {
        flex-direction: column;
        align-items: flex-start;
      }
      
      .welcome-section h2 {
        font-size: 2rem;
      }
    }
  `]
})
export class DashboardComponent implements OnInit {
  selectedFilter: string = 'all';
  showFlutterDemo: boolean = false;
  flutterDemoUrl: SafeResourceUrl | null = null;

  // Focus on a single flagship Flutter demo for now
  projects: Project[] = [
    {
      id: 1,
      title: 'Advanced Trading Platform',
      description: 'Modern trading application with real-time market data, advanced charting, and portfolio management. Features include risk assessment, automated trading strategies, and multi-asset support.',
      type: 'trading-app',
      status: 'demo-ready',
      technologies: ['Flutter', 'Dart', 'Glass UI', 'Neon UX'],
      demoUrl: 'flutter-trading-demo'
    }
  ];

  filteredProjects: Project[] = [];

  constructor(
    private authService: AuthService,
    private router: Router,
    private sanitizer: DomSanitizer
  ) {}

  ngOnInit() {
    this.filterProjects('all');
  }

  filterProjects(filter: string) {
    this.selectedFilter = filter;
    if (filter === 'all') {
      this.filteredProjects = this.projects;
    } else {
      this.filteredProjects = this.projects.filter(project => project.type === filter);
    }
  }

  getProjectTypeLabel(type: string): string {
    const labels: { [key: string]: string } = {
      'trading-app': '📈 Trading',
      'web-app': '🌐 Web App',
      'mobile-app': '📱 Mobile',
      'ai-project': '🤖 AI/ML'
    };
    return labels[type] || type;
  }

  getStatusLabel(status: string): string {
    const labels: { [key: string]: string } = {
      'concept': 'Concept',
      'in-progress': 'In Progress',
      'demo-ready': 'Demo Ready',
      'completed': 'Completed'
    };
    return labels[status] || status;
  }

  openDemo(project: Project) {
    if (project.demoUrl === 'flutter-trading-demo') {
      this.showFlutterDemo = true;
      this.flutterDemoUrl = this.sanitizer.bypassSecurityTrustResourceUrl(
        '/assets/flutter-demo/index.html'
      );
    } else if (project.demoUrl === 'flutter-mobile-demo') {
      this.showFlutterDemo = true;
      this.flutterDemoUrl = 'assets/flutter-mobile-demo/index.html'; // We'll create this
    }
  }

  closeFlutterDemo() {
    this.showFlutterDemo = false;
    this.flutterDemoUrl = '';
  }

  viewDetails(project: Project) {
    // In a real app, this would navigate to a detailed view
    alert(`Project Details for: ${project.title}\n\nDescription: ${project.description}\n\nTechnologies: ${project.technologies.join(', ')}\n\nStatus: ${this.getStatusLabel(project.status)}`);
  }

  logout() {
    this.authService.logout();
    this.router.navigate(['/login']);
  }
}