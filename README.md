# EBHEMH - Digital Project Showcase

A modern Angular application with password protection, featuring a project portfolio dashboard and interactive Flutter demos.

**Latest Update:** Configured for proper Vercel deployment with Angular build settings.

## 🚀 Features

- **Password Protected Access** - Secure login system
- **Project Portfolio Dashboard** - Showcase digital project ideas
- **Interactive Flutter Demos** - Embedded clickable prototypes
- **Responsive Design** - Works on desktop, tablet, and mobile
- **Modern UI/UX** - Clean, professional interface with smooth animations
- **Project Filtering** - Filter projects by type (Trading Apps, Web Apps, Mobile Apps, AI Projects)

## 🔐 Default Login Credentials

- **Password:** `ebhemh2026`

*You can change this password in `src/app/services/auth.service.ts`*

## 📁 Project Structure

```
ebhemh-angular-project/
├── src/
│   ├── app/
│   │   ├── components/
│   │   │   ├── login/           # Login page component
│   │   │   └── dashboard/       # Main dashboard component
│   │   ├── services/
│   │   │   ├── auth.service.ts  # Authentication logic
│   │   │   └── auth.guard.ts    # Route protection
│   │   ├── app.component.ts     # Root component
│   │   └── app.routes.ts        # Routing configuration
│   ├── assets/
│   │   └── flutter-demo/        # Flutter demo files
│   ├── styles.scss              # Global styles
│   └── index.html
├── package.json
├── angular.json
└── README.md
```

## 🛠️ Installation & Development

### Prerequisites
- Node.js (v16 or higher)
- npm or yarn
- Angular CLI (`npm install -g @angular/cli`)

### Setup
1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Start development server:**
   ```bash
   npm start
   # or
   ng serve
   ```

3. **Open in browser:**
   Navigate to `http://localhost:4200`

### Build for Production
```bash
npm run build
# or
ng build --configuration production
```

The build artifacts will be stored in the `dist/` directory.

## 🚀 Deployment to Vercel

### Option 1: GitHub Integration (Current Setup)

The project is already configured for automatic deployment:
- **Build Command:** `npm run build`
- **Output Directory:** `dist/ebhemh-angular-project`
- **Framework:** Angular (configured as Other)

### Option 2: Direct Upload

1. **Build the project:**
   ```bash
   npm run build
   ```

2. **Create deployment package:**
   - Go to `dist/ebhemh-angular-project/` folder
   - Select all files and folders inside
   - Create a ZIP file

3. **Upload to Vercel:**
   - Go to your Vercel dashboard
   - Click "Add New" → "Project" 
   - Choose "Browse all templates" → "Deploy manually"
   - Upload your ZIP file
   - Connect your custom domain (ebhemh.com)

## 🎨 Customization

### Adding New Projects
Edit the `projects` array in `src/app/components/dashboard/dashboard.component.ts`:

```typescript
{
  id: 6,
  title: 'Your New Project',
  description: 'Project description here',
  type: 'web-app', // 'trading-app' | 'web-app' | 'mobile-app' | 'ai-project'
  status: 'concept', // 'concept' | 'in-progress' | 'demo-ready' | 'completed'
  technologies: ['Angular', 'TypeScript', 'etc'],
  demoUrl: 'optional-demo-url'
}
```

### Changing Password
Update `correctPassword` in `src/app/services/auth.service.ts`:

```typescript
private readonly correctPassword = 'your-new-password';
```

### Styling
- Global styles: `src/styles.scss`
- Component styles: Within each component's `styles` array
- CSS custom properties are defined in `:root` for easy theming

### Adding Flutter Demos
1. Create new demo HTML files in `src/assets/flutter-demo/`
2. Add demo URLs to projects in the dashboard component
3. The demos will automatically load in an iframe

## 🎯 Key Components

### Login Component
- Password-based authentication
- Form validation
- Error handling
- Responsive design

### Dashboard Component
- Project showcase with filtering
- Interactive project cards
- Flutter demo integration
- Portfolio statistics

### Auth Service
- Login/logout functionality
- Session persistence
- Route protection

## 🔧 Technical Details

- **Framework:** Angular 17+ (Standalone Components)
- **Language:** TypeScript
- **Styling:** SCSS with responsive design
- **Authentication:** Client-side password protection
- **Routing:** Angular Router with guards
- **Build:** Angular CLI with production optimizations

## 📱 Responsive Design

The application is fully responsive and optimized for:
- **Desktop:** Full-featured dashboard with sidebar navigation
- **Tablet:** Adapted layout with touch-friendly interactions
- **Mobile:** Stacked layout with swipe gestures

## 🚀 Performance Features

- Lazy loading of components
- Optimized bundle size
- CSS animations with hardware acceleration
- Efficient change detection
- Production build optimizations

## 🎨 Design System

### Colors
- Primary: #667eea
- Secondary: #764ba2
- Success: #00b894
- Warning: #fdcb6e
- Error: #e74c3c

### Typography
- Font Family: Inter (Google Fonts)
- Weights: 300, 400, 500, 600, 700

### Components
- Cards with subtle shadows
- Gradient buttons
- Form inputs with focus states
- Smooth transitions and animations

## 🐛 Troubleshooting

### Common Issues

1. **Build Errors:**
   - Ensure Node.js version is 16+
   - Clear npm cache: `npm cache clean --force`
   - Delete node_modules and reinstall: `rm -rf node_modules && npm install`

2. **Deployment Issues:**
   - Check build output in `dist/ebhemh-angular-project/`
   - Ensure all assets are included
   - Verify Angular routing configuration for SPA

3. **Login Not Working:**
   - Check browser console for errors
   - Verify password in `auth.service.ts`
   - Clear localStorage: `localStorage.clear()`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes
4. Test thoroughly
5. Commit: `git commit -m 'Add feature'`
6. Push: `git push origin feature-name`
7. Create a Pull Request

## 📄 License

This project is private and proprietary to EBHEMH.

## 🆘 Support

For support or questions:
- Check this README first
- Review the code comments
- Test in development mode before deploying

---

**Built with ❤️ for EBHEMH Digital Projects**