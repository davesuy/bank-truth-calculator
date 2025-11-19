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
            'years' => 'required|integer|min:1|max:10',
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
     * Calculate compound interest with monthly compounding
     * Formula: A = P(1 + r/12)^(12*t)
     * Where:
     * P = Principal
     * r = Annual interest rate (as decimal)
     * t = Number of years
     *
     * Note: Most savings accounts compound monthly, not annually
     */
    private function calculateCompoundInterest($principal, $rate, $years)
    {
        // Convert APY percentage to decimal
        $annualRate = $rate / 100;

        // Monthly interest rate
        $monthlyRate = $annualRate / 12;

        // Total number of months
        $totalMonths = $years * 12;

        // Compound interest formula with monthly compounding: A = P(1 + r/12)^(12*t)
        $finalAmount = $principal * pow((1 + $monthlyRate), $totalMonths);
        $interestEarned = $finalAmount - $principal;

        return [
            'final_amount' => round($finalAmount, 2),
            'interest_earned' => round($interestEarned, 2),
        ];
    }

    /**
     * Calculate compound interest with monthly contributions
     * Uses proper monthly compounding formula
     *
     * Formula:
     * FV = P(1+r)^n + PMT × [((1+r)^n - 1) / r]
     *
     * Where:
     * P = Principal (initial deposit)
     * PMT = Monthly payment (contribution)
     * r = Monthly interest rate
     * n = Total number of months
     *
     * This assumes:
     * - Interest compounds monthly (12 times per year)
     * - Monthly contributions are made at the END of each month
     * - APY is properly converted to APR first, then to monthly rate
     *
     * Note: Banks advertise APY (Annual Percentage Yield) which already includes
     * the effect of compounding. We must convert APY to APR (Annual Percentage Rate)
     * first to get the correct monthly rate.
     */
    private function calculateCompoundInterestWithContributions($principal, $monthlyContribution, $rate, $years)
    {
        // Convert APY percentage to decimal
        $apy = $rate / 100;

        // Convert APY to APR (Annual Percentage Rate)
        // APY = (1 + APR/n)^n - 1, solving for APR: APR = n * ((1 + APY)^(1/n) - 1)
        // where n = number of compounding periods per year (12 for monthly)
        $compoundingPeriods = 12;
        $apr = $compoundingPeriods * (pow((1 + $apy), (1 / $compoundingPeriods)) - 1);

        // Monthly interest rate from APR
        $monthlyRate = $apr / 12;

        // Total number of months
        $totalMonths = $years * 12;

        // Calculate future value of initial deposit with monthly compounding
        // FV = P * (1 + r/12)^(12*t)
        $futureValuePrincipal = $principal * pow((1 + $monthlyRate), $totalMonths);

        // Calculate future value of monthly contributions
        // FV of annuity = PMT × [((1+r)^n - 1) / r]
        $futureValueContributions = 0;
        if ($monthlyContribution > 0 && $monthlyRate > 0) {
            $futureValueContributions = $monthlyContribution *
                ((pow((1 + $monthlyRate), $totalMonths) - 1) / $monthlyRate);
        } elseif ($monthlyContribution > 0 && $monthlyRate == 0) {
            // Special case: if rate is 0%, just sum up contributions
            $futureValueContributions = $monthlyContribution * $totalMonths;
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
