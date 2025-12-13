# Deploying to Vercel - Step by Step Guide

This guide will help you deploy the AST website to Vercel.

## Prerequisites

- A Vercel account (Sign up at https://vercel.com)
- Your GitHub repository connected to Vercel
- API keys ready (Gemini, OpenWeather, OpenAI)

---

## Step 1: Install Vercel CLI (Optional)

If you want to deploy from command line:

```bash
npm install -g vercel
```

---

## Step 2: Deploy via Vercel Dashboard (Recommended)

### ⚠️ Important: Project Naming

Vercel requires **lowercase** project names. When configuring your project:
- ✅ Use: `agro-smart-technology-ast`
- ❌ Don't use: `Agro-Smart-Technology-AST-` (has uppercase and trailing dash)

### 2.1 Connect GitHub Repository

1. Go to https://vercel.com/dashboard
2. Click **"Add New Project"**
3. Click **"Import Git Repository"**
4. Select your GitHub repository: `SyedShahHussain1214/Agro-Smart-Technology-AST-`
5. Click **"Import"**

### 2.2 Configure Project Settings

When configuring the project:

**Framework Preset:** Create React App

**Root Directory:** `ast-website`

**Build Command:** `npm run build` (auto-detected)

**Output Directory:** `build` (auto-detected)

**Install Command:** `npm install` (auto-detected)

### 2.3 Add Environment Variables

In the project settings, add the following environment variables:

| Name | Value |
|------|-------|
| `REACT_APP_GEMINI_API_KEY` | Your Gemini API key |
| `REACT_APP_OPENWEATHER_API_KEY` | Your OpenWeather API key |
| `REACT_APP_OPENAI_API_KEY` | Your OpenAI API key |

**Steps:**
1. Go to **Settings** → **Environment Variables**
2. Click **"Add"** for each variable
3. Enter the name and value
4. Select **All** environments (Production, Preview, Development)
5. Click **"Save"**

### 2.4 Deploy

1. Click **"Deploy"**
2. Wait for the build to complete (2-3 minutes)
3. Your site will be live at: `https://your-project-name.vercel.app`

---

## Step 3: Deploy via Command Line (Alternative)

If you prefer using the CLI:

### 3.1 Login to Vercel

```bash
vercel login
```

### 3.2 Navigate to Website Directory

```bash
cd ast-website
```

### 3.3 Deploy

```bash
vercel
```

Follow the prompts:
- **Set up and deploy:** Yes
- **Which scope:** Your account
- **Link to existing project:** No
- **Project name:** `agro-smart-technology-ast` (lowercase, no trailing dash)
- **Directory:** `./` (current directory)
- **Override settings:** No

### 3.4 Add Environment Variables via CLI

```bash
vercel env add REACT_APP_GEMINI_API_KEY production
vercel env add REACT_APP_OPENWEATHER_API_KEY production
vercel env add REACT_APP_OPENAI_API_KEY production
```

Then paste your API keys when prompted.

### 3.5 Deploy to Production

```bash
vercel --prod
```

---

## Step 4: Automatic Deployments

Once connected, Vercel will automatically deploy:

✅ **Production:** Every push to `main` branch
✅ **Preview:** Every pull request
✅ **Instant rollbacks:** Revert to any previous deployment

---

## Step 5: Custom Domain (Optional)

### Add Your Own Domain

1. Go to **Settings** → **Domains**
2. Click **"Add"**
3. Enter your domain (e.g., `agrosmarttech.com`)
4. Follow DNS configuration instructions
5. Wait for SSL certificate to be issued (automatic)

---

## Step 6: Verify Deployment

After deployment, test these features:

1. ✅ Voice Q&A works
2. ✅ Disease Detection uploads images
3. ✅ Weather shows correct data
4. ✅ Mandi rates load
5. ✅ All API calls work

---

## Troubleshooting

### Build Fails

**Error:** `CI=true npm run build` fails

**Solution:** Check build logs in Vercel dashboard. Common issues:
- Missing dependencies: Run `npm install` locally first
- ESLint errors: Fix or add to `.eslintignore`
- TypeScript errors: Fix type issues

### APIs Not Working

**Error:** 401 Unauthorized or API key missing

**Solution:**
1. Verify environment variables are set in Vercel dashboard
2. Make sure variable names match exactly: `REACT_APP_GEMINI_API_KEY`
3. Redeploy after adding environment variables

### Blank Page After Deploy

**Error:** White screen or blank page

**Solution:**
1. Check browser console for errors
2. Verify `vercel.json` routing is correct
3. Make sure `build/` directory is generated correctly
4. Check that `public/index.html` exists

### Models Not Loading

**Error:** TensorFlow.js models fail to load

**Solution:**
1. Verify models are in `public/models/` directory
2. Check file sizes (Vercel has 100MB file limit)
3. Consider hosting large models on external CDN

---

## Performance Optimization

### Enable Caching

Vercel automatically caches static assets. The `vercel.json` config already sets optimal cache headers.

### Enable Compression

Vercel automatically compresses responses with gzip/brotli.

### Optimize Images

Use Vercel's Image Optimization:

```javascript
import Image from 'next/image'; // If using Next.js
// Or use responsive images with srcset
```

---

## Monitoring & Analytics

### Vercel Analytics

Enable in **Settings** → **Analytics**:
- Page views
- Unique visitors
- Top pages
- Performance metrics

### Error Tracking

Consider adding:
- Sentry for error tracking
- LogRocket for session replay
- Google Analytics for user analytics

---

## Cost & Limits

### Free Tier Includes:
- ✅ Unlimited deployments
- ✅ 100 GB bandwidth/month
- ✅ Automatic HTTPS
- ✅ Automatic previews for PRs
- ✅ Custom domains

### Limitations:
- ⚠️ 100 MB max file size
- ⚠️ 50 MB max serverless function size
- ⚠️ 10 second serverless timeout

---

## Security Best Practices

### ✅ DO:
- Keep API keys in Vercel environment variables
- Enable automatic security headers
- Use HTTPS (enabled by default)
- Review deployment logs regularly

### ❌ DON'T:
- Commit `.env` files
- Expose API keys in client code
- Use same API keys for dev and production
- Share deployment URLs publicly during testing

---

## Continuous Deployment Workflow

1. **Developer pushes to GitHub**
   ↓
2. **Vercel detects push**
   ↓
3. **Automatic build starts**
   ↓
4. **Run tests (if configured)**
   ↓
5. **Deploy to preview URL**
   ↓
6. **Merge to main → Deploy to production**

---

## Team Collaboration

### Share Access

1. Go to **Settings** → **Members**
2. Invite team members by email
3. Set role: **Developer** or **Viewer**

### Deployment Notifications

Enable in **Settings** → **Notifications**:
- Slack notifications
- Email notifications
- Discord webhooks

---

## Next Steps After Deployment

1. ✅ Test all features on live site
2. ✅ Set up custom domain
3. ✅ Enable analytics
4. ✅ Configure alerts for downtime
5. ✅ Share production URL with team
6. ✅ Set up staging environment (separate Vercel project)

---

## Getting Help

- **Vercel Docs:** https://vercel.com/docs
- **Support:** https://vercel.com/support
- **Community:** https://github.com/vercel/vercel/discussions

---

## Your Deployment URLs

After deploying, you'll get:

- **Production:** `https://agro-smart-technology-ast.vercel.app`
- **Preview:** `https://agro-smart-technology-ast-git-branch.vercel.app` (for each branch)
- **Custom Domain:** `https://yourdomain.com` (if configured)

Share these URLs with your team and users! 🚀
