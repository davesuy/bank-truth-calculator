# 🚀 Pre-Deployment Checklist

Use this checklist before deploying to Render:

## ✅ File Verification

- [x] render.yaml created and configured
- [x] build.sh created and executable (chmod +x build.sh)
- [x] start.sh created and executable (chmod +x start.sh)
- [x] Procfile created
- [x] .env.example updated with production defaults
- [x] .renderignore created
- [x] Documentation files created

## ✅ Code Preparation

- [ ] All code changes committed
- [ ] Database migrations are working locally
- [ ] Database seeders are working (BankSeeder)
- [ ] Frontend assets build successfully (`npm run build`)
- [ ] No critical errors in application

## ✅ Git & GitHub

- [ ] Git repository initialized
- [ ] All files added to git
- [ ] Changes committed
- [ ] GitHub repository created
- [ ] Remote origin added
- [ ] Code pushed to GitHub (main branch)

## ✅ Render Setup

- [ ] Render account created (https://render.com)
- [ ] GitHub connected to Render
- [ ] New Web Service created
- [ ] Repository selected
- [ ] render.yaml detected by Render

## ✅ Environment Variables

- [ ] APP_KEY generated (`php artisan key:generate --show`)
- [ ] APP_KEY set in Render dashboard
- [ ] APP_URL set to Render URL (e.g., https://yourapp.onrender.com)

## ✅ First Deployment

- [ ] Build started successfully
- [ ] Build completed without errors
- [ ] Application started
- [ ] Can access the app URL
- [ ] Routes are working (/, /calculator)
- [ ] API endpoints working (/api/banks)
- [ ] Database has data (banks seeded)

## ✅ Post-Deployment Testing

- [ ] Homepage loads correctly
- [ ] Calculator functionality works
- [ ] Bank data is displayed
- [ ] No JavaScript errors in console
- [ ] Mobile responsive (check on phone)
- [ ] SSL certificate is active (https)

## 🔧 Optional Enhancements

- [ ] Custom domain configured
- [ ] PostgreSQL database setup (if needed)
- [ ] Email service configured
- [ ] Monitoring/logging setup
- [ ] Error tracking (Sentry, Bugsnag)

## 📝 Notes

**APP_KEY Generation:**
```bash
php artisan key:generate --show
```

**Testing Build Locally:**
```bash
chmod +x build.sh
./build.sh
```

**Check Logs on Render:**
- Go to Dashboard → Your Service → Logs
- Monitor for any errors during deployment

**Common Issues:**
1. Build fails: Check PHP version (needs 8.2+)
2. Migration errors: Check database connection
3. Assets not loading: Verify npm run build succeeded
4. 404 errors: Check routes and clear route cache

## 🎯 Success Criteria

Your deployment is successful when:
- ✅ App URL loads without errors
- ✅ Calculator page is accessible
- ✅ Bank data is visible
- ✅ No console errors
- ✅ All routes work correctly

---

**Ready to deploy?** Follow RENDER_QUICKSTART.md for step-by-step instructions!
# Quick Deploy to Render - Bank Truth Calculator

## 🚀 Quick Start (5 minutes)

### Step 1: Push to GitHub

```bash
# If you haven't initialized git yet
git init

# Add all files
git add .

# Commit
git commit -m "Add Render deployment configuration"

# Create a new repository on GitHub, then:
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git branch -M main
git push -u origin main
```

### Step 2: Deploy on Render

1. **Sign up/Login** at https://render.com
2. Click **"New +"** → **"Web Service"**
3. **Connect your GitHub repository**
4. Render will auto-detect `render.yaml` configuration
5. Click **"Apply"** or **"Create Web Service"**

### Step 3: Set Environment Variables

In the Render Dashboard, go to **Environment** and add:

```
APP_KEY=base64:YOUR_KEY_HERE
APP_URL=https://your-app-name.onrender.com
```

To generate APP_KEY locally:
```bash
php artisan key:generate --show
```

### Step 4: Deploy! 🎉

Render will automatically:
- ✅ Install dependencies
- ✅ Build frontend assets  
- ✅ Run migrations
- ✅ Seed database
- ✅ Start your app

Access your app at: `https://your-app-name.onrender.com`

---

## 📋 What's Included

The following files have been created for Render deployment:

- **render.yaml** - Render service configuration
- **build.sh** - Automated build script
- **start.sh** - Server startup script
- **Procfile** - Alternative process configuration
- **.env.example** - Environment variables template
- **RENDER_DEPLOYMENT.md** - Detailed deployment guide

---

## 🔧 Configuration Details

### Default Settings

- **Runtime**: PHP with built-in server
- **Database**: SQLite (no extra cost)
- **Plan**: Free tier
- **Build**: Automated via build.sh
- **Assets**: Compiled with Vite

### Using PostgreSQL Instead (Optional)

Edit `render.yaml` and uncomment the database section:

```yaml
databases:
  - name: bank-truth-db
    databaseName: bank_truth
    user: bank_truth_user
```

Then add these environment variables:
```
DB_CONNECTION=pgsql
DB_HOST=<from Render database>
DB_PORT=5432
DB_DATABASE=bank_truth
DB_USERNAME=<from Render database>
DB_PASSWORD=<from Render database>
```

---

## 🐛 Troubleshooting

### Build Fails
- Check build logs in Render dashboard
- Verify `composer.json` and `package.json` are valid
- Ensure PHP version matches (PHP 8.2+)

### App Won't Start
- Verify `APP_KEY` is set in environment variables
- Check that `APP_URL` matches your Render URL
- Review application logs in Render dashboard

### Database Errors
- For SQLite: Database is created automatically
- For PostgreSQL: Ensure database is created and connected
- Check migration logs in build output

### 404 Errors
- Ensure routes are defined in `routes/web.php`
- Clear route cache: Add `php artisan route:clear` to build.sh
- Check that public/index.php exists

---

## 📊 Free Tier Limitations

⚠️ **Important to Know:**

- **Spin Down**: App sleeps after 15 min of inactivity
- **Cold Start**: First request after sleep takes ~30 seconds
- **Storage**: Ephemeral - files reset on redeploy (database persists)
- **Build Time**: 500 free hours/month for builds

**Recommendation**: Upgrade to paid plan ($7/mo) for:
- ✅ No spin down
- ✅ Fast response times
- ✅ More resources
- ✅ Custom domains with SSL

---

## 🔄 Continuous Deployment

Every push to your main branch triggers automatic deployment:

```bash
git add .
git commit -m "Update feature"
git push origin main
```

Render will rebuild and redeploy automatically!

---

## 🌐 Custom Domain

1. Go to Render Dashboard → Your Service → Settings
2. Click **"Custom Domain"**
3. Add your domain (e.g., `www.yoursite.com`)
4. Update DNS records as instructed
5. SSL certificate is automatically provided!

---

## 📈 Monitoring

View in Render Dashboard:
- **Logs**: Real-time application logs
- **Metrics**: CPU, Memory, Request stats
- **Events**: Deploy history and status

---

## 🛠 Local Testing

Test the build script locally:

```bash
# Make it executable
chmod +x build.sh

# Run it
./build.sh
```

Test the app locally:
```bash
php artisan serve
```

---

## 📚 Additional Resources

- **Render Docs**: https://render.com/docs
- **Laravel Deployment**: https://laravel.com/docs/deployment
- **Render Community**: https://community.render.com

---

## 🆘 Need Help?

1. Check **RENDER_DEPLOYMENT.md** for detailed guide
2. Review Render logs in dashboard
3. Visit Render Community forums
4. Check Laravel documentation

---

## ✅ Deployment Checklist

Before deploying, ensure:

- [ ] Code is pushed to GitHub
- [ ] `render.yaml` is in repository root
- [ ] `build.sh` is executable (`chmod +x build.sh`)
- [ ] `.env.example` has all required variables
- [ ] Database migrations are ready
- [ ] Frontend assets build successfully (`npm run build`)
- [ ] APP_KEY is generated and set in Render
- [ ] APP_URL is set to your Render URL

**Ready to deploy!** 🚀

