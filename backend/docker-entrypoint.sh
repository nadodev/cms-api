#!/bin/bash
set -e

# Fix permissions for storage and cache directories (run as root)
if [ -d /var/www/html/storage ]; then
    chown -R www-data:www-data /var/www/html/storage 2>/dev/null || true
    chmod -R 775 /var/www/html/storage 2>/dev/null || true
fi

if [ -d /var/www/html/bootstrap/cache ]; then
    chown -R www-data:www-data /var/www/html/bootstrap/cache 2>/dev/null || true
    chmod -R 775 /var/www/html/bootstrap/cache 2>/dev/null || true
fi

# PHP-FPM must run as root (it manages child processes as www-data)
# For other commands (like artisan), run as www-data
if [ "$1" = "php-fpm" ] || [ "$1" = "php-fpm-7.4" ] || [ "$1" = "php-fpm8.4" ]; then
    exec "$@"
else
    # For artisan and other commands, run as www-data
    exec gosu www-data "$@"
fi

