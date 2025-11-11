#!/usr/bin/env bash
# exit on error
set -o errexit

echo "🏗️  Building Bank Truth Calculator for Render..."

# Install PHP dependencies
echo "📦 Installing PHP dependencies..."
composer install --no-dev --optimize-autoloader --no-interaction

# Install Node dependencies and build assets
echo "📦 Installing Node dependencies..."
npm ci --prefer-offline --no-audit

echo "🔨 Building assets..."
npm run build

# Create necessary directories
echo "📁 Creating storage directories..."
mkdir -p storage/framework/{sessions,views,cache}
mkdir -p storage/logs
mkdir -p bootstrap/cache

# Set permissions
echo "🔐 Setting permissions..."
chmod -R 775 storage bootstrap/cache

# Create SQLite database if it doesn't exist
echo "🗄️  Preparing database..."
touch database/database.sqlite
chmod 664 database/database.sqlite

# Clear and cache Laravel configuration
echo "⚙️  Caching configuration..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Run database migrations
echo "🗄️  Running migrations..."
php artisan migrate --force

# Seed the database with initial bank data
echo "🌱 Seeding database..."
php artisan db:seed --class=BankSeeder --force

echo "✅ Build complete! Ready to serve."

