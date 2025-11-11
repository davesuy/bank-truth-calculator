# Render Deployment Fix

## Problem
Render was detecting the project as a Node.js project instead of PHP, causing the build to fail with "composer: command not found".

## Changes Made

### 1. Updated `render.yaml`
- **Changed runtime**: From `docker` to `php`
- **Added buildCommand**: `./build.sh`
- **Added startCommand**: `php -S 0.0.0.0:$PORT -t public`
- **Fixed APP_DEBUG**: Changed from boolean `false` to string `"false"`
- **Updated DB_DATABASE path**: Changed to `/opt/render/project/src/database/database.sqlite` (Render's project path)

### 2. Updated `build.sh`
- Added automatic Composer installation if not available
- Script now handles environments where Composer isn't pre-installed
- Uses `php composer.phar` if global Composer isn't available

## Next Steps to Deploy

### Option 1: Update Existing Service (Recommended)
If you already created a service on Render:

1. Go to your service dashboard on Render
2. Click "Settings"
3. Under "Build & Deploy":
   - Set **Runtime** to `PHP`
   - Set **Build Command** to `./build.sh`
   - Set **Start Command** to `php -S 0.0.0.0:$PORT -t public`
4. Commit and push these changes to GitHub:
   ```bash
   git add render.yaml build.sh
   git commit -m "Fix: Update Render config to use PHP runtime"
   git push origin main
   ```
5. Go back to Render and click "Manual Deploy" > "Deploy latest commit"

### Option 2: Create New Service from render.yaml
If you haven't created a service yet or want to start fresh:

1. Commit and push the changes:
   ```bash
   git add render.yaml build.sh
   git commit -m "Fix: Update Render config to use PHP runtime"
   git push origin main
   ```
2. Go to Render Dashboard
3. Click "New" > "Blueprint"
4. Connect your GitHub repository
5. Render will automatically detect and use the `render.yaml` configuration

## Environment Variables
The following environment variables are configured in `render.yaml`:
- `APP_NAME`: Bank Truth Calculator
- `APP_ENV`: production
- `APP_KEY`: base64:2azluL8LXJhWal35l/a74fyIvdHsMsXBwRMnjLIEzqw=
- `APP_DEBUG`: "false"
- `LOG_CHANNEL`: stderr
- `DB_CONNECTION`: sqlite
- `DB_DATABASE`: /opt/render/project/src/database/database.sqlite
- `SESSION_DRIVER`: file
- `CACHE_DRIVER`: file

## What the Build Script Does
1. ✅ Installs Composer (if needed)
2. ✅ Installs PHP dependencies
3. ✅ Installs Node.js dependencies
4. ✅ Builds frontend assets (Vite)
5. ✅ Creates storage directories
6. ✅ Sets permissions
7. ✅ Creates SQLite database
8. ✅ Caches Laravel configuration
9. ✅ Runs database migrations
10. ✅ Seeds initial bank data

## Troubleshooting

### If deployment still fails:
1. Check Render logs for specific error messages
2. Verify PHP version compatibility (should be PHP 8.2+)
3. Ensure all environment variables are set correctly
4. Check that the build script has execute permissions:
   ```bash
   chmod +x build.sh
   git add build.sh
   git commit -m "Make build.sh executable"
   git push
   ```

### If database issues occur:
- The SQLite database path must be writable
- Storage directories must have proper permissions (775)
- Migrations must complete successfully

## Testing Locally
Before deploying, you can test the build script locally:
```bash
./build.sh
php -S localhost:8000 -t public
```

Then visit http://localhost:8000 in your browser.

