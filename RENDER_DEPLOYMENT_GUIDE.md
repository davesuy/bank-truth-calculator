# 🚀 Deploy Bank Truth Calculator to Render

## Complete Deployment Guide

This guide will help you deploy your Bank Truth Calculator Laravel app to Render.com so your client can test it via a public URL.

---

## Prerequisites

1. ✅ GitHub account (free)
2. ✅ Render account (free tier available) - Sign up at https://render.com
3. ✅ Your Laravel app is ready (already done!)

---

## Step 1: Prepare Your Repository

### 1.1 Initialize Git (if not already done)

```bash
cd /Users/davesuy/website-projects/bank-truth-calculator
git init
```

### 1.2 Add All Files to Git

```bash
git add .
git commit -m "Initial commit - Bank Truth Calculator ready for deployment"
```

### 1.3 Create GitHub Repository

1. Go to https://github.com/new
2. Create a new repository named `bank-truth-calculator`
3. **DO NOT** initialize with README, .gitignore, or license (we already have these)
4. Click "Create repository"

### 1.4 Push to GitHub

```bash
# Replace YOUR_USERNAME with your GitHub username
git remote add origin https://github.com/YOUR_USERNAME/bank-truth-calculator.git
git branch -M main
git push -u origin main
```

---

## Step 2: Deploy to Render

### 2.1 Sign Up/Login to Render

1. Go to https://render.com
2. Sign up or login (you can use your GitHub account)

### 2.2 Create New Web Service

1. Click **"New +"** button in the top right
2. Select **"Web Service"**
3. Connect your GitHub account if not already connected
4. Select your `bank-truth-calculator` repository

### 2.3 Configure Your Service

**Basic Settings:**
- **Name:** `bank-truth-calculator` (or your preferred name)
- **Region:** Choose closest to your users
- **Branch:** `main`
- **Root Directory:** Leave blank
- **Environment:** `PHP`
- **Build Command:**
  ```bash
  ./build.sh
  ```
- **Start Command:**
  ```bash
  php artisan serve --host=0.0.0.0 --port=$PORT
  ```

### 2.4 Configure Environment Variables

Click **"Advanced"** and add these environment variables:

| Key | Value |
|-----|-------|
| `APP_NAME` | `Bank Truth Calculator` |
| `APP_ENV` | `production` |
| `APP_KEY` | Click "Generate" or run `php artisan key:generate --show` locally and paste |
| `APP_DEBUG` | `false` |
| `APP_URL` | `https://your-app-name.onrender.com` (will be shown after creation) |
| `LOG_CHANNEL` | `stderr` |
| `DB_CONNECTION` | `sqlite` |
| `DB_DATABASE` | `/opt/render/project/src/database/database.sqlite` |
| `SESSION_DRIVER` | `file` |
| `SESSION_LIFETIME` | `120` |
| `CACHE_DRIVER` | `file` |
| `QUEUE_CONNECTION` | `sync` |

**Important:** For `APP_KEY`, run this command locally:
```bash
cd /Users/davesuy/website-projects/bank-truth-calculator
php artisan key:generate --show
```
Copy the output (should look like: `base64:xxxxx...`) and paste it as the `APP_KEY` value.

### 2.5 Create the Service

1. Click **"Create Web Service"**
2. Wait for the build to complete (5-10 minutes)
3. Your app will be live at: `https://your-app-name.onrender.com`

---

## Step 3: Post-Deployment

### 3.1 Fix Storage Permissions (if needed)

If you encounter permission issues, add this to your `build.sh`:

```bash
# Create storage directories
mkdir -p storage/framework/{sessions,views,cache}
mkdir -p storage/logs
chmod -R 775 storage
chmod -R 775 bootstrap/cache
```

### 3.2 Verify Deployment

Visit your app URL and verify:
- ✅ Calculator loads
- ✅ Banks are displayed (4 sponsored + 5 low-rate)
- ✅ You can select banks
- ✅ Calculator computes correctly
- ✅ Monthly contribution field works

---

## Alternative: Quick Deploy Method

If you prefer a simpler approach without `render.yaml`:

### Option A: One-Click Deploy Button

Add this to your README.md:

```markdown
[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy)
```

### Option B: Manual Configuration

1. Go to Render Dashboard
2. New > Web Service
3. Connect GitHub repo
4. Use these settings:
   - **Build Command:** `composer install --no-dev && npm install && npm run build && php artisan config:cache && php artisan route:cache && php artisan migrate --force && php artisan db:seed --class=BankSeeder --force`
   - **Start Command:** `php artisan serve --host=0.0.0.0 --port=$PORT`

---

## Troubleshooting

### Issue: "APP_KEY not set"
**Solution:** Generate and add APP_KEY as environment variable:
```bash
php artisan key:generate --show
```

### Issue: "No banks showing"
**Solution:** SSH into your Render instance or add to build.sh:
```bash
php artisan db:seed --class=BankSeeder --force
```

### Issue: "500 Error"
**Solution:** 
1. Check Render logs (Dashboard > Your Service > Logs)
2. Ensure `APP_DEBUG=false` in production
3. Check storage permissions

### Issue: "Assets not loading (CSS/JS)"
**Solution:**
1. Ensure `npm run build` runs in build.sh
2. Check `APP_URL` matches your Render URL
3. Verify `/public/build` is created during build

### Issue: "Database not persisting"
**Solution:** Render's free tier may reset filesystem. Consider:
1. Using Render's PostgreSQL (free tier available)
2. Keeping SQLite but understanding it resets on redeploy

---

## Using PostgreSQL Instead of SQLite (Recommended for Production)

### 1. Create PostgreSQL Database on Render

1. In Render Dashboard, click **"New +"**
2. Select **"PostgreSQL"**
3. Choose **"Free"** plan
4. Name it `bank-calculator-db`
5. Click **"Create Database"**

### 2. Update Environment Variables

Replace SQLite variables with PostgreSQL:

| Key | Value |
|-----|-------|
| `DB_CONNECTION` | `pgsql` |
| `DB_HOST` | (Copy from Render PostgreSQL "Internal Database URL") |
| `DB_PORT` | `5432` |
| `DB_DATABASE` | (Database name from Render) |
| `DB_USERNAME` | (Username from Render) |
| `DB_PASSWORD` | (Password from Render) |

### 3. Update build.sh

```bash
# Use PostgreSQL migrations
php artisan migrate --force
php artisan db:seed --class=BankSeeder --force
```

---

## Monitoring Your Deployment

### View Logs
1. Go to Render Dashboard
2. Click on your service
3. Click **"Logs"** tab
4. Monitor real-time logs

### View Metrics
- Click **"Metrics"** to see:
  - Request count
  - Response times
  - Memory usage

---

## Custom Domain (Optional)

### 1. Add Custom Domain
1. In service settings, go to **"Settings"**
2. Scroll to **"Custom Domain"**
3. Click **"Add Custom Domain"**
4. Enter your domain (e.g., `calculator.yourdomain.com`)

### 2. Update DNS
Add CNAME record at your domain provider:
```
Type: CNAME
Name: calculator (or @)
Value: your-app-name.onrender.com
```

### 3. Update APP_URL
Update `APP_URL` environment variable to your custom domain.

---

## Estimated Deployment Time

- Initial setup: **5 minutes**
- Build & deploy: **5-10 minutes**
- Testing: **2-3 minutes**

**Total: ~15-20 minutes** ⏱️

---

## Free Tier Limitations

Render Free Tier includes:
- ✅ 750 hours/month (enough for 1 app)
- ✅ Automatic SSL
- ✅ Auto-deploy from GitHub
- ⚠️ Spins down after 15 min inactivity (30-60s cold start)
- ⚠️ 512MB RAM
- ⚠️ Shared CPU

**Upgrade to Starter ($7/mo) for:**
- 24/7 uptime (no spin down)
- More RAM
- Better performance

---

## Quick Command Summary

```bash
# 1. Generate APP_KEY
php artisan key:generate --show

# 2. Initialize Git
git init
git add .
git commit -m "Initial commit"

# 3. Push to GitHub
git remote add origin https://github.com/YOUR_USERNAME/bank-truth-calculator.git
git branch -M main
git push -u origin main

# 4. Deploy on Render
# - Go to render.com
# - New > Web Service
# - Connect repo
# - Configure & deploy
```

---

## Testing Checklist

After deployment, test these features:

- [ ] Homepage loads (/)
- [ ] 4 sponsored banks visible
- [ ] 5 low-rate banks visible
- [ ] Can select banks (checkmark appears)
- [ ] Can enter initial deposit
- [ ] Can enter monthly contribution
- [ ] Can enter years
- [ ] "Compare Banks" button works
- [ ] Results display correctly
- [ ] Shows difference in earnings
- [ ] Mobile responsive
- [ ] API endpoints work

---

## Share With Your Client

Once deployed, share:

**URL:** `https://your-app-name.onrender.com`

**Test Instructions:**
1. Visit the URL
2. Enter deposit amount (e.g., $10,000)
3. Enter monthly contribution (e.g., $500)
4. Enter years (e.g., 5)
5. Click a green bank on the left
6. Click a red bank on the right
7. Click "Compare Banks"
8. See the amazing difference!

---

## Support & Updates

### To Update Your Deployment:
```bash
# Make changes locally
git add .
git commit -m "Update: description of changes"
git push origin main

# Render auto-deploys from main branch
```

### To Rollback:
1. Go to Render Dashboard
2. Click your service
3. Go to "Events" tab
4. Click "Rollback" on a previous deployment

---

## Cost Estimate

- **Free Plan:** $0/month
  - Perfect for testing
  - Apps sleep after inactivity
  
- **Starter Plan:** $7/month
  - Always on
  - Better for production
  - Recommended once client approves

---

## Need Help?

- **Render Docs:** https://render.com/docs
- **Laravel Deployment:** https://laravel.com/docs/deployment
- **Render Support:** support@render.com

---

## 🎉 You're Ready to Deploy!

Follow the steps above and your Bank Truth Calculator will be live and accessible to your client within 15-20 minutes!

**Good luck with the deployment!** 🚀

