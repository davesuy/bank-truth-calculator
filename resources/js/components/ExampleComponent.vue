<template>
    <div class="p-6 bg-white rounded-lg shadow-lg">
        <h2 class="text-2xl font-bold mb-4">{{ message }}</h2>
        <button
            @click="incrementCount"
            class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
        >
            Clicked {{ count }} times
        </button>
    </div>
</template>

<script setup>
import { ref } from 'vue';

const message = ref('Hello from Vue 3!');
const count = ref(0);

const incrementCount = () => {
    count.value++;
};
</script>

<style scoped>
/* Component-specific styles */
</style>

