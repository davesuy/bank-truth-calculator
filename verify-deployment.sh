#!/usr/bin/env bash

# Quick verification script to check all deployment files

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║         Render Deployment Files Verification             ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Check render.yaml
if [ -f "render.yaml" ]; then
    echo "✅ render.yaml exists"
    if grep -q "heroku-php-apache2" render.yaml; then
        echo "   ✅ Start command: heroku-php-apache2 ✓"
    else
        echo "   ⚠️  Start command might be incorrect"
    fi
else
    echo "❌ render.yaml MISSING!"
fi

# Check build.sh
if [ -f "build.sh" ]; then
    echo "✅ build.sh exists"
    if [ -x "build.sh" ]; then
        echo "   ✅ Executable: YES ✓"
    else
        echo "   ⚠️  Not executable, fixing..."
        chmod +x build.sh
        echo "   ✅ Now executable ✓"
    fi
    if grep -q "Checking for Composer" build.sh; then
        echo "   ✅ Composer auto-install: PRESENT ✓"
    else
        echo "   ❌ Composer auto-install: MISSING!"
    fi
else
    echo "❌ build.sh MISSING!"
fi

# Check Procfile
if [ -f "Procfile" ]; then
    echo "✅ Procfile exists"
else
    echo "⚠️  Procfile missing (optional)"
fi

# Check composer.json and lock
if [ -f "composer.json" ] && [ -f "composer.lock" ]; then
    echo "✅ Composer files present"
else
    echo "❌ Composer files missing!"
fi

# Check package.json
if [ -f "package.json" ]; then
    echo "✅ package.json exists"
else
    echo "❌ package.json MISSING!"
fi

# Check database
if [ -f "database/database.sqlite" ]; then
    echo "✅ SQLite database exists"
else
    echo "ℹ️  SQLite database will be created during build"
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo ""

# Check git status
if git rev-parse --git-dir > /dev/null 2>&1; then
    echo "📊 Git Status:"
    echo "────────────────────────────────────────────────────────────"
    git status --short
    echo ""

    # Check if there are uncommitted changes
    if [[ -n $(git status --short) ]]; then
        echo "⚠️  You have uncommitted changes!"
        echo ""
        echo "Run these commands to deploy:"
        echo "  git add ."
        echo "  git commit -m \"Fix: Auto-install Composer for Render\""
        echo "  git push origin main"
    else
        echo "✅ All changes committed!"
        echo ""
        echo "Ready to deploy on Render!"
    fi
else
    echo "⚠️  Not a git repository"
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo ""
echo "✨ Verification Complete!"
echo ""

