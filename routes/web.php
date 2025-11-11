<?php

use App\Http\Controllers\BankController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('calculator');
});

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

