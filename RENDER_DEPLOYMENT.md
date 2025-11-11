# Deploying Bank Truth Calculator to Render

This guide will help you deploy your Laravel application to Render.

## Prerequisites

1. A GitHub account with this repository
2. A Render account (sign up at https://render.com)
3. Your code pushed to a GitHub repository

## Deployment Steps

### Step 1: Prepare Your Repository

Make sure all the deployment files are committed to your repository:
- `render.yaml` - Render configuration
- `build.sh` - Build script
- `.env.example` - Environment variables template

### Step 2: Push to GitHub

```bash
# Initialize git if not already done
git init

# Add all files
git add .

# Commit changes
git commit -m "Add Render deployment configuration"

# Add your GitHub repository as remote
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git

# Push to GitHub
git push -u origin main
```

### Step 3: Create a New Web Service on Render

1. Go to https://dashboard.render.com
2. Click **"New +"** and select **"Web Service"**
3. Connect your GitHub repository
4. Render will automatically detect the `render.yaml` file

### Step 4: Configure Environment Variables

Render will automatically set up most environment variables from `render.yaml`, but you need to set:

1. **APP_KEY**: Generate one by running `php artisan key:generate --show` locally and copy the value
2. **APP_URL**: Set to your Render URL (e.g., `https://bank-truth-calculator.onrender.com`)

You can set these in the Render dashboard under **Environment** section.

### Step 5: Deploy

1. Click **"Create Web Service"**
2. Render will automatically:
   - Install PHP dependencies
   - Install Node dependencies
   - Build frontend assets
   - Run database migrations
   - Seed the database
   - Start your application

### Step 6: Access Your Application

Once deployed, your application will be available at:
```
https://YOUR_APP_NAME.onrender.com
```

## Database Options

### Option 1: SQLite (Default)

The default configuration uses SQLite, which is suitable for small applications and the free tier.

### Option 2: PostgreSQL (Recommended for Production)

To use PostgreSQL:

1. In `render.yaml`, uncomment the database section
2. Update the environment variables:
   ```yaml
   - key: DB_CONNECTION
     value: pgsql
   - key: DB_HOST
     fromDatabase:
       name: bank-truth-db
       property: host
   - key: DB_PORT
     fromDatabase:
       name: bank-truth-db
       property: port
   - key: DB_DATABASE
     fromDatabase:
       name: bank-truth-db
       property: database
   - key: DB_USERNAME
     fromDatabase:
       name: bank-truth-db
       property: user
   - key: DB_PASSWORD
     fromDatabase:
       name: bank-truth-db
       property: password
   ```

## Troubleshooting

### Build Fails

- Check the build logs in Render dashboard
- Ensure all dependencies are in `composer.json` and `package.json`
- Verify `build.sh` has execute permissions

### Database Issues

- For SQLite: Ensure the database directory is writable
- For PostgreSQL: Verify connection settings
- Check migrations ran successfully in build logs

### Asset Issues

- Ensure `npm run build` completes successfully
- Check that `public/build` directory is created
- Verify Vite configuration is correct

### Application Errors

- Check logs in Render dashboard
- Ensure `APP_KEY` is set
- Verify `APP_URL` matches your Render URL
- Check `APP_DEBUG` is set to `false` in production

## Manual Build Script Execution (for testing)

To test the build script locally:

```bash
chmod +x build.sh
./build.sh
```

## Important Notes

1. **Free Tier Limitations**: Render's free tier will spin down after 15 minutes of inactivity
2. **Storage**: Free tier has ephemeral storage, so uploaded files will be lost on restart
3. **Database**: SQLite database will persist, but consider PostgreSQL for production
4. **Performance**: First request after spin-down will be slow (cold start)

## Next Steps

- Set up custom domain (in Render dashboard)
- Configure email service (update MAIL_* variables)
- Set up monitoring and logging
- Configure cache driver (Redis recommended for production)
- Set up queue worker if needed

## Support

For issues specific to Render, check:
- Render Documentation: https://render.com/docs
- Render Community: https://community.render.com
services:
  - type: web
    name: bank-truth-calculator
    runtime: php
    plan: free
    buildCommand: "./build.sh"
    startCommand: "php -S 0.0.0.0:$PORT -t public public/index.php"
    envVars:
      - key: APP_ENV
        value: production
      - key: APP_DEBUG
        value: false
      - key: APP_KEY
        generateValue: true
      - key: APP_URL
        sync: false
      - key: LOG_CHANNEL
        value: stderr
      - key: SESSION_DRIVER
        value: cookie
      - key: CACHE_STORE
        value: file
      - key: QUEUE_CONNECTION
        value: sync
      - key: DB_CONNECTION
        value: sqlite
      - key: DB_DATABASE
        value: /opt/render/project/src/database/database.sqlite

databases:
  # Uncomment below if you want to use PostgreSQL instead of SQLite
  # - name: bank-truth-db
  #   databaseName: bank_truth
  #   user: bank_truth_user

