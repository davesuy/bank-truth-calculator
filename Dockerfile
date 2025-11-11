FROM php:8.2-cli

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    sqlite3 \
    libsqlite3-dev \
    nodejs \
    npm

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_sqlite mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . /var/www/html

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Install Node dependencies and build assets
RUN npm ci --prefer-offline --no-audit
RUN npm run build

# Create necessary directories and set permissions
RUN mkdir -p storage/framework/{sessions,views,cache} \
    && mkdir -p storage/logs \
    && mkdir -p bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# Create SQLite database
RUN touch database/database.sqlite && chmod 664 database/database.sqlite

# Cache Laravel configuration (but not routes/views since they may fail without DB)
RUN php artisan config:cache

# Create startup script
RUN echo '#!/bin/bash\n\
set -e\n\
echo "🗄️  Running migrations..."\n\
php artisan migrate --force\n\
echo "🌱 Seeding database..."\n\
php artisan db:seed --class=BankSeeder --force || true\n\
echo "⚙️  Caching routes and views..."\n\
php artisan route:cache\n\
php artisan view:cache\n\
echo "🚀 Starting server on port ${PORT:-8080}..."\n\
php artisan serve --host=0.0.0.0 --port=${PORT:-8080}\n\
' > /start.sh && chmod +x /start.sh

# Expose port
EXPOSE 8080

# Start Laravel server
CMD ["/start.sh"]

