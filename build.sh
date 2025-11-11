#!/usr/bin/env bash
# exit on error
set -o errexit

echo "==> Installing Composer dependencies..."
composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist --ignore-platform-reqs

echo "==> Installing Node dependencies..."
npm ci --prefer-offline --no-audit

echo "==> Building frontend assets..."
npm run build

echo "==> Setting up Laravel..."
# Clear and cache config
php artisan config:clear
php artisan config:cache

# Clear and cache routes
php artisan route:clear
php artisan route:cache

# Clear and cache views
php artisan view:clear
php artisan view:cache

# Create SQLite database if it doesn't exist
if [ ! -f database/database.sqlite ]; then
    echo "==> Creating SQLite database..."
    touch database/database.sqlite
    chmod 664 database/database.sqlite
fi

# Ensure storage and bootstrap/cache are writable
chmod -R 775 storage bootstrap/cache 2>/dev/null || true

echo "==> Running database migrations..."
php artisan migrate --force --no-interaction

echo "==> Seeding database..."
php artisan db:seed --force --no-interaction || echo "Warning: Seeding failed or no seeders found"

echo "==> Build completed successfully!"

