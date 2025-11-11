#!/usr/bin/env bash

# Start Apache server with Heroku PHP buildpack
# This is called by Render when using env: php
exec vendor/bin/heroku-php-apache2 public/

