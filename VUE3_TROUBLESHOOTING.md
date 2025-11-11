# Vue 3 Troubleshooting & Setup

## Recent Fixes Applied

### 1. Fixed vite.config.js
- Removed duplicate closing braces
- Added proper Vue alias resolution to use the full Vue build with template compiler

### 2. Simplified app.js
- Vite automatically handles script loading with proper timing
- No need for manual DOMContentLoaded listeners

## Testing Your Setup

### Step 1: Stop and Restart Dev Server
If you have `npm run dev` running, **stop it** (Ctrl+C) and restart:

```bash
npm run dev
```

### Step 2: Clear Browser Cache
- Hard refresh your browser (Cmd+Shift+R on Mac, Ctrl+Shift+R on Windows/Linux)
- Or open in incognito/private mode

### Step 3: Check Browser Console
Open your browser's developer console (F12) and look for:
- Any Vue warnings or errors
- Check if files are loading correctly in the Network tab

### Step 4: Visit the Demo Page
```
http://localhost:8000/vue-demo
```

## Common Issues in Laravel 12

### Issue: Component Not Rendering
**Symptoms:** The `<example-component>` tag shows in HTML but doesn't render

**Solutions:**
1. ✅ **Fixed:** Added Vue alias in vite.config.js to use the full compiler build
2. ✅ **Fixed:** Removed syntax errors from config files
3. Make sure dev server is running: `npm run dev`
4. Clear browser cache

### Issue: "Failed to resolve component"
**Solution:** The component name in the template must match the registered name:
- Template: `<example-component>`
- Registration: `app.component('example-component', ExampleComponent)`

### Issue: Vite Not Hot Reloading
**Solution:** 
```bash
# Stop the dev server and restart
npm run dev
```

## How It Should Work

1. **Vite loads** the JavaScript bundle
2. **Vue creates** the app instance
3. **Vue registers** the ExampleComponent
4. **Vue mounts** to `#app` div
5. **Vue compiles** the `<example-component>` tag
6. **Component renders** with its template

## Debugging Steps

### Check if Vue is Loading
Add this to your browser console:
```javascript
window.Vue
```
If it returns `undefined`, Vue isn't loading properly.

### Check if App is Mounting
In `resources/js/app.js`, temporarily add:
```javascript
app.mount('#app');
console.log('Vue mounted!', app);
```

### Verify Component Registration
```javascript
console.log(app._component.components);
```

## File Structure Reference

```
resources/
├── js/
│   ├── app.js                          # Vue initialization
│   ├── bootstrap.js                    # Axios setup
│   └── components/
│       └── ExampleComponent.vue        # Your component
└── views/
    └── vue-demo.blade.php              # Demo page

vite.config.js                          # Vite configuration
```

## Working Example

After fixes, your setup should now work! The key changes were:

1. **vite.config.js**: Added Vue alias for full compiler
2. **No more syntax errors**: Removed duplicate braces

## Still Not Working?

If you're still having issues:

1. Delete `node_modules` and reinstall:
   ```bash
   rm -rf node_modules
   npm install
   ```

2. Clear all caches:
   ```bash
   php artisan cache:clear
   php artisan view:clear
   php artisan config:clear
   ```

3. Restart everything:
   ```bash
   npm run dev
   php artisan serve
   ```

4. Check the browser console for specific error messages

