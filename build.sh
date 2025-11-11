#!/usr/bin/env bash
# exit on error
set -o errexit

echo "🏗️  Building Bank Truth Calculator for Render..."

# Check if PHP is available
if ! command -v php &> /dev/null; then
    echo "⚠️  PHP not found. Checking if this is Render environment..."

    # On Render with PHP runtime, composer should be pre-installed
    if command -v composer &> /dev/null; then
        echo "✅ Composer found, continuing with build..."
        COMPOSER_CMD="composer"
    else
        echo "❌ Neither PHP nor Composer found. Cannot continue."
        exit 1
    fi
else
    echo "✅ PHP found: $(php -v | head -n 1)"

    # Check if composer exists, if not, install it
    if ! command -v composer &> /dev/null; then
        echo "🔧 Installing Composer..."
        EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
        php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
        ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

        if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
            >&2 echo 'ERROR: Invalid composer installer checksum'
            rm composer-setup.php
            exit 1
        fi

        php composer-setup.php --quiet
        rm composer-setup.php
        COMPOSER_CMD="php composer.phar"
    else
        COMPOSER_CMD="composer"
    fi
fi

# Install PHP dependencies
echo "📦 Installing PHP dependencies..."
$COMPOSER_CMD install --no-dev --optimize-autoloader --no-interaction

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

