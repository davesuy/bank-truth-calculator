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

# Verify Vite build output
RUN echo "📦 Verifying Vite build..." && \
    ls -la public/build/ || echo "⚠️ No build directory found" && \
    ls -la public/build/manifest.json || echo "⚠️ No manifest.json found"

# Create necessary directories and set permissions
RUN mkdir -p storage/framework/{sessions,views,cache} \
    && mkdir -p storage/logs \
    && mkdir -p bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# Create SQLite database
RUN touch database/database.sqlite && chmod 664 database/database.sqlite

# Don't cache config during build - do it at runtime with proper env vars

# Create startup script with better error handling
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
echo "================================="\n\
echo "🚀 Bank Truth Calculator Starting"\n\
echo "================================="\n\
echo ""\n\
\n\
# Show environment\n\
echo "📊 Environment:"\n\
echo "   PWD: $(pwd)"\n\
echo "   PHP: $(php -v | head -n 1)"\n\
echo "   PORT: ${PORT:-8080}"\n\
echo "   APP_ENV: ${APP_ENV:-production}"\n\
echo ""\n\
\n\
# Setup directories\n\
echo "📁 Setting up directories..."\n\
mkdir -p storage/framework/{sessions,views,cache} storage/logs bootstrap/cache database\n\
chmod -R 777 storage bootstrap/cache\n\
touch database/database.sqlite 2>/dev/null || true\n\
chmod 666 database/database.sqlite 2>/dev/null || true\n\
echo "   ✅ Directories ready"\n\
\n\
# Run migrations (dont fail if already done)\n\
echo ""\n\
echo "🗄️  Database setup..."\n\
php artisan migrate --force 2>&1 || echo "   ⚠️  Migrations skipped"\n\
php artisan db:seed --class=BankSeeder --force 2>&1 || echo "   ⚠️  Seeding skipped"\n\
echo "   ✅ Database ready"\n\
\n\
# Cache config\n\
echo ""\n\
echo "⚙️  Optimizing..."\n\
php artisan config:cache 2>&1 || true\n\
php artisan route:cache 2>&1 || true\n\
echo "   ✅ Optimization complete"\n\
\n\
# Show final status\n\
echo ""\n\
echo "================================="\n\
echo "✅ Ready to serve!"\n\
echo "================================="\n\
echo "🌐 Starting on 0.0.0.0:${PORT:-8080}"\n\
echo ""\n\
\n\
# Start server (this blocks)\n\
exec php artisan serve --host=0.0.0.0 --port=${PORT:-8080} --no-reload\n\
' > /start.sh && chmod +x /start.sh

# Expose port
EXPOSE 8080

# Start Laravel server
CMD ["/start.sh"]

