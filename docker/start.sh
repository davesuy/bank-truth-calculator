#!/bin/bash
set -e

echo "Starting application..."

# Cache config at runtime (when app is fully loaded)
echo "Caching configuration..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Run migrations
echo "Running migrations..."
php artisan migrate --force

# Seed database
echo "Seeding database..."
php artisan db:seed --force || echo "Seeding skipped or failed (non-fatal)"

# Start Apache
echo "Starting Apache..."
exec apache2-foreground

