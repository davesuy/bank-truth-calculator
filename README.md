# 💰 Bank Truth Calculator

A Laravel-based web application that helps users calculate and compare the real cost of keeping money in low-interest savings accounts versus high-yield alternatives.

**Live Demo:** https://bank-truth-calculator.onrender.com/

**Screen Recording:** https://www.loom.com/share/4ffaa0bf139d47cb942c5ba465941680

> **⚠️ First Load Note:** The app is on Render's free tier. Please allow 50-60 seconds for the initial page load as the server wakes up from sleep. Subsequent visits will be instant.

> **Note:** The current calculator implementation demonstrates technical capabilities in full-stack development. The calculation logic shown is not the final implementation but serves to showcase abilities in building this type of feature.

## Features

- 💵 **Interactive Savings Calculator** - Calculate opportunity cost over time
- 🏦 **Bank Comparison Tool** - Compare sponsored high-yield accounts vs traditional banks
- 📊 **Real-time Calculations** - See how much money you're losing monthly/yearly
- 🎯 **Monthly Contribution Support** - Factor in regular deposits
- 📱 **Responsive Design** - Works on desktop and mobile
- ⚡ **Fast & Modern** - Built with Laravel 12 + Vue 3 + Vite

## Tech Stack

- **Backend**: Laravel 12.0, PHP 8.2
- **Frontend**: Vue 3, Vite
- **Database**: SQLite
- **Server**: Apache (via Docker)
- **Deployment**: Render (Docker)
- **Version Control**: Git/GitHub

## API Endpoints

- `GET /api/banks` - Get all banks
- `GET /api/banks/sponsored` - Get high-yield sponsored banks
- `GET /api/banks/low-rate` - Get traditional low-rate banks
- `POST /api/banks/compare` - Compare savings calculations

## Local Development

### Prerequisites
- PHP 8.2+
- Composer
- Node.js 18+
- npm

### Installation

```bash
# Clone repository
git clone https://github.com/davesuy/bank-truth-calculator.git
cd bank-truth-calculator

# Install PHP dependencies
composer install

# Install Node dependencies
npm install

# Copy environment file
cp .env.example .env

# Generate application key
php artisan key:generate

# Create database
touch database/database.sqlite

# Run migrations and seed
php artisan migrate --seed

# Build frontend assets
npm run build

# Start development server
php artisan serve
```

Visit: http://localhost:8000

## Deployment

### Deploy to Render

This project is configured for automatic deployment to Render using Docker.

#### Quick Deploy Steps:

1. **Push to GitHub**
   ```bash
   git push origin main
   ```

2. **Create Web Service on Render**
   - Go to https://render.com
   - Click "New +" → "Web Service"
   - Connect your GitHub repository
   - Render will auto-detect `render.yaml`

3. **Set Environment Variables**
   - `APP_KEY` - Generate with: `php artisan key:generate --show`
   - `APP_URL` - Your Render URL (e.g., https://your-app.onrender.com)
   - `ASSET_URL` - Same as APP_URL (for HTTPS assets)

4. **Deploy**
   - Click "Create Web Service"
   - Wait 5-8 minutes for initial build
   - App will be live!

#### What Happens During Deployment:

The Docker container automatically:
- ✅ Installs all PHP and Node dependencies
- ✅ Builds frontend assets with Vite
- ✅ Runs database migrations
- ✅ Seeds bank data
- ✅ Configures Apache web server
- ✅ Starts the application

## Project Structure

```
├── app/
│   ├── Http/Controllers/
│   │   └── BankController.php        # API endpoints
│   ├── Models/
│   │   └── Bank.php                  # Bank model
│   └── Providers/
│       └── AppServiceProvider.php    # HTTPS URL forcing
├── database/
│   ├── migrations/
│   │   └── create_banks_table.php    # Banks table schema
│   └── seeders/
│       ├── DatabaseSeeder.php        # Main seeder
│       └── BankSeeder.php            # Bank data (9 banks)
├── resources/
│   ├── js/
│   │   ├── app.js                    # Vue app initialization
│   │   └── components/
│   │       └── BankCalculator.vue    # Calculator component
│   └── views/
│       └── calculator.blade.php      # Calculator page
├── routes/
│   └── web.php                       # Web & API routes
├── docker/
│   ├── start.sh                      # Container startup script
│   └── 000-default.conf              # Apache configuration
├── Dockerfile                        # Docker build configuration
├── render.yaml                       # Render deployment config
└── vite.config.js                    # Vite bundler config
```

## Development Features Demonstrated

- ✅ RESTful API design
- ✅ Vue 3 Composition API
- ✅ Database migrations and seeding
- ✅ Docker containerization
- ✅ Cloud deployment (Render)
- ✅ HTTPS enforcement
- ✅ Asset compilation with Vite
- ✅ Git version control
- ✅ Environment configuration

## Bank Data

The application includes seeded data for:
- **4 Sponsored Banks** - High-yield savings accounts (4.75% - 5.25% APY)
- **5 Low-Rate Banks** - Traditional big banks (0.01% - 0.25% APY)

Data can be managed through the API or database seeders.

## Contributing

This is a demonstration project showcasing full-stack development capabilities.

## License

This project is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).

---

**Built by:** Dave Ramirez  
**Repository:** https://github.com/davesuy/bank-truth-calculator  
**Live Demo:** https://bank-truth-calculator.onrender.com/  
**Date:** November 2025
