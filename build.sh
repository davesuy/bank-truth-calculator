#!/usr/bin/env bash
# exit on error
set -o errexit

echo "Installing Composer dependencies..."
composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist --ignore-platform-reqs

echo "Installing Node dependencies..."
npm ci --prefer-offline --no-audit

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
    chmod 664 database/database.sqlite
fi

# Ensure storage and bootstrap/cache are writable
chmod -R 775 storage bootstrap/cache

# Run migrations
echo "Running database migrations..."
php artisan migrate --force --no-interaction

# Seed database if needed
echo "Seeding database..."
php artisan db:seed --force --no-interaction

echo "Build completed successfully!"

