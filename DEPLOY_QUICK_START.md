# 🚀 Quick Deploy to Render - Cheat Sheet

## Step 1: Prepare (2 minutes)

```bash
cd /Users/davesuy/website-projects/bank-truth-calculator
./deploy-prep.sh
```

This will:
- Initialize git
- Commit your code
- Generate APP_KEY
- Show next steps

## Step 2: GitHub (3 minutes)

1. **Create repo:** https://github.com/new
   - Name: `bank-truth-calculator`
   - Don't initialize with anything
   
2. **Push code:**
   ```bash
   git remote add origin https://github.com/YOUR_USERNAME/bank-truth-calculator.git
   git branch -M main
   git push -u origin main
   ```

## Step 3: Render (10 minutes)

### A. Create Service
1. Go to https://render.com
2. Sign up/Login (use GitHub)
3. **New +** → **Web Service**
4. Connect GitHub → Select `bank-truth-calculator`

### B. Configure
**Build Command:**
```bash
./build.sh
```

**Start Command:**
```bash
php artisan serve --host=0.0.0.0 --port=$PORT
```

### C. Environment Variables

Click **Advanced** → Add these:

```env
APP_NAME=Bank Truth Calculator
APP_ENV=production
APP_KEY=base64:YOUR_KEY_FROM_DEPLOY_PREP_SCRIPT
APP_DEBUG=false
APP_URL=https://your-service-name.onrender.com
LOG_CHANNEL=stderr
DB_CONNECTION=sqlite
DB_DATABASE=/opt/render/project/src/database/database.sqlite
SESSION_DRIVER=file
CACHE_DRIVER=file
```

### D. Deploy!
- Click **Create Web Service**
- Wait 5-10 minutes
- Get your URL: `https://your-app-name.onrender.com`

---

## Essential Environment Variables

| Variable | Value | Notes |
|----------|-------|-------|
| `APP_KEY` | `base64:xxxxx...` | Run `./deploy-prep.sh` to generate |
| `APP_ENV` | `production` | Required |
| `APP_DEBUG` | `false` | Security! |
| `APP_URL` | Your Render URL | Update after service created |
| `DB_CONNECTION` | `sqlite` | Simple option |
| `LOG_CHANNEL` | `stderr` | For Render logs |

---

## URLs After Deployment

- **Your App:** `https://your-app-name.onrender.com`
- **Render Dashboard:** `https://dashboard.render.com`
- **Logs:** Dashboard → Your Service → Logs

---

## Troubleshooting Quick Fixes

### "APP_KEY not set"
```bash
./deploy-prep.sh
# Copy the APP_KEY and add to Render environment variables
```

### "No banks showing"
Check build logs - seeder should run automatically.
If not, manually deploy trigger in Render.

### "500 Error"
Check Render logs (Dashboard → Service → Logs tab)

### "Cold start slow"
Free tier sleeps after 15 min inactivity.
Upgrade to Starter plan ($7/mo) for always-on.

---

## Update Your App

```bash
# Make changes
git add .
git commit -m "Update: description"
git push origin main

# Render auto-deploys!
```

---

## Share With Client

**URL:** `https://your-app-name.onrender.com`

**Test:**
1. Enter $10,000 initial deposit
2. Enter $500 monthly contribution  
3. Enter 5 years
4. Select Jenius Bank (left)
5. Select Chase Bank (right)
6. Click "Compare Banks"
7. See $4,500+ difference! 💰

---

## Cost

- **Free:** $0/month (sleeps after 15min inactive)
- **Starter:** $7/month (always on, better performance)

---

## Total Time: ~15 minutes ⏱️

Questions? Read: `RENDER_DEPLOYMENT_GUIDE.md`

