# Use AzuraCast's official Docker image
FROM ghcr.io/azuracast/azuracast:latest

# Heroku requires binding to $PORT
ENV PORT=8080
EXPOSE 8080

# Set up working directory
WORKDIR /var/azuracast

# AzuraCast requires certain environment variables
ENV AZURACAST_HTTP_PORT=8080 \
    AZURACAST_HTTPS_PORT=8443 \
    AZURACAST_SFTP_PORT=2022 \
    ENABLE_REDIS=true \
    ENABLE_ADVANCED_FEATURES=true

# Create startup script that configures basic auth if credentials are set
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
