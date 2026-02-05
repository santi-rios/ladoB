#!/bin/bash
set -e

echo "=== AzuraCast Heroku Startup ==="

# Heroku provides a dynamic PORT, but AzuraCast expects port 80
# We'll use environment variable mapping to handle this
if [ -n "$PORT" ]; then
    echo "Heroku PORT detected: $PORT"
    export AZURACAST_HTTP_PORT=$PORT
fi

# Set up basic authentication if credentials are provided
if [ -n "$BASIC_AUTH_USER" ] && [ -n "$BASIC_AUTH_PASSWORD" ]; then
    echo "Configuring basic authentication for user: $BASIC_AUTH_USER"
    
    # Create htpasswd file
    mkdir -p /etc/nginx/auth
    htpasswd -bc /etc/nginx/auth/.htpasswd "$BASIC_AUTH_USER" "$BASIC_AUTH_PASSWORD"
    
    # Create nginx configuration snippet for basic auth
    cat > /etc/nginx/conf.d/basic_auth.conf <<EOF
# Basic authentication for AzuraCast
auth_basic "AzuraCast - Restricted Access";
auth_basic_user_file /etc/nginx/auth/.htpasswd;
EOF
    
    echo "Basic authentication configured successfully"
else
    echo "No basic authentication configured (BASIC_AUTH_USER or BASIC_AUTH_PASSWORD not set)"
fi

# Configure database connection from Heroku DATABASE_URL if available
if [ -n "$DATABASE_URL" ]; then
    echo "Configuring PostgreSQL from DATABASE_URL"
    export MYSQL_HOST=$(echo $DATABASE_URL | sed -e 's/.*@\(.*\):.*/\1/')
    export MYSQL_PORT=$(echo $DATABASE_URL | sed -e 's/.*:\([0-9]*\)\/.*/\1/')
    export MYSQL_DATABASE=$(echo $DATABASE_URL | sed -e 's/.*\/\(.*\)/\1/')
    export MYSQL_USER=$(echo $DATABASE_URL | sed -e 's/.*\/\/\(.*\):.*@.*/\1/')
    export MYSQL_PASSWORD=$(echo $DATABASE_URL | sed -e 's/.*\/\/.*:\(.*\)@.*/\1/')
fi

# Configure Redis from Heroku REDIS_URL if available
if [ -n "$REDIS_URL" ]; then
    echo "Configuring Redis from REDIS_URL"
    export REDIS_HOST=$(echo $REDIS_URL | sed -e 's/.*@\(.*\):.*/\1/')
    export REDIS_PORT=$(echo $REDIS_URL | sed -e 's/.*:\([0-9]*\)/\1/')
fi

echo "Starting AzuraCast services..."
echo "Configuration summary:"
echo "  - HTTP Port: ${AZURACAST_HTTP_PORT}"
echo "  - Redis: ${ENABLE_REDIS}"
echo "  - Advanced Features: ${ENABLE_ADVANCED_FEATURES}"
echo "================================"

# Start AzuraCast using the original entrypoint
exec /usr/local/bin/my_init
