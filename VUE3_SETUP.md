# Vue 3 Installation Guide

## What Was Installed

Vue 3 has been successfully installed in your Laravel project with the following packages:

- **vue**: ^3.5.24 - The Vue 3 framework
- **@vitejs/plugin-vue**: ^6.0.1 - Official Vite plugin for Vue 3

## Files Modified/Created

### Configuration Files
- **vite.config.js** - Added Vue plugin configuration
- **package.json** - Added Vue 3 dependencies

### JavaScript Files
- **resources/js/app.js** - Initialized Vue 3 application
- **resources/js/components/ExampleComponent.vue** - Example Vue component using Composition API

### Laravel Files
- **resources/views/vue-demo.blade.php** - Demo page to test Vue 3
- **routes/web.php** - Added `/vue-demo` route

## How to Use

### 1. Start the Development Server

```bash
npm run dev
```

This will start Vite's development server with hot module replacement (HMR).

### 2. Start Laravel Server

In a separate terminal:

```bash
php artisan serve
```

### 3. View the Demo

Visit `http://localhost:8000/vue-demo` to see the example Vue component in action.

## Creating New Vue Components

### Using Composition API (Recommended)

Create a new `.vue` file in `resources/js/components/`:

```vue
<template>
    <div>
        <h1>{{ message }}</h1>
        <button @click="increment">Count: {{ count }}</button>
    </div>
</template>

<script setup>
import { ref } from 'vue';

const message = ref('Hello Vue 3!');
const count = ref(0);

const increment = () => {
    count.value++;
};
</script>

<style scoped>
/* Component styles */
</style>
```

### Register Your Component

In `resources/js/app.js`:

```javascript
import YourComponent from './components/YourComponent.vue';

app.component('your-component', YourComponent);
```

### Use in Blade Templates

```blade
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Your Page</title>
    @vite(['resources/css/app.css', 'resources/js/app.js'])
</head>
<body>
    <div id="app">
        <your-component></your-component>
    </div>
</body>
</html>
```

## Building for Production

To build your assets for production:

```bash
npm run build
```

## Additional Resources

- [Vue 3 Documentation](https://vuejs.org/)
- [Vue 3 Composition API](https://vuejs.org/guide/extras/composition-api-faq.html)
- [Vite Documentation](https://vitejs.dev/)
- [Laravel Vite Documentation](https://laravel.com/docs/vite)

## Notes

- The example component uses Vue 3's Composition API with `<script setup>` syntax
- Tailwind CSS is already configured and can be used in your Vue components
- Hot Module Replacement (HMR) is enabled for fast development

