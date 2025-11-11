<?php

namespace App\Http\Controllers;

use App\Models\Bank;
use Illuminate\Http\Request;

class BankController extends Controller
{
    /**
     * Get all sponsored banks
     */
    public function getSponsored()
    {
        $banks = Bank::sponsored()->get();
        return response()->json($banks);
    }

    /**
     * Get all low-rate banks
     */
    public function getLowRate()
    {
        $banks = Bank::lowRate()->get();
        return response()->json($banks);
    }

    /**
     * Get all banks grouped by type
     */
    public function getAllBanks()
    {
        $sponsored = Bank::sponsored()->get();
        $lowRate = Bank::lowRate()->get();

        return response()->json([
            'sponsored' => $sponsored,
            'low_rate' => $lowRate,
        ]);
    }

    /**
     * Calculate comparison between two banks
     */
    public function compare(Request $request)
    {
        $request->validate([
            'sponsored_bank_id' => 'required|exists:banks,id',
            'low_rate_bank_id' => 'required|exists:banks,id',
            'initial_deposit' => 'required|numeric|min:0',
            'monthly_contribution' => 'nullable|numeric|min:0',
            'years' => 'required|integer|min:1|max:50',
        ]);

        $sponsoredBank = Bank::findOrFail($request->sponsored_bank_id);
        $lowRateBank = Bank::findOrFail($request->low_rate_bank_id);
        $initialDeposit = $request->initial_deposit;
        $monthlyContribution = $request->monthly_contribution ?? 0;
        $years = $request->years;

        // Calculate compound interest for both banks with monthly contributions
        $sponsoredResult = $this->calculateCompoundInterestWithContributions(
            $initialDeposit,
            $monthlyContribution,
            $sponsoredBank->apy,
            $years
        );
        $lowRateResult = $this->calculateCompoundInterestWithContributions(
            $initialDeposit,
            $monthlyContribution,
            $lowRateBank->apy,
            $years
        );

        $difference = $sponsoredResult['final_amount'] - $lowRateResult['final_amount'];
        $totalContributions = $initialDeposit + ($monthlyContribution * 12 * $years);

        return response()->json([
            'sponsored_bank' => [
                'name' => $sponsoredBank->name,
                'apy' => $sponsoredBank->apy,
                'final_amount' => $sponsoredResult['final_amount'],
                'interest_earned' => $sponsoredResult['interest_earned'],
            ],
            'low_rate_bank' => [
                'name' => $lowRateBank->name,
                'apy' => $lowRateBank->apy,
                'final_amount' => $lowRateResult['final_amount'],
                'interest_earned' => $lowRateResult['interest_earned'],
            ],
            'difference' => $difference,
            'initial_deposit' => $initialDeposit,
            'monthly_contribution' => $monthlyContribution,
            'total_contributions' => $totalContributions,
            'years' => $years,
        ]);
    }

    /**
     * Calculate compound interest
     */
    private function calculateCompoundInterest($principal, $rate, $years)
    {
        // Convert APY percentage to decimal
        $rateDecimal = $rate / 100;

        // Compound interest formula: A = P(1 + r)^t
        $finalAmount = $principal * pow((1 + $rateDecimal), $years);
        $interestEarned = $finalAmount - $principal;

        return [
            'final_amount' => round($finalAmount, 2),
            'interest_earned' => round($interestEarned, 2),
        ];
    }

    /**
     * Calculate compound interest with monthly contributions
     * Formula: FV = P(1+r)^t + PMT × [((1+r)^t - 1) / r]
     * Where:
     * P = Principal (initial deposit)
     * PMT = Monthly payment (contribution)
     * r = Annual interest rate (as decimal)
     * t = Number of years
     */
    private function calculateCompoundInterestWithContributions($principal, $monthlyContribution, $rate, $years)
    {
        // Convert APY percentage to decimal
        $annualRate = $rate / 100;

        // Calculate future value of initial deposit
        $futureValuePrincipal = $principal * pow((1 + $annualRate), $years);

        // Calculate future value of monthly contributions
        $futureValueContributions = 0;
        if ($monthlyContribution > 0) {
            // For monthly contributions with annual compounding
            // We need to calculate each month's contribution growing at the annual rate
            $monthsTotal = $years * 12;

            for ($month = 0; $month < $monthsTotal; $month++) {
                $yearsRemaining = ($monthsTotal - $month) / 12;
                $futureValueContributions += $monthlyContribution * pow((1 + $annualRate), $yearsRemaining);
            }
        }

        $finalAmount = $futureValuePrincipal + $futureValueContributions;
        $totalContributions = $principal + ($monthlyContribution * 12 * $years);
        $interestEarned = $finalAmount - $totalContributions;

        return [
            'final_amount' => round($finalAmount, 2),
            'interest_earned' => round($interestEarned, 2),
            'total_contributions' => round($totalContributions, 2),
        ];
    }
}
