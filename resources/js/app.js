import './bootstrap';
import { createApp } from 'vue';

// Import your Vue components here
import ExampleComponent from './components/ExampleComponent.vue';
import BankCalculator from './components/BankCalculator.vue';

const app = createApp({});

// Register components
app.component('example-component', ExampleComponent);
app.component('bank-calculator', BankCalculator);

app.mount('#app');

