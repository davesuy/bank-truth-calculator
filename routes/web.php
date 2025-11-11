<?php

use App\Http\Controllers\BankController;
use Illuminate\Support\Facades\Route;

// Test route to verify app is working
Route::get('/test', function () {
    return response()->json([
        'status' => 'ok',
        'message' => 'Laravel is working!',
        'env' => config('app.env'),
        'debug' => config('app.debug'),
        'time' => now()->toDateTimeString(),
    ]);
});

// Health check route
Route::get('/health', function () {
    try {
        // Check database
        $dbCheck = \DB::connection()->getPdo() ? 'ok' : 'failed';

        // Check storage writeable
        $storageWriteable = is_writable(storage_path()) ? 'ok' : 'failed';

        // Check if build assets exist
        $manifestExists = file_exists(public_path('build/manifest.json')) ? 'ok' : 'missing';

        return response()->json([
            'status' => 'healthy',
            'database' => $dbCheck,
            'storage' => $storageWriteable,
            'manifest' => $manifestExists,
            'manifest_path' => public_path('build/manifest.json'),
        ]);
    } catch (\Exception $e) {
        return response()->json([
            'status' => 'unhealthy',
            'error' => $e->getMessage(),
        ], 500);
    }
});

Route::get('/', function () {
    try {
        // Try to load calculator view with Vite assets
        return view('calculator');
    } catch (\Exception $e) {
        // If that fails, check if it's a Vite issue
        if (str_contains($e->getMessage(), 'Vite') || str_contains($e->getMessage(), 'manifest')) {
            // Show simple welcome page without Vite
            return view('welcome-simple');
        }

        // For other errors, show detailed error info (debug mode)
        return response()->json([
            'error' => 'View error',
            'message' => $e->getMessage(),
            'file' => $e->getFile(),
            'line' => $e->getLine(),
            'trace' => config('app.debug') ? $e->getTraceAsString() : 'Enable debug mode to see trace',
        ], 500);
    }
});

// Simple welcome route (no Vite dependencies)
Route::get('/welcome', function () {
    return view('welcome-simple');
});

// Dedicated calculator route (tries to load Vue calculator)
Route::get('/calculator', function () {
    return view('calculator');
});

// API Routes
Route::prefix('api')->group(function () {
    Route::get('/banks', [BankController::class, 'getAllBanks']);
    Route::get('/banks/sponsored', [BankController::class, 'getSponsored']);
    Route::get('/banks/low-rate', [BankController::class, 'getLowRate']);
    Route::post('/banks/compare', [BankController::class, 'compare']);
});

