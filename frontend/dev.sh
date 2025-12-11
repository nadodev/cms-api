#!/bin/sh
# Development script with forced polling for Docker/Windows

# Force polling with very short intervals
export WATCHPACK_POLLING=true
export CHOKIDAR_USEPOLLING=true
export CHOKIDAR_INTERVAL=500
export NODE_ENV=development

# Start Next.js with explicit polling
exec npm run dev
