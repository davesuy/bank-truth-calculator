# Bank Truth Calculator - Implementation Guide

## Overview

A comprehensive bank savings comparison calculator built with Laravel 12 and Vue.js 3. This application allows users to compare high-yield sponsored banks with traditional "big banks" to see the real difference in savings over time.

## Features

✅ **Two-Column Comparison**
- Left Side: Sponsored/High-Yield Banks (Green theme)
- Right Side: Traditional Big Banks with Low Rates (Red theme)

✅ **Interactive Selection**
- Click to select banks from either column
- Visual feedback with selected states
- Auto-selects first banks by default

✅ **Real-Time Calculations**
- Compound interest calculations
- Adjustable initial deposit
- Adjustable time period (1-50 years)
- Shows final amounts, interest earned, and difference

✅ **Beautiful UI**
- Responsive design
- Gradient backgrounds
- Smooth animations
- Professional styling with Tailwind CSS

## Project Structure

```
app/
├── Http/Controllers/
│   └── BankController.php          # API endpoints
└── Models/
    └── Bank.php                     # Bank model with scopes

database/
├── migrations/
│   └── *_create_banks_table.php    # Banks table structure
└── seeders/
    └── BankSeeder.php               # Sample bank data

resources/
├── js/
│   ├── app.js                       # Vue app initialization
│   └── components/
│       └── BankCalculator.vue       # Main calculator component
└── views/
    └── calculator.blade.php         # Calculator page

routes/
└── web.php                          # Routes including API endpoints
```

## Database Schema

### Banks Table
- `id`: Primary key
- `name`: Bank name
- `logo`: Logo URL (nullable)
- `apy`: Annual Percentage Yield (decimal 5,2)
- `minimum_deposit`: Minimum deposit required (decimal 12,2)
- `type`: 'sponsored' or 'low_rate'
- `rank`: Sort order (integer)
- `is_active`: Active status (boolean)
- `description`: Bank description (text)
- `website_url`: Bank website (string)
- `timestamps`: Created/updated timestamps

## API Endpoints

### GET /api/banks
Returns all banks grouped by type:
```json
{
    "sponsored": [...],
    "low_rate": [...]
}
```

### GET /api/banks/sponsored
Returns only sponsored banks

### GET /api/banks/low-rate
Returns only low-rate banks

### POST /api/banks/compare
Compares two banks and calculates savings

**Request:**
```json
{
    "sponsored_bank_id": 1,
    "low_rate_bank_id": 5,
    "initial_deposit": 10000,
    "years": 5
}
```

**Response:**
```json
{
    "sponsored_bank": {
        "name": "Jenius Bank",
        "apy": 5.25,
        "final_amount": 12968.71,
        "interest_earned": 2968.71
    },
    "low_rate_bank": {
        "name": "Chase Bank",
        "apy": 0.01,
        "final_amount": 10005.00,
        "interest_earned": 5.00
    },
    "difference": 2963.71,
    "initial_deposit": 10000,
    "years": 5
}
```

## Installation & Setup

### 1. Database Setup
Already completed:
```bash
php artisan migrate
php artisan db:seed --class=BankSeeder
```

### 2. Start Development Servers

**Terminal 1 - Laravel:**
```bash
php artisan serve
```

**Terminal 2 - Vite:**
```bash
npm run dev
```

### 3. Access the Calculator
Navigate to: `http://localhost:8000/calculator`

## Usage

### For End Users:

1. **Enter Initial Deposit**: Type the amount you want to save (e.g., $10,000)
2. **Select Time Period**: Choose how many years (1-50)
3. **Select Sponsored Bank**: Click on a high-yield bank from the left column
4. **Select Comparison Bank**: Click on a traditional bank from the right column
5. **Click Compare**: Hit the "Compare Banks" button
6. **View Results**: See the detailed comparison showing how much more you could earn

### Example Calculation:
- Initial Deposit: $10,000
- Time Period: 5 years
- Jenius Bank (5.25% APY): **$12,968.71** (+$2,968.71)
- Chase Bank (0.01% APY): **$10,005.00** (+$5.00)
- **Difference: $2,963.71 more with Jenius Bank!**

## Adding More Banks

### Via Database:
```php
Bank::create([
    'name' => 'New Bank Name',
    'apy' => 4.50,
    'minimum_deposit' => 100,
    'type' => 'sponsored', // or 'low_rate'
    'rank' => 5,
    'is_active' => true,
    'description' => 'Bank description',
    'website_url' => 'https://example.com',
]);
```

### Via Seeder:
Edit `database/seeders/BankSeeder.php` and add to the arrays, then run:
```bash
php artisan db:seed --class=BankSeeder
```

## Integrating with XML/API

To integrate with your existing bank rate XML/API, modify the BankController:

```php
// In BankController.php
public function syncBanksFromAPI()
{
    // Fetch from your XML/API
    $apiData = Http::get('your-api-endpoint')->json();
    
    foreach ($apiData as $bankData) {
        Bank::updateOrCreate(
            ['name' => $bankData['name']],
            [
                'apy' => $bankData['rate'],
                'type' => $bankData['is_sponsored'] ? 'sponsored' : 'low_rate',
                // ... other fields
            ]
        );
    }
}
```

Then schedule it to run periodically in `app/Console/Kernel.php`:
```php
protected function schedule(Schedule $schedule)
{
    $schedule->call([BankController::class, 'syncBanksFromAPI'])->daily();
}
```

## Customization

### Change Colors:
Edit `BankCalculator.vue` and modify the Tailwind classes:
- Sponsored banks: `from-green-50 to-emerald-50`, `border-green-500`
- Low-rate banks: `from-red-50 to-orange-50`, `border-red-500`

### Change Interest Calculation:
Modify the `calculateCompoundInterest` method in `BankController.php`:
```php
// Current: Annual compounding
$finalAmount = $principal * pow((1 + $rateDecimal), $years);

// For monthly compounding:
$finalAmount = $principal * pow((1 + $rateDecimal/12), $years * 12);
```

### Add More Fields:
1. Add column to migration
2. Add to `$fillable` in Bank model
3. Display in BankCalculator.vue template

## Testing

Test the API endpoints:

```bash
# Get all banks
curl http://localhost:8000/api/banks

# Compare banks
curl -X POST http://localhost:8000/api/banks/compare \
  -H "Content-Type: application/json" \
  -d '{
    "sponsored_bank_id": 1,
    "low_rate_bank_id": 5,
    "initial_deposit": 10000,
    "years": 5
  }'
```

## Troubleshooting

### Calculator not loading?
1. Make sure `npm run dev` is running
2. Hard refresh browser (Cmd+Shift+R / Ctrl+Shift+R)
3. Check browser console for errors

### No banks showing?
1. Verify migration ran: `php artisan migrate:status`
2. Check seeder ran: `php artisan db:seed --class=BankSeeder`
3. Verify database connection in `.env`

### API errors?
1. Check Laravel logs: `storage/logs/laravel.log`
2. Verify CSRF token is included in requests
3. Check network tab in browser dev tools

## Production Deployment

1. **Build assets:**
```bash
npm run build
```

2. **Optimize Laravel:**
```bash
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

3. **Set environment:**
```env
APP_ENV=production
APP_DEBUG=false
```

## Future Enhancements

- [ ] Add bank logos/images
- [ ] Graph visualization of growth over time
- [ ] Monthly contribution calculations
- [ ] Export results as PDF
- [ ] Email results functionality
- [ ] Compare multiple banks at once
- [ ] Historical rate tracking
- [ ] User accounts to save comparisons
- [ ] Social sharing functionality
- [ ] Mobile app version

## Credits

Built with:
- Laravel 12
- Vue.js 3 (Composition API)
- Tailwind CSS 4
- Vite
- Axios

## License

Proprietary - Bank Truth Calculator

---

**Need Help?** Check the troubleshooting section or review the inline code comments.

