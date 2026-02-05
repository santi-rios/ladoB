#!/bin/bash
set -e

# If basic auth credentials are provided, set them up
if [ -n "$BASIC_AUTH_USER" ] && [ -n "$BASIC_AUTH_PASSWORD" ]; then
    echo "Setting up basic authentication..."
    # Create htpasswd file
    apt-get update && apt-get install -y apache2-utils
    htpasswd -bc /etc/nginx/.htpasswd "$BASIC_AUTH_USER" "$BASIC_AUTH_PASSWORD"
    
    # Configure nginx to use basic auth
    if [ -f /etc/nginx/azuracast.conf ]; then
        sed -i '/location \/ {/a \    auth_basic "AzuraCast Access";\n    auth_basic_user_file /etc/nginx/.htpasswd;' /etc/nginx/azuracast.conf
    fi
fi

# Start AzuraCast services
exec /usr/local/bin/my_init
