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
        <section class="hero-section">
          <div class="hero-copy">
            <p class="hero-eyebrow">AI Neo-Bank • Iceland</p>
            <h2>Liquidity, wealth &amp; family goals in one glass dashboard.</h2>
            <p class="hero-body">Realtime ISK insights, neon glass UI, and an assistant that keeps savings, transfers, and dreams aligned.</p>
            <div class="hero-actions">
              <button class="hero-primary" (click)="openDemo(projects[0])">Launch Neo Bank</button>
              <button class="hero-ghost" (click)="openNeoBank()">Open in new tab</button>
            </div>
          </div>
          <div class="hero-orb"></div>
        </section>

        <section class="memory-section">
          <div class="memory-card">
            <div class="memory-photo" [style.backgroundImage]="'url(' + familyCard + ')'"></div>
            <div class="memory-copy">
              <p class="memory-eyebrow">Personal AI snapshot</p>
              <h3>Plans built for us</h3>
              <p>This prototype keeps our Icelandic adventures funded: fireworks nights, matching snowsuits, and future cabin savings. Tap the demo to see how the assistant turns memories into financial sprints.</p>
            </div>
          </div>
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
          <div class="flutter-demo-shell">
            <button class="close-demo" (click)="closeFlutterDemo()">✕</button>
            <button class="fullscreen-btn" (click)="openFullScreen()">⤢ Fullscreen</button>
            <div class="iphone-frame">
              <iframe 
                [src]="flutterDemoUrl" 
                frameborder="0"
                class="flutter-iframe"
                allow="fullscreen"
              ></iframe>
            </div>
          </div>
        </section>
      </main>
    </div>
  `,
  styles: [`
    .dashboard-container {
      min-height: 100vh;
      background: radial-gradient(circle at top, #1f0c24, #050505);
      color: #f4f4f8;
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
      padding: 40px 20px 80px;
    }

    .hero-section {
      display: flex;
      gap: 32px;
      align-items: center;
      padding: 48px;
      border-radius: 32px;
      background: rgba(17, 17, 17, 0.55);
      border: 1px solid rgba(255, 255, 255, 0.05);
      box-shadow: 0 35px 80px rgba(0, 0, 0, 0.45);
      margin-bottom: 32px;
      overflow: hidden;
      position: relative;
    }

    .hero-copy h2 {
      font-size: clamp(2.4rem, 4vw, 3.5rem);
      margin: 12px 0;
      color: #ffffff;
    }

    .hero-eyebrow {
      text-transform: uppercase;
      letter-spacing: 3px;
      font-size: 0.85rem;
      color: #d946ef;
    }

    .hero-body {
      color: rgba(244, 244, 248, 0.8);
      max-width: 560px;
      font-size: 1.05rem;
    }

    .hero-actions {
      display: flex;
      flex-wrap: wrap;
      gap: 12px;
      margin-top: 24px;
    }

    .hero-primary, .hero-ghost {
      padding: 12px 28px;
      border-radius: 999px;
      border: none;
      cursor: pointer;
      font-weight: 600;
      transition: transform 0.2s ease, box-shadow 0.2s ease;
    }

    .hero-primary {
      background: linear-gradient(120deg, #6366f1, #d946ef);
      color: white;
      box-shadow: 0 10px 30px rgba(99,102,241,0.45);
    }

    .hero-ghost {
      background: rgba(255, 255, 255, 0.1);
      color: #f4f4f8;
      border: 1px solid rgba(255,255,255,0.2);
      backdrop-filter: blur(6px);
    }

    .hero-primary:hover, .hero-ghost:hover {
      transform: translateY(-2px);
    }

    .hero-orb {
      width: 260px;
      height: 260px;
      border-radius: 50%;
      background: radial-gradient(circle, rgba(99,102,241,0.8), rgba(13,13,13,0));
      position: absolute;
      right: -60px;
      top: -40px;
      filter: blur(0px);
      opacity: 0.7;
    }

    .memory-section {
      margin: 40px 0 60px;
    }

    .memory-card {
      display: grid;
      grid-template-columns: minmax(240px, 320px) 1fr;
      gap: 32px;
      padding: 28px;
      border-radius: 28px;
      background: rgba(255, 255, 255, 0.03);
      border: 1px solid rgba(255, 255, 255, 0.06);
      box-shadow: 0 25px 70px rgba(0, 0, 0, 0.35);
    }

    .memory-photo {
      border-radius: 24px;
      background-size: cover;
      background-position: center;
      min-height: 220px;
    }

    .memory-eyebrow {
      text-transform: uppercase;
      letter-spacing: 2px;
      font-size: 0.75rem;
      color: #a5b4fc;
    }

    .memory-copy h3 {
      font-size: 1.8rem;
      margin: 10px 0;
      color: white;
    }

    .memory-copy p {
      color: rgba(244, 244, 248, 0.75);
      line-height: 1.6;
    }

    .section-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 30px;
      flex-wrap: wrap;
      gap: 20px;
      color: #f6f7ff;
    }

    .section-header h3 {
      font-size: 1.5rem;
      color: #f6f7ff;
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
      background: rgba(255, 255, 255, 0.03);
      border: 1px solid rgba(255, 255, 255, 0.05);
      border-radius: 20px;
      box-shadow: 0 18px 45px rgba(0, 0, 0, 0.45);
      overflow: hidden;
      transition: all 0.3s ease;
    }

    .project-card:hover {
      transform: translateY(-4px);
      box-shadow: 0 25px 65px rgba(0, 0, 0, 0.55);
    }

    .project-image {
      height: 220px;
      background: linear-gradient(135deg, #351463, #8f2de2);
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
      background: rgba(255, 255, 255, 0.16);
      padding: 5px 12px;
      border-radius: 20px;
      font-size: 0.8rem;
      font-weight: 600;
      color: #fff;
      backdrop-filter: blur(6px);
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
      background: rgba(0,0,0,0.3);
      color: white;
    }

    .project-content {
      padding: 25px;
    }

    .project-content h4 {
      font-size: 1.3rem;
      font-weight: 600;
      color: #f4f4f8;
      margin: 0 0 12px;
    }

    .project-content p {
      color: rgba(244, 244, 248, 0.7);
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
      background: rgba(255, 255, 255, 0.08);
      color: #d5d7ff;
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
      padding: 12px 16px;
      border-radius: 999px;
      border: none;
      cursor: pointer;
      font-weight: 600;
      transition: all 0.2s ease;
      flex: 1;
    }

    .demo-btn {
      background: linear-gradient(120deg, #5c6ac4, #b44cf2);
      color: white;
      box-shadow: 0 12px 30px rgba(91, 103, 196, 0.4);
    }

    .demo-btn:hover {
      transform: translateY(-2px);
    }

    .details-btn {
      background: rgba(255, 255, 255, 0.08);
      color: rgba(244,244,248,0.8);
      border: 1px solid rgba(255,255,255,0.1);
    }

    .details-btn:hover {
      transform: translateY(-2px);
    }

    .flutter-demo-section {
      margin-top: 40px;
      display: flex;
      justify-content: center;
    }

    .flutter-demo-shell {
      position: relative;
      padding: 32px 24px 48px;
      border-radius: 24px;
      background: radial-gradient(circle at top, rgba(99,102,241,0.2), rgba(5,5,5,0.95));
      box-shadow: 0 25px 60px rgba(13, 13, 13, 0.45);
      width: 100%;
      display: flex;
      justify-content: center;
    }

    .close-demo,
    .fullscreen-btn {
      position: absolute;
      top: 16px;
      background: rgba(255, 255, 255, 0.15);
      border: none;
      color: white;
      padding: 8px 12px;
      border-radius: 999px;
      cursor: pointer;
      font-size: 0.85rem;
      backdrop-filter: blur(6px);
      transition: background 0.2s ease, transform 0.2s ease;
    }

    .close-demo {
      right: 16px;
    }

    .fullscreen-btn {
      right: 80px;
    }

    .close-demo:hover,
    .fullscreen-btn:hover {
      background: rgba(255, 255, 255, 0.3);
      transform: translateY(-1px);
    }

    .iphone-frame {
      width: min(430px, 100%);
      aspect-ratio: 430 / 932;
      border-radius: 28px;
      border: 12px solid rgba(255, 255, 255, 0.08);
      background: #050505;
      box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.08);
      overflow: hidden;
      position: relative;
    }

    .flutter-iframe {
      width: 100%;
      height: 100%;
      border: none;
      background: #050505;
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
  private readonly flutterDemoSrc = '/assets/flutter-demo/index.html';
  familyCard: string = 'assets/family-moment.jpg';

  // Featured projects including the new Neo Bank
  projects: Project[] = [
    {
      id: 1,
      title: 'Neo Bank - Iceland',
      description: 'AI-powered banking app with glassmorphic UI. Features personal/family wealth management, interactive transfer system, donut charts, loyalty rewards, and real-time ISK liquidity tracking.',
      type: 'trading-app',
      status: 'demo-ready',
      technologies: ['Flutter', 'Dart', 'Glass UI', 'Neon UX', 'AI Assistant'],
      demoUrl: 'neo-bank-live'
    },
    {
      id: 2,
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
    if (project.demoUrl === 'neo-bank-live') {
      // Open Neo Bank app in new tab with full URL
      window.open('https://ebhemh.com/neo-bank/', '_blank');
    } else if (project.demoUrl === 'flutter-trading-demo') {
      this.showFlutterDemo = true;
      this.flutterDemoUrl = this.sanitizer.bypassSecurityTrustResourceUrl(this.flutterDemoSrc);
    }
  }

  openFullScreen() {
    window.open(this.flutterDemoSrc, '_blank');
  }

  openNeoBank() {
    window.open('https://ebhemh.com/neo-bank/', '_blank');
  }

  closeFlutterDemo() {
    this.showFlutterDemo = false;
    this.flutterDemoUrl = null;
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