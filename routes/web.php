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
        return view('calculator');
    } catch (\Exception $e) {
        // Fallback if view has issues
        return response()->json([
            'error' => 'View error',
            'message' => $e->getMessage(),
            'file' => $e->getFile(),
            'line' => $e->getLine(),
        ], 500);
    }
});

// API Routes
Route::prefix('api')->group(function () {
    Route::get('/banks', [BankController::class, 'getAllBanks']);
    Route::get('/banks/sponsored', [BankController::class, 'getSponsored']);
    Route::get('/banks/low-rate', [BankController::class, 'getLowRate']);
    Route::post('/banks/compare', [BankController::class, 'compare']);
});

