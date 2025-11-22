#!/bin/bash
set -e

# Run migrations
echo "Running migrations..."
/app/bin/podcodar eval "Podcodar.Release.migrate"

# Start the application
echo "Starting Podcodar..."
exec /app/bin/podcodar "$@"
