#!/usr/bin/env bash

# Quick Deployment Helper Script
# This script helps you prepare for Render deployment

echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║       Bank Truth Calculator - Render Deployment           ║"
echo "║                   Helper Script                            ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "⚠️  Git repository not initialized!"
    echo ""
    echo "Would you like to initialize git now? (y/n)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        git init
        echo "✅ Git initialized"
    else
        echo "❌ Please initialize git manually: git init"
        exit 1
    fi
fi

echo ""
echo "📋 Pre-Deployment Checklist:"
echo "════════════════════════════════════════════════════════════"
echo ""

# Check render.yaml
if [ -f "render.yaml" ]; then
    echo "✅ render.yaml exists"
else
    echo "❌ render.yaml missing!"
    exit 1
fi

# Check build.sh
if [ -f "build.sh" ] && [ -x "build.sh" ]; then
    echo "✅ build.sh exists and is executable"
else
    echo "⚠️  build.sh not executable, fixing..."
    chmod +x build.sh
    echo "✅ build.sh is now executable"
fi

# Check start.sh
if [ -f "start.sh" ] && [ -x "start.sh" ]; then
    echo "✅ start.sh exists and is executable"
else
    echo "⚠️  start.sh not executable, fixing..."
    chmod +x start.sh
    echo "✅ start.sh is now executable"
fi

# Check .env.example
if [ -f ".env.example" ]; then
    echo "✅ .env.example exists"
else
    echo "⚠️  .env.example missing"
fi

echo ""
echo "🔑 Generating APP_KEY for Render:"
echo "════════════════════════════════════════════════════════════"

if command -v php &> /dev/null; then
    if [ -f "artisan" ]; then
        APP_KEY=$(php artisan key:generate --show 2>/dev/null)
        if [ -n "$APP_KEY" ]; then
            echo ""
            echo "Copy this APP_KEY for Render:"
            echo "────────────────────────────────────────────────────────"
            echo "$APP_KEY"
            echo "────────────────────────────────────────────────────────"
            echo ""
        else
            echo "⚠️  Could not generate APP_KEY"
            echo "Run manually: php artisan key:generate --show"
        fi
    else
        echo "⚠️  artisan file not found"
    fi
else
    echo "⚠️  PHP not found in PATH"
fi

echo ""
echo "📦 Git Status:"
echo "════════════════════════════════════════════════════════════"
git status --short

echo ""
echo "🚀 Next Steps:"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "1. Commit your changes:"
echo "   git add ."
echo "   git commit -m \"Add Render deployment configuration\""
echo ""
echo "2. Add your GitHub remote (if not done):"
echo "   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
echo ""
echo "3. Push to GitHub:"
echo "   git push -u origin main"
echo ""
echo "4. Deploy on Render:"
echo "   • Go to: https://render.com"
echo "   • Click: New + → Web Service"
echo "   • Connect your GitHub repository"
echo "   • Set APP_KEY and APP_URL in Environment"
echo ""
echo "5. Your app will be live at:"
echo "   https://your-app-name.onrender.com"
echo ""
echo "════════════════════════════════════════════════════════════"
echo ""
echo "📚 For detailed instructions, see:"
echo "   → RENDER_QUICKSTART.md"
echo "   → DEPLOYMENT_CHECKLIST.md"
echo ""
echo "✨ Ready to deploy! Good luck! 🚀"
echo ""

