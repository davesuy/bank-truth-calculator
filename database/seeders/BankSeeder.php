<?php

namespace Database\Seeders;

use App\Models\Bank;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class BankSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Sponsored Banks (Left Side - Higher Rates)
        $sponsoredBanks = [
            [
                'name' => 'Jenius Bank',
                'apy' => 5.25,
                'minimum_deposit' => 0,
                'type' => 'sponsored',
                'rank' => 1,
                'is_active' => true,
                'description' => 'High-yield savings with no minimum balance',
                'website_url' => 'https://www.jeniusbank.com',
            ],
            [
                'name' => 'CIT Bank',
                'apy' => 5.05,
                'minimum_deposit' => 100,
                'type' => 'sponsored',
                'rank' => 2,
                'is_active' => true,
                'description' => 'Platinum Savings with competitive rates',
                'website_url' => 'https://www.cit.com',
            ],
            [
                'name' => 'American Express Personal Savings',
                'apy' => 4.90,
                'minimum_deposit' => 0,
                'type' => 'sponsored',
                'rank' => 3,
                'is_active' => true,
                'description' => 'No fees, no minimum balance',
                'website_url' => 'https://www.americanexpress.com',
            ],
            [
                'name' => 'Marcus by Goldman Sachs',
                'apy' => 4.75,
                'minimum_deposit' => 0,
                'type' => 'sponsored',
                'rank' => 4,
                'is_active' => true,
                'description' => 'High-yield online savings account',
                'website_url' => 'https://www.marcus.com',
            ],
        ];

        // Low-Rate Banks (Right Side - Big Banks with Lower Rates)
        $lowRateBanks = [
            [
                'name' => 'Chase Bank',
                'apy' => 0.01,
                'minimum_deposit' => 0,
                'type' => 'low_rate',
                'rank' => 1,
                'is_active' => true,
                'description' => 'Traditional savings account',
                'website_url' => 'https://www.chase.com',
            ],
            [
                'name' => 'Bank of America',
                'apy' => 0.01,
                'minimum_deposit' => 100,
                'type' => 'low_rate',
                'rank' => 2,
                'is_active' => true,
                'description' => 'Standard savings account',
                'website_url' => 'https://www.bankofamerica.com',
            ],
            [
                'name' => 'Wells Fargo',
                'apy' => 0.15,
                'minimum_deposit' => 25,
                'type' => 'low_rate',
                'rank' => 3,
                'is_active' => true,
                'description' => 'Way2Save Savings Account',
                'website_url' => 'https://www.wellsfargo.com',
            ],
            [
                'name' => 'Citibank',
                'apy' => 0.25,
                'minimum_deposit' => 0,
                'type' => 'low_rate',
                'rank' => 4,
                'is_active' => true,
                'description' => 'Citi Savings Account',
                'website_url' => 'https://www.citi.com',
            ],
            [
                'name' => 'US Bank',
                'apy' => 0.01,
                'minimum_deposit' => 25,
                'type' => 'low_rate',
                'rank' => 5,
                'is_active' => true,
                'description' => 'Standard Savings Account',
                'website_url' => 'https://www.usbank.com',
            ],
        ];

        foreach ($sponsoredBanks as $bank) {
            Bank::create($bank);
        }

        foreach ($lowRateBanks as $bank) {
            Bank::create($bank);
        }
    }
}

