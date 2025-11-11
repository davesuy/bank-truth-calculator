#!/usr/bin/env bash

# Start PHP built-in server
# The PORT environment variable is provided by Render
exec /usr/local/bin/php -S 0.0.0.0:${PORT:-8000} -t public public/index.php

