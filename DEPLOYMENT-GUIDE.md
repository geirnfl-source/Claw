# 🚀 Deployment Guide for EBHEMH Angular Project

This guide will help you deploy your Angular project to Vercel and connect it to your domain (ebhemh.com).

## 📋 Prerequisites

Before starting, make sure you have:
- ✅ Node.js installed (v16 or higher)
- ✅ Project files downloaded/cloned
- ✅ Vercel account created
- ✅ Domain (ebhemh.com) purchased and accessible

## 🛠️ Step 1: Build the Project

1. **Open Terminal/Command Prompt** in the project directory
2. **Install dependencies:**
   ```bash
   npm install
   ```
3. **Build for production:**
   ```bash
   npm run build
   ```
4. **Verify build success:** Check that `dist/ebhemh-angular-project/` folder was created

## 📦 Step 2: Prepare Deployment Package

1. **Navigate to build folder:**
   ```
   ebhemh-angular-project/
   └── dist/
       └── ebhemh-angular-project/  ← This is what we need
           ├── index.html
           ├── main.[hash].js
           ├── styles.[hash].css
           └── assets/
   ```

2. **Create ZIP file:**
   - Go into the `dist/ebhemh-angular-project/` folder
   - Select ALL files and folders inside
   - Right-click → "Compress" or "Send to ZIP"
   - Name it: `ebhemh-angular-build.zip`

## 🌐 Step 3: Deploy to Vercel

### Option A: Manual Upload (Recommended)

1. **Go to Vercel Dashboard:**
   - Visit [vercel.com](https://vercel.com)
   - Sign in to your account

2. **Create New Project:**
   - Click "Add New..." → "Project"
   - Choose "Browse all templates" 
   - Select "Deploy manually" or look for drag-and-drop option

3. **Upload Your Build:**
   - Drag and drop your `ebhemh-angular-build.zip` file
   - OR click "Browse Files" and select the ZIP
   - Vercel will automatically extract and deploy

4. **Wait for Deployment:**
   - Deployment usually takes 30-60 seconds
   - You'll see a progress bar and logs

5. **Get Your Temporary URL:**
   - Once deployed, you'll get a URL like: `your-project-name.vercel.app`
   - Test this URL to make sure everything works

### Option B: GitHub Integration (Advanced)

If you prefer using GitHub:
1. Push your project to a GitHub repository
2. Connect the repository to Vercel
3. Set build settings:
   - **Build Command:** `npm run build`
   - **Output Directory:** `dist/ebhemh-angular-project`

## 🔗 Step 4: Connect Custom Domain

1. **In Vercel Dashboard:**
   - Go to your project settings
   - Click "Domains" tab
   - Click "Add Domain"

2. **Add Your Domain:**
   - Enter: `ebhemh.com`
   - Also add: `www.ebhemh.com` (recommended)
   - Click "Add"

3. **Configure DNS (if not done already):**
   
   Vercel will show you DNS records to add. You need to go to Namecheap and set:

   **For ebhemh.com:**
   - Type: `A`
   - Host: `@`
   - Value: `76.76.19.19` (Vercel's IP)
   
   **For www.ebhemh.com:**
   - Type: `CNAME`
   - Host: `www`
   - Value: `cname.vercel-dns.com`

   **Alternative (easier):**
   Use Vercel nameservers:
   - `ns1.vercel-dns.com`
   - `ns2.vercel-dns.com`

4. **Wait for DNS Propagation:**
   - DNS changes take 5-48 hours to propagate
   - Usually works within 30 minutes
   - Test with: `https://ebhemh.com`

## ✅ Step 5: Verify Deployment

### Test Checklist:
- [ ] https://ebhemh.com loads the login page
- [ ] Login works with password: `ebhemh2026`
- [ ] Dashboard loads with all projects
- [ ] Flutter demo opens when clicked
- [ ] Responsive design works on mobile
- [ ] All images and styles load correctly

### If Something Doesn't Work:

**Login Issues:**
- Check browser console (F12) for errors
- Verify password in the code
- Clear browser cache

**Styling Issues:**
- Check if CSS files are loading
- Look for 404 errors in Network tab
- Verify asset paths

**Domain Issues:**
- Use DNS checker tools online
- Try accessing via www.ebhemh.com
- Check Vercel domain settings

## 🔄 Step 6: Future Updates

When you want to update the site:

1. **Make your changes** in the source code
2. **Build again:** `npm run build`
3. **Create new ZIP** from dist folder
4. **Upload to Vercel:**
   - Go to Deployments tab
   - Upload new ZIP
   - Vercel will automatically deploy

## 🚨 Troubleshooting

### Common Issues:

**1. "Page Not Found" on Direct URLs:**
- Add `vercel.json` file to project root:
```json
{
  "rewrites": [
    { "source": "/(.*)", "destination": "/index.html" }
  ]
}
```

**2. Build Fails:**
- Check Node.js version: `node --version`
- Clear npm cache: `npm cache clean --force`
- Delete node_modules and reinstall

**3. Assets Not Loading:**
- Verify all files are in the ZIP
- Check Angular build configuration
- Ensure no absolute paths in code

**4. Login Not Working:**
- Check auth.service.ts for correct password
- Verify localStorage works in browser
- Test in incognito mode

## 📞 Need Help?

1. **Check Vercel Docs:** [vercel.com/docs](https://vercel.com/docs)
2. **Check Build Logs:** In Vercel dashboard → Deployments → View Function Logs
3. **Test Locally First:** Always verify `npm start` works before deploying

## 🎯 Success Checklist

- ✅ Angular project builds without errors
- ✅ ZIP package created from dist folder
- ✅ Uploaded to Vercel successfully
- ✅ Custom domain (ebhemh.com) connected
- ✅ DNS configured correctly
- ✅ Site loads and functions properly
- ✅ Login works with correct password
- ✅ All features tested on mobile and desktop

---

**🎉 Congratulations! Your EBHEMH project is now live at https://ebhemh.com**

**Default Password:** `ebhemh2026`

Remember to change the password in the source code before your final deployment!