# Use AzuraCast's official Docker image
FROM ghcr.io/azuracast/azuracast:latest

# Set up working directory
WORKDIR /var/azuracast

# AzuraCast configuration for Heroku
# Note: Heroku assigns a dynamic $PORT, but AzuraCast expects port 80/8080
ENV AZURACAST_HTTP_PORT=80 \
    AZURACAST_HTTPS_PORT=443 \
    AZURACAST_SFTP_PORT=2022 \
    ENABLE_REDIS=true \
    ENABLE_ADVANCED_FEATURES=true

# Install additional tools for basic auth setup
RUN apt-get update && \
    apt-get install -y apache2-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy startup script that configures basic auth and port mapping
COPY docker-entrypoint.sh /heroku-entrypoint.sh
RUN chmod +x /heroku-entrypoint.sh

# Expose default port (Heroku will map to dynamic $PORT)
EXPOSE 80

ENTRYPOINT ["/heroku-entrypoint.sh"]
