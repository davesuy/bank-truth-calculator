<template>
    <div class="bank-calculator max-w-7xl mx-auto p-6">
        <div class="text-center mb-8">
            <h1 class="text-4xl font-bold text-gray-900 mb-2">Bank Savings Comparison Calculator</h1>
            <p class="text-lg text-gray-600">Compare high-yield savings banks with traditional big banks</p>
        </div>

        <!-- Calculator Inputs -->
        <div class="bg-white rounded-lg shadow-lg p-6 mb-6">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        Initial Deposit Amount
                    </label>
                    <div class="relative">
                        <span class="absolute left-3 top-3 text-gray-500">$</span>
                        <input
                            v-model.number="initialDeposit"
                            type="number"
                            min="0"
                            step="100"
                            class="w-full pl-8 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                            placeholder="10000"
                        />
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        Monthly Contribution
                    </label>
                    <div class="relative">
                        <span class="absolute left-3 top-3 text-gray-500">$</span>
                        <input
                            v-model.number="monthlyContribution"
                            type="number"
                            min="0"
                            step="10"
                            class="w-full pl-8 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                            placeholder="0"
                        />
                    </div>
                    <p class="text-xs text-gray-500 mt-1">Optional: Add regular deposits</p>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        Number of Years
                    </label>
                    <input
                        v-model.number="years"
                        type="number"
                        min="1"
                        max="50"
                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                        placeholder="5"
                    />
                </div>
            </div>
        </div>

        <!-- Bank Selection -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
            <!-- Sponsored Banks (Left) -->
            <div class="bg-gradient-to-br from-green-50 to-emerald-50 rounded-lg shadow-lg p-6">
                <div class="flex items-center justify-between mb-4">
                    <h2 class="text-2xl font-bold text-green-800">High-Yield Banks</h2>
                    <span class="bg-green-500 text-white px-3 py-1 rounded-full text-sm font-semibold">Sponsored</span>
                </div>
                <p class="text-gray-600 mb-4">Select a high-yield savings account</p>

                <div class="space-y-3">
                    <div
                        v-for="bank in sponsoredBanks"
                        :key="bank.id"
                        @click="selectedSponsored = bank"
                        class="bank-card cursor-pointer p-4 bg-white rounded-lg border-2 transition-all hover:shadow-md"
                        :class="selectedSponsored?.id === bank.id ? 'border-green-500 ring-2 ring-green-200' : 'border-gray-200'"
                    >
                        <div class="flex justify-between items-start">
                            <div>
                                <h3 class="font-bold text-lg text-gray-900">{{ bank.name }}</h3>
                                <p class="text-sm text-gray-600">Min. Deposit: ${{ formatNumber(bank.minimum_deposit) }}</p>
                            </div>
                            <div class="text-right">
                                <div class="text-2xl font-bold text-green-600">{{ bank.apy }}%</div>
                                <div class="text-xs text-gray-500">APY</div>
                            </div>
                        </div>
                        <div v-if="selectedSponsored?.id === bank.id" class="mt-2">
                            <span class="inline-flex items-center text-green-600 text-sm font-medium">
                                <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                                </svg>
                                Selected
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Low Rate Banks (Right) -->
            <div class="bg-gradient-to-br from-red-50 to-orange-50 rounded-lg shadow-lg p-6">
                <div class="flex items-center justify-between mb-4">
                    <h2 class="text-2xl font-bold text-red-800">Traditional Big Banks</h2>
                    <span class="bg-red-500 text-white px-3 py-1 rounded-full text-sm font-semibold">Low Rates</span>
                </div>
                <p class="text-gray-600 mb-4">Select a traditional bank for comparison</p>

                <div class="space-y-3">
                    <div
                        v-for="bank in lowRateBanks"
                        :key="bank.id"
                        @click="selectedLowRate = bank"
                        class="bank-card cursor-pointer p-4 bg-white rounded-lg border-2 transition-all hover:shadow-md"
                        :class="selectedLowRate?.id === bank.id ? 'border-red-500 ring-2 ring-red-200' : 'border-gray-200'"
                    >
                        <div class="flex justify-between items-start">
                            <div>
                                <h3 class="font-bold text-lg text-gray-900">{{ bank.name }}</h3>
                                <p class="text-sm text-gray-600">Min. Deposit: ${{ formatNumber(bank.minimum_deposit) }}</p>
                            </div>
                            <div class="text-right">
                                <div class="text-2xl font-bold text-red-600">{{ bank.apy }}%</div>
                                <div class="text-xs text-gray-500">APY</div>
                            </div>
                        </div>
                        <div v-if="selectedLowRate?.id === bank.id" class="mt-2">
                            <span class="inline-flex items-center text-red-600 text-sm font-medium">
                                <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                                </svg>
                                Selected
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Compare Button -->
        <div class="text-center mb-6">
            <button
                @click="compareRates"
                :disabled="!canCompare"
                class="px-8 py-4 bg-blue-600 text-white font-bold text-lg rounded-lg hover:bg-blue-700 disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors shadow-lg hover:shadow-xl"
            >
                <span v-if="loading">Calculating...</span>
                <span v-else>Compare Banks</span>
            </button>
        </div>

        <!-- Results -->
        <div v-if="comparisonResult" class="bg-white rounded-lg shadow-xl p-8">
            <h2 class="text-3xl font-bold text-center text-gray-900 mb-8">Comparison Results</h2>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                <!-- Sponsored Bank Result -->
                <div class="bg-gradient-to-br from-green-100 to-emerald-100 rounded-lg p-6">
                    <h3 class="text-xl font-bold text-green-800 mb-4">{{ comparisonResult.sponsored_bank.name }}</h3>
                    <div class="space-y-3">
                        <div>
                            <div class="text-sm text-gray-600">APY</div>
                            <div class="text-2xl font-bold text-green-700">{{ comparisonResult.sponsored_bank.apy }}%</div>
                        </div>
                        <div>
                            <div class="text-sm text-gray-600">Final Amount</div>
                            <div class="text-3xl font-bold text-gray-900">${{ formatNumber(comparisonResult.sponsored_bank.final_amount) }}</div>
                        </div>
                        <div>
                            <div class="text-sm text-gray-600">Interest Earned</div>
                            <div class="text-2xl font-bold text-green-600">${{ formatNumber(comparisonResult.sponsored_bank.interest_earned) }}</div>
                        </div>
                    </div>
                </div>

                <!-- Low Rate Bank Result -->
                <div class="bg-gradient-to-br from-red-100 to-orange-100 rounded-lg p-6">
                    <h3 class="text-xl font-bold text-red-800 mb-4">{{ comparisonResult.low_rate_bank.name }}</h3>
                    <div class="space-y-3">
                        <div>
                            <div class="text-sm text-gray-600">APY</div>
                            <div class="text-2xl font-bold text-red-700">{{ comparisonResult.low_rate_bank.apy }}%</div>
                        </div>
                        <div>
                            <div class="text-sm text-gray-600">Final Amount</div>
                            <div class="text-3xl font-bold text-gray-900">${{ formatNumber(comparisonResult.low_rate_bank.final_amount) }}</div>
                        </div>
                        <div>
                            <div class="text-sm text-gray-600">Interest Earned</div>
                            <div class="text-2xl font-bold text-red-600">${{ formatNumber(comparisonResult.low_rate_bank.interest_earned) }}</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Difference Highlight -->
            <div class="bg-gradient-to-r from-blue-500 to-purple-600 rounded-lg p-6 text-white text-center">
                <h3 class="text-xl font-semibold mb-2">You Could Earn More</h3>
                <div class="text-5xl font-bold mb-2">${{ formatNumber(comparisonResult.difference) }}</div>
                <p class="text-lg">
                    with {{ comparisonResult.sponsored_bank.name }} over {{ comparisonResult.years }} years
                </p>
                <p class="text-sm mt-2 opacity-90">
                    Based on ${{ formatNumber(comparisonResult.initial_deposit) }} initial deposit
                    <span v-if="comparisonResult.monthly_contribution > 0">
                        + ${{ formatNumber(comparisonResult.monthly_contribution) }}/month
                    </span>
                </p>
                <p v-if="comparisonResult.total_contributions" class="text-sm mt-1 opacity-90">
                    Total contributions: ${{ formatNumber(comparisonResult.total_contributions) }}
                </p>
            </div>
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="text-center py-8">
            <div class="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        </div>

        <!-- Error Message -->
        <div v-if="error" class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
            <strong class="font-bold">Error!</strong>
            <span class="block sm:inline">{{ error }}</span>
        </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import axios from 'axios';

const sponsoredBanks = ref([]);
const lowRateBanks = ref([]);
const selectedSponsored = ref(null);
const selectedLowRate = ref(null);
const initialDeposit = ref(10000);
const monthlyContribution = ref(0);
const years = ref(5);
const comparisonResult = ref(null);
const loading = ref(false);
const error = ref(null);

const canCompare = computed(() => {
    return selectedSponsored.value &&
           selectedLowRate.value &&
           initialDeposit.value > 0 &&
           years.value > 0 &&
           !loading.value;
});

const formatNumber = (value) => {
    return new Intl.NumberFormat('en-US', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
    }).format(value);
};

const loadBanks = async () => {
    try {
        loading.value = true;
        error.value = null;
        const response = await axios.get('/api/banks');
        sponsoredBanks.value = response.data.sponsored;
        lowRateBanks.value = response.data.low_rate;

        // Auto-select first banks
        if (sponsoredBanks.value.length > 0) {
            selectedSponsored.value = sponsoredBanks.value[0];
        }
        if (lowRateBanks.value.length > 0) {
            selectedLowRate.value = lowRateBanks.value[0];
        }
    } catch (err) {
        error.value = 'Failed to load banks. Please refresh the page.';
        console.error('Error loading banks:', err);
    } finally {
        loading.value = false;
    }
};

const compareRates = async () => {
    if (!canCompare.value) return;

    try {
        loading.value = true;
        error.value = null;

        const response = await axios.post('/api/banks/compare', {
            sponsored_bank_id: selectedSponsored.value.id,
            low_rate_bank_id: selectedLowRate.value.id,
            initial_deposit: initialDeposit.value,
            monthly_contribution: monthlyContribution.value || 0,
            years: years.value,
        });

        comparisonResult.value = response.data;

        // Scroll to results
        setTimeout(() => {
            const resultsElement = document.querySelector('.bg-white.rounded-lg.shadow-xl');
            if (resultsElement) {
                resultsElement.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
            }
        }, 100);
    } catch (err) {
        error.value = err.response?.data?.message || 'Failed to compare banks. Please try again.';
        console.error('Error comparing banks:', err);
    } finally {
        loading.value = false;
    }
};

onMounted(() => {
    loadBanks();
});
</script>

<style scoped>
.bank-card {
    transition: all 0.2s ease-in-out;
}

.bank-card:hover {
    transform: translateY(-2px);
}
</style>

