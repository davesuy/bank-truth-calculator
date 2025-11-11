# 🔧 Fixing the 500 Error

## What I Fixed

Your service deployed successfully but showed a **500 Internal Server Error** when visiting the URL. This is typically caused by:
1. ❌ Storage/logs directories not writable
2. ❌ Database file permissions issues
3. ❌ Cached configuration conflicts
4. ❌ Missing environment variables

## Changes Made

### 1. **Dockerfile** - Better Runtime Setup
✅ Enhanced startup script to:
- Create and ensure storage/logs directories are writable (chmod 777)
- Ensure database file is writable (chmod 666)
- Clear any stale cache before starting
- Better error handling with clear messages

### 2. **render.yaml** - Debug Mode & Missing Vars
✅ Enabled `APP_DEBUG=true` temporarily to see actual errors
✅ Added `APP_URL` environment variable (required by Laravel)

## Next Steps

### 1. Deploy the Fix on Render

**Go to Render Dashboard NOW:**
1. Open: https://dashboard.render.com
2. Click your "bank-truth-calculator-1" service
3. Click **"Manual Deploy"** dropdown
4. Select **"Deploy latest commit"**
5. Wait for build to complete (~5-10 minutes)

### 2. Check the Logs

While deploying, watch the logs for:
```
🔧 Setting up environment...
🗄️  Running migrations...
🌱 Seeding database...
⚙️  Caching configuration...
🚀 Starting server on port 10000...
```

### 3. Visit Your Site

After deployment completes:
- Visit: https://bank-truth-calculator-1.onrender.com
- **If still shows 500**: You'll now see the ACTUAL error message (debug mode is on)
- Copy that error and share it with me

### 4. Check Specific Routes

Try these URLs:
- `https://bank-truth-calculator-1.onrender.com/` - Homepage
- `https://bank-truth-calculator-1.onrender.com/calculator` - Calculator page
- `https://bank-truth-calculator-1.onrender.com/api/banks` - API endpoint

## What Should Happen

✅ **If the fix worked:**
- Site loads successfully
- No 500 error
- Calculator page shows up

✅ **If still shows 500 BUT:**
- Now you see detailed error message with stack trace
- This tells us EXACTLY what's wrong
- Share that error with me

## Common 500 Error Causes (Fixed)

| Issue | Status | Fix Applied |
|-------|--------|-------------|
| Storage not writable | ✅ Fixed | chmod 777 at runtime |
| Database not writable | ✅ Fixed | chmod 666 at runtime |
| Stale config cache | ✅ Fixed | Clear cache before start |
| Missing APP_URL | ✅ Fixed | Added to render.yaml |
| Can't see errors | ✅ Fixed | APP_DEBUG=true |

## If You Still Get Errors

**With debug mode ON, you'll see something like:**
```
RuntimeException: The only supported ciphers are AES-128-CBC and AES-256-CBC...
```
or
```
PDOException: SQLSTATE[HY000] [14] unable to open database file...
```
or
```
ErrorException: file_put_contents(...): Failed to open stream: Permission denied...
```

**Copy the EXACT error message** and share it - I can fix it immediately!

## Quick Troubleshooting

### If site works but some pages don't:
- ✅ Clear browser cache
- ✅ Try in incognito mode
- ✅ Check Render logs for errors

### If API endpoints don't work:
- Check: `https://bank-truth-calculator-1.onrender.com/api/banks`
- Should return JSON with bank data

### If calculator page is blank:
- Check browser console (F12) for JavaScript errors
- Might be frontend asset issue

## After Everything Works

Once the site is working properly:
1. Go to Render Dashboard > Settings
2. Change `APP_DEBUG` back to `"false"`
3. Redeploy

(We'll keep it on "true" for now to diagnose issues)

## Summary

✅ Pushed fixes to GitHub
✅ Improved runtime permissions
✅ Enabled debug mode
✅ Added missing APP_URL

**Now:** Go deploy on Render and let me know what happens!

The fixes should resolve the 500 error. If not, we'll see the actual error message now and can fix it quickly.

