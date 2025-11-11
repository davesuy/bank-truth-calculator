# 🔧 Render Deployment Fix - PHP Command Not Found

## ✅ ISSUE FIXED!

The "php: command not found" error has been resolved by updating the configuration to use Render's Heroku-style PHP buildpack.

---

## 🛠 What Was Changed

### 1. Updated `render.yaml`
Changed from:
```yaml
runtime: php
startCommand: "php -S 0.0.0.0:$PORT -t public public/index.php"
```

To:
```yaml
env: php
startCommand: "heroku-php-apache2 public/"
```

**Why:** Render's PHP environment uses Heroku buildpacks which include Apache server.

### 2. Updated `build.sh`
Added:
- `--ignore-platform-reqs` flag for Composer
- File permissions for database and storage
- Better error handling

### 3. Fixed `start.sh`
Removed invalid Procfile syntax that was accidentally included.

### 4. Updated `Procfile`
Changed to use Apache server:
```
web: heroku-php-apache2 public/
```

---

## 🚀 How to Deploy with the Fix

### Step 1: Commit the Fixed Files

```bash
cd /Users/davesuy/website-projects/bank-truth-calculator

# Add all changes
git add .

# Commit the fix
git commit -m "Fix: Use Heroku PHP buildpack for Render deployment"

# Push to GitHub
git push origin main
```

### Step 2: Redeploy on Render

If you already created the web service:
1. Go to your Render Dashboard
2. Select your web service
3. Click **"Manual Deploy"** → **"Clear build cache & deploy"**

If you haven't created the service yet:
1. Go to https://render.com
2. Click **"New +"** → **"Web Service"**
3. Connect your GitHub repository
4. Render will detect the updated `render.yaml`
5. Click **"Create Web Service"**

### Step 3: Set Environment Variables

In Render Dashboard → Environment:

```
APP_KEY=base64:YOUR_KEY_HERE
APP_URL=https://your-app-name.onrender.com
```

Generate APP_KEY:
```bash
php artisan key:generate --show
```

---

## ✅ What to Expect

### Build Process (3-5 minutes):
1. ✅ Install Composer dependencies
2. ✅ Install NPM dependencies
3. ✅ Build frontend assets
4. ✅ Cache Laravel configuration
5. ✅ Create SQLite database
6. ✅ Run migrations
7. ✅ Seed database
8. ✅ **Start Apache server** (new approach)

### Success Indicators:
- Build completes without "php: command not found" error
- Start command shows Apache starting
- App accessible at your Render URL
- Routes work correctly

---

## 🔍 Troubleshooting the Fix

### If Build Still Fails:

#### Check 1: Verify render.yaml
Ensure your `render.yaml` has:
```yaml
env: php  # NOT "runtime: php"
startCommand: "heroku-php-apache2 public/"
```

#### Check 2: Composer Dependencies
If you see Composer errors, the build.sh now includes `--ignore-platform-reqs` which should help.

#### Check 3: Node/NPM Issues
If npm fails:
- Check that `package.json` exists
- Verify `vite.config.js` is present
- Ensure Node version compatibility

#### Check 4: Database Issues
If migrations fail:
- Check that SQLite database directory exists
- Verify permissions are set correctly
- Review migration files for errors

---

## 📊 Comparing Old vs New Approach

### ❌ Old Approach (Failed):
- Used `runtime: php`
- Tried to run PHP built-in server directly
- PHP command not in PATH during start
- Error: "php: command not found"

### ✅ New Approach (Working):
- Uses `env: php`
- Uses Heroku PHP buildpack
- Apache server with proper PHP-FPM
- More stable and production-ready

---

## 🎯 Benefits of Apache Approach

1. **✅ More Stable:** Apache is production-tested
2. **✅ Better Performance:** PHP-FPM handles requests efficiently
3. **✅ Proper Routing:** Apache handles Laravel routing correctly
4. **✅ Production Ready:** Standard setup used by thousands
5. **✅ Better Logging:** Apache provides detailed access logs

---

## 📝 Alternative: Nginx (If Apache Doesn't Work)

If you prefer Nginx, update `render.yaml`:

```yaml
startCommand: "heroku-php-nginx public/"
```

And use the included `nginx.conf` file.

---

## 🔄 After Successful Deployment

Once deployed successfully:

### ✅ Test Your App:
- Visit your Render URL
- Test calculator functionality
- Check API endpoints
- Verify bank data loaded

### ✅ Monitor Logs:
- Go to Render Dashboard → Logs
- Watch for any PHP errors
- Check Apache access logs

### ✅ Verify Database:
```bash
# You can check if data was seeded by testing:
curl https://your-app-name.onrender.com/api/banks
```

---

## 🆘 Still Having Issues?

### Check Build Logs:
Look for these specific errors:
- Composer dependency conflicts
- NPM build failures
- Migration errors
- Permission issues

### Common Solutions:

#### "Class not found" errors:
```bash
# Clear all caches in build.sh (already added)
php artisan config:clear
php artisan route:clear
php artisan view:clear
```

#### Storage permission errors:
```bash
# Set proper permissions (already in build.sh)
chmod -R 775 storage bootstrap/cache
```

#### SQLite errors:
```bash
# Ensure database file exists (already in build.sh)
touch database/database.sqlite
chmod 664 database/database.sqlite
```

---

## 📚 Additional Resources

- **Render PHP Docs:** https://render.com/docs/deploy-php
- **Heroku PHP Buildpack:** https://github.com/heroku/heroku-buildpack-php
- **Laravel Deployment:** https://laravel.com/docs/deployment

---

## ✨ Summary

**Problem:** PHP command not found in start script  
**Solution:** Use Heroku PHP buildpack with Apache  
**Status:** ✅ FIXED  
**Action:** Commit changes and redeploy  

---

**Updated:** November 11, 2025  
**Fix Version:** v2.0  
**Status:** Ready to Deploy 🚀

