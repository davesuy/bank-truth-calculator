#!/usr/bin/env bash
# exit on error
set -o errexit

echo "Installing Composer dependencies..."
composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

echo "Installing Node dependencies..."
npm ci

echo "Building frontend assets..."
npm run build

echo "Setting up Laravel..."
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
    echo "Creating SQLite database..."
    touch database/database.sqlite
fi

# Run migrations
echo "Running database migrations..."
php artisan migrate --force --no-interaction

# Seed database if needed
echo "Seeding database..."
php artisan db:seed --force --no-interaction

echo "Build completed successfully!"

