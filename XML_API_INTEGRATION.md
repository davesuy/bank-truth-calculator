# XML/API Integration Guide

## How to Connect Your Bank Rate Feed

Since you mentioned getting rates via XML/API that rotate, here's how to integrate that into the calculator.

---

## Option 1: Create a Sync Command

### Step 1: Create the Command
```bash
php artisan make:command SyncBankRates
```

### Step 2: Implement the Sync Logic

Edit `app/Console/Commands/SyncBankRates.php`:

```php
<?php

namespace App\Console\Commands;

use App\Models\Bank;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Http;

class SyncBankRates extends Command
{
    protected $signature = 'sync:bank-rates';
    protected $description = 'Sync bank rates from XML/API feed';

    public function handle()
    {
        $this->info('Starting bank rate sync...');

        try {
            // Option A: If you have an XML feed
            $this->syncFromXML();
            
            // Option B: If you have a JSON API
            // $this->syncFromAPI();
            
            $this->info('Bank rates synced successfully!');
        } catch (\Exception $e) {
            $this->error('Sync failed: ' . $e->getMessage());
        }
    }

    private function syncFromXML()
    {
        // Fetch XML from your feed
        $xmlUrl = config('services.bank_rates.xml_url');
        $xmlContent = file_get_contents($xmlUrl);
        $xml = simplexml_load_string($xmlContent);

        foreach ($xml->bank as $bankData) {
            Bank::updateOrCreate(
                ['name' => (string)$bankData->name],
                [
                    'apy' => (float)$bankData->apy,
                    'minimum_deposit' => (float)$bankData->minimum_deposit ?? 0,
                    'type' => $this->determineType($bankData),
                    'rank' => (int)$bankData->rank ?? 0,
                    'is_active' => (bool)$bankData->is_active ?? true,
                    'description' => (string)$bankData->description ?? '',
                    'website_url' => (string)$bankData->website_url ?? '',
                    'logo' => (string)$bankData->logo ?? null,
                ]
            );
        }
    }

    private function syncFromAPI()
    {
        // Fetch from your JSON API
        $apiUrl = config('services.bank_rates.api_url');
        $apiKey = config('services.bank_rates.api_key');

        $response = Http::withHeaders([
            'Authorization' => 'Bearer ' . $apiKey,
            'Accept' => 'application/json',
        ])->get($apiUrl);

        if ($response->successful()) {
            $banks = $response->json('data');

            foreach ($banks as $bankData) {
                Bank::updateOrCreate(
                    ['name' => $bankData['name']],
                    [
                        'apy' => $bankData['apy'],
                        'minimum_deposit' => $bankData['minimum_deposit'] ?? 0,
                        'type' => $this->determineType($bankData),
                        'rank' => $bankData['rank'] ?? 0,
                        'is_active' => $bankData['is_active'] ?? true,
                        'description' => $bankData['description'] ?? '',
                        'website_url' => $bankData['website_url'] ?? '',
                        'logo' => $bankData['logo'] ?? null,
                    ]
                );
            }
        }
    }

    private function determineType($bankData)
    {
        // Your logic to determine if a bank is sponsored or low-rate
        // Example:
        if (isset($bankData->is_sponsored) && $bankData->is_sponsored) {
            return 'sponsored';
        }
        
        if (isset($bankData['is_sponsored']) && $bankData['is_sponsored']) {
            return 'sponsored';
        }

        // Or based on APY threshold
        $apy = is_object($bankData) ? (float)$bankData->apy : $bankData['apy'];
        return $apy >= 2.0 ? 'sponsored' : 'low_rate';
    }
}
```

### Step 3: Add Configuration

Edit `config/services.php`:

```php
'bank_rates' => [
    'xml_url' => env('BANK_RATES_XML_URL'),
    'api_url' => env('BANK_RATES_API_URL'),
    'api_key' => env('BANK_RATES_API_KEY'),
],
```

Edit `.env`:

```env
BANK_RATES_XML_URL=https://your-api.com/bank-rates.xml
BANK_RATES_API_URL=https://your-api.com/api/bank-rates
BANK_RATES_API_KEY=your-api-key-here
```

### Step 4: Schedule the Sync

Edit `app/Console/Kernel.php`:

```php
<?php

namespace App\Console;

use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel
{
    protected function schedule(Schedule $schedule): void
    {
        // Sync bank rates every hour
        $schedule->command('sync:bank-rates')->hourly();
        
        // Or sync daily at 2 AM
        // $schedule->command('sync:bank-rates')->dailyAt('2:00');
        
        // Or sync every 15 minutes during business hours
        // $schedule->command('sync:bank-rates')
        //          ->everyFifteenMinutes()
        //          ->between('9:00', '17:00');
    }

    protected function commands(): void
    {
        $this->load(__DIR__.'/Commands');

        require base_path('routes/console.php');
    }
}
```

### Step 5: Run Manually

```bash
# Test the sync
php artisan sync:bank-rates

# Or run the scheduler (for testing)
php artisan schedule:run
```

### Step 6: Setup Cron (Production)

Add to your server's crontab:

```bash
* * * * * cd /path-to-your-project && php artisan schedule:run >> /dev/null 2>&1
```

---

## Option 2: Direct API Integration in Controller

If you want to fetch rates on-demand instead of storing them:

Edit `app/Http/Controllers/BankController.php`:

```php
public function getAllBanks()
{
    // Fetch fresh data from your API
    $apiData = $this->fetchFromAPI();
    
    // Transform to your format
    $sponsored = collect($apiData)
        ->where('is_sponsored', true)
        ->map(function($bank) {
            return [
                'id' => $bank['id'],
                'name' => $bank['name'],
                'apy' => $bank['apy'],
                'minimum_deposit' => $bank['minimum_deposit'] ?? 0,
                'type' => 'sponsored',
                // ... other fields
            ];
        })
        ->values();

    $lowRate = collect($apiData)
        ->where('is_sponsored', false)
        ->map(function($bank) {
            return [
                'id' => $bank['id'],
                'name' => $bank['name'],
                'apy' => $bank['apy'],
                'minimum_deposit' => $bank['minimum_deposit'] ?? 0,
                'type' => 'low_rate',
                // ... other fields
            ];
        })
        ->values();

    return response()->json([
        'sponsored' => $sponsored,
        'low_rate' => $lowRate,
    ]);
}

private function fetchFromAPI()
{
    $response = Http::withHeaders([
        'Authorization' => 'Bearer ' . config('services.bank_rates.api_key'),
    ])->get(config('services.bank_rates.api_url'));

    return $response->json('data');
}
```

---

## Option 3: Webhook Integration

If your API sends webhooks when rates change:

### Create Webhook Controller

```bash
php artisan make:controller WebhookController
```

```php
<?php

namespace App\Http\Controllers;

use App\Models\Bank;
use Illuminate\Http\Request;

class WebhookController extends Controller
{
    public function handleBankRateUpdate(Request $request)
    {
        // Verify webhook signature (if your API provides one)
        if (!$this->verifySignature($request)) {
            return response()->json(['error' => 'Invalid signature'], 403);
        }

        $data = $request->all();

        Bank::updateOrCreate(
            ['name' => $data['bank_name']],
            [
                'apy' => $data['apy'],
                'minimum_deposit' => $data['minimum_deposit'] ?? 0,
                'type' => $data['is_sponsored'] ? 'sponsored' : 'low_rate',
                'is_active' => $data['is_active'] ?? true,
            ]
        );

        return response()->json(['success' => true]);
    }

    private function verifySignature(Request $request)
    {
        $signature = $request->header('X-Signature');
        $payload = $request->getContent();
        $secret = config('services.bank_rates.webhook_secret');

        $expected = hash_hmac('sha256', $payload, $secret);

        return hash_equals($expected, $signature);
    }
}
```

Add route in `routes/web.php`:

```php
Route::post('/webhook/bank-rates', [WebhookController::class, 'handleBankRateUpdate'])
     ->name('webhook.bank-rates');
```

---

## Example XML Structure

If your XML looks like this:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<banks>
    <bank>
        <name>Jenius Bank</name>
        <apy>5.25</apy>
        <minimum_deposit>0</minimum_deposit>
        <is_sponsored>true</is_sponsored>
        <rank>1</rank>
        <description>High-yield savings with no minimum balance</description>
        <website_url>https://www.jeniusbank.com</website_url>
        <logo>https://cdn.example.com/logos/jenius.png</logo>
    </bank>
    <bank>
        <name>Chase Bank</name>
        <apy>0.01</apy>
        <minimum_deposit>0</minimum_deposit>
        <is_sponsored>false</is_sponsored>
        <rank>1</rank>
        <description>Traditional savings account</description>
        <website_url>https://www.chase.com</website_url>
        <logo>https://cdn.example.com/logos/chase.png</logo>
    </bank>
</banks>
```

---

## Example JSON API Response

If your API returns JSON like this:

```json
{
    "data": [
        {
            "id": 1,
            "name": "Jenius Bank",
            "apy": 5.25,
            "minimum_deposit": 0,
            "is_sponsored": true,
            "rank": 1,
            "description": "High-yield savings with no minimum balance",
            "website_url": "https://www.jeniusbank.com",
            "logo": "https://cdn.example.com/logos/jenius.png",
            "is_active": true
        },
        {
            "id": 2,
            "name": "Chase Bank",
            "apy": 0.01,
            "minimum_deposit": 0,
            "is_sponsored": false,
            "rank": 1,
            "description": "Traditional savings account",
            "website_url": "https://www.chase.com",
            "logo": "https://cdn.example.com/logos/chase.png",
            "is_active": true
        }
    ]
}
```

---

## Testing Your Integration

```bash
# Test the sync command
php artisan sync:bank-rates

# Check if banks were imported
php artisan tinker
>>> Bank::count()
>>> Bank::sponsored()->get()
>>> Bank::lowRate()->get()

# Test the API endpoint
curl http://localhost:8000/api/banks
```

---

## Caching for Performance

Add caching to reduce API calls:

```php
public function getAllBanks()
{
    return Cache::remember('banks_all', 3600, function () {
        $sponsored = Bank::sponsored()->get();
        $lowRate = Bank::lowRate()->get();

        return response()->json([
            'sponsored' => $sponsored,
            'low_rate' => $lowRate,
        ]);
    });
}

// Clear cache when syncing
public function handle()
{
    // ... sync logic ...
    
    Cache::forget('banks_all');
}
```

---

## Monitoring & Logging

Add logging to track syncs:

```php
use Illuminate\Support\Facades\Log;

public function handle()
{
    Log::info('Starting bank rate sync');
    
    try {
        $count = $this->syncFromAPI();
        Log::info("Successfully synced {$count} banks");
    } catch (\Exception $e) {
        Log::error('Bank sync failed', [
            'error' => $e->getMessage(),
            'trace' => $e->getTraceAsString()
        ]);
        throw $e;
    }
}
```

---

## Next Steps

1. **Identify your XML/API format**
2. **Create the sync command**
3. **Test manually first**
4. **Schedule automatic syncs**
5. **Monitor and log**
6. **Add caching for performance**

Your calculator will automatically show the latest rates from your feed!

