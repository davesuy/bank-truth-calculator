#!/usr/bin/env bash
# exit on error
set -o errexit

echo "==> Checking for Composer..."
if ! command -v composer &> /dev/null; then
    echo "==> Installing Composer..."
    EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

    if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
        echo 'ERROR: Invalid installer checksum'
        rm composer-setup.php
        exit 1
    fi

    php composer-setup.php --quiet
    rm composer-setup.php

    # Use the local composer.phar
    COMPOSER_CMD="php composer.phar"
    echo "==> Composer installed successfully!"
else
    COMPOSER_CMD="composer"
    echo "==> Composer already available!"
fi

echo "==> Installing Composer dependencies..."
$COMPOSER_CMD install --no-dev --optimize-autoloader --no-interaction --prefer-dist --ignore-platform-reqs

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

