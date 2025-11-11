#!/bin/bash

echo "🚀 Bank Truth Calculator - Render Deployment Helper"
echo "=================================================="
echo ""

# Check if git is initialized
if [ ! -d .git ]; then
    echo "📦 Initializing Git repository..."
    git init
    echo "✅ Git initialized"
else
    echo "✅ Git already initialized"
fi

# Check if changes need to be committed
if [[ -n $(git status -s) ]]; then
    echo ""
    echo "📝 Committing changes..."
    git add .
    git commit -m "Prepare for Render deployment - $(date +%Y-%m-%d)"
    echo "✅ Changes committed"
else
    echo "✅ No uncommitted changes"
fi

echo ""
echo "🔑 Generating APP_KEY for production..."
APP_KEY=$(php artisan key:generate --show 2>/dev/null || echo "base64:$(openssl rand -base64 32)")
echo "Your APP_KEY: $APP_KEY"
echo ""
echo "⚠️  IMPORTANT: Save this APP_KEY - you'll need it for Render!"
echo ""

echo "📋 Next Steps:"
echo "=============="
echo ""
echo "1️⃣  Create GitHub Repository:"
echo "   - Go to: https://github.com/new"
echo "   - Name: bank-truth-calculator"
echo "   - Create repository (don't initialize with anything)"
echo ""
echo "2️⃣  Push to GitHub:"
echo "   git remote add origin https://github.com/YOUR_USERNAME/bank-truth-calculator.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "3️⃣  Deploy on Render:"
echo "   - Go to: https://render.com"
echo "   - Sign up/Login"
echo "   - New > Web Service"
echo "   - Connect your GitHub repo"
echo "   - Build Command: ./build.sh"
echo "   - Start Command: php artisan serve --host=0.0.0.0 --port=\$PORT"
echo "   - Add Environment Variables (see RENDER_DEPLOYMENT_GUIDE.md)"
echo "   - Use the APP_KEY shown above!"
echo ""
echo "📖 For detailed instructions, read: RENDER_DEPLOYMENT_GUIDE.md"
echo ""
echo "✨ Ready to deploy! Good luck!"

