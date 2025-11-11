# 💰 Bank Truth Calculator

A Laravel-based web application that helps users calculate and compare the real cost of keeping money in low-interest savings accounts versus high-yield alternatives.

## Features

- 💵 **Interactive Savings Calculator** - Calculate opportunity cost over time
- 🏦 **Bank Comparison Tool** - Compare sponsored high-yield accounts vs traditional banks
- 📊 **Real-time Calculations** - See how much money you're losing monthly/yearly
- 🎯 **Monthly Contribution Support** - Factor in regular deposits
- 📱 **Responsive Design** - Works on desktop and mobile
- ⚡ **Fast & Modern** - Built with Laravel 11 + Vue 3 + Vite

## Tech Stack

- **Backend**: Laravel 11, PHP 8.2
- **Frontend**: Vue 3, Vite
- **Database**: SQLite
- **Styling**: Tailwind CSS (coming soon)
- **Deployment**: Render (Docker)

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

# Create database and run migrations
touch database/database.sqlite
php artisan migrate

# Seed with bank data
php artisan db:seed --class=BankSeeder

# Build frontend assets
npm run build

# Start development server
php artisan serve
```

Visit: http://localhost:8000/calculator

## Deployment

### Deploy to Render

This project is configured for one-click deployment to Render using Docker.

⚠️ **Important**: See [⚠️_READ_THIS_FIRST_⚠️.md](⚠️_READ_THIS_FIRST_⚠️.md) for deployment instructions.

**Quick summary:**
1. Create new Web Service on Render
2. Connect this repository
3. **Choose "Blueprint"** option (it will read `render.yaml`)
4. Or manually set **Environment** to "Docker"
5. Deploy!

The application will automatically:
- Build with Docker
- Install dependencies
- Run migrations
- Seed database
- Start the server

## Project Structure

```
├── app/
│   ├── Http/Controllers/
│   │   └── BankController.php    # API endpoints
│   └── Models/
│       └── Bank.php               # Bank model
├── database/
│   ├── migrations/                # Database schema
│   └── seeders/
│       └── BankSeeder.php         # Sample bank data
├── resources/
│   ├── js/
│   │   └── components/
│   │       └── BankCalculator.vue # Main calculator component
│   └── views/
│       └── calculator.blade.php   # Calculator page
├── routes/
│   └── web.php                    # Routes
├── Dockerfile                     # Docker configuration
└── render.yaml                    # Render deployment config
```

## Additional Documentation

- [⚠️_READ_THIS_FIRST_⚠️.md](⚠️_READ_THIS_FIRST_⚠️.md) - Render deployment guide
- [MONTHLY_CONTRIBUTION_FEATURE.md](MONTHLY_CONTRIBUTION_FEATURE.md) - Monthly contributions feature
- [VUE3_SETUP.md](VUE3_SETUP.md) - Vue 3 setup guide
- [VUE3_TROUBLESHOOTING.md](VUE3_TROUBLESHOOTING.md) - Vue troubleshooting
- [XML_API_INTEGRATION.md](XML_API_INTEGRATION.md) - External API integration

## License

This project is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).

## Security Vulnerabilities

If you discover a security vulnerability within Laravel, please send an e-mail to Taylor Otwell via [taylor@laravel.com](mailto:taylor@laravel.com). All security vulnerabilities will be promptly addressed.

## License

The Laravel framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).
