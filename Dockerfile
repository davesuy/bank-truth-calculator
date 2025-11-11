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
echo "🔧 Setting up environment..."\n\
\n\
# Show diagnostic info\n\
echo "📊 Diagnostic Information:"\n\
echo "   Working directory: $(pwd)"\n\
echo "   PHP version: $(php -v | head -n 1)"\n\
echo "   Laravel version: $(php artisan --version)"\n\
echo ""\n\
\n\
# Ensure storage and cache directories exist and are writable\n\
mkdir -p storage/framework/{sessions,views,cache} storage/logs bootstrap/cache\n\
chmod -R 777 storage bootstrap/cache\n\
echo "   ✅ Storage directories created and writable"\n\
\n\
# Ensure database file exists and is writable\n\
touch database/database.sqlite\n\
chmod 666 database/database.sqlite\n\
echo "   ✅ Database file created: $(ls -lh database/database.sqlite)"\n\
\n\
# Check if build assets exist\n\
if [ -f "public/build/manifest.json" ]; then\n\
    echo "   ✅ Vite manifest found: public/build/manifest.json"\n\
else\n\
    echo "   ⚠️  Vite manifest NOT found at public/build/manifest.json"\n\
    echo "   Contents of public/:"\n\
    ls -la public/\n\
fi\n\
echo ""\n\
\n\
echo "🗄️  Running migrations..."\n\
php artisan migrate --force || { echo "❌ Migration failed!"; exit 1; }\n\
\n\
echo "🌱 Seeding database..."\n\
php artisan db:seed --class=BankSeeder --force || echo "⚠️  Seeding skipped (data may already exist)"\n\
\n\
echo "🧹 Clearing caches..."\n\
php artisan config:clear || true\n\
php artisan cache:clear || true\n\
php artisan route:clear || true\n\
php artisan view:clear || true\n\
\n\
echo "⚙️  Caching configuration..."\n\
php artisan config:cache || echo "⚠️  Config cache failed"\n\
php artisan route:cache || echo "⚠️  Route cache failed"\n\
php artisan view:cache || echo "⚠️  View cache failed"\n\
\n\
echo ""\n\
echo "✅ Startup complete! Application ready."\n\
echo "🌐 Test endpoints:"\n\
echo "   - /test (basic test)"\n\
echo "   - /health (health check)"\n\
echo "   - /api/banks (API test)"\n\
echo ""\n\
\n\
echo "🚀 Starting server on port ${PORT:-8080}..."\n\
php artisan serve --host=0.0.0.0 --port=${PORT:-8080}\n\
' > /start.sh && chmod +x /start.sh

# Expose port
EXPOSE 8080

# Start Laravel server
CMD ["/start.sh"]

