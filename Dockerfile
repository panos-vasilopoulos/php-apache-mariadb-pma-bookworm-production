# Use PHP 8.4 with Apache on Debian Bookworm as the base image
FROM php:8.4-apache-bookworm

LABEL maintainer="panos@vasilopoulos.me"
LABEL version="1.0"
LABEL description="A tailored Apache web server setup designed specifically for PHP applications, featuring an organized directory and configuration template. This setup ensures optimal performance and security by aligning with best practices for deploying PHP-based websites or applications."
LABEL org.opencontainers.image.title="php-8-4-apache-bookworm-production"
LABEL org.opencontainers.image.description="A tailored Apache web server setup designed specifically for PHP applications, featuring an organized directory and configuration template. This setup ensures optimal performance and security by aligning with best practices for deploying PHP-based websites or applications."
LABEL org.opencontainers.image.source="https://github.com/panos-vasilopoulos/php-8-4-apache-bookworm-production"
LABEL org.opencontainers.image.created="2024-03-01T12:00:00Z"
LABEL org.opencontainers.image.licenses="MIT"

# Update package list and install prerequisites
RUN apt update && apt upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
        lsb-release \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        zlib1g-dev \
        libcurl4-openssl-dev \
        curl \
        gnupg2 \
        libxml2-dev \
        libonig-dev \
        libssl-dev

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) mysqli pdo_mysql gd exif zip bcmath opcache

# Clean up
RUN apt clean && rm -rf /var/lib/apt/lists/*

# Enable and disable required modules
RUN a2enmod rewrite headers deflate expires && \
    a2query -m status && a2dismod status || true && \
    a2query -m autoindex && a2dismod autoindex || true && \
    a2query -m info && a2dismod info || true && \
    a2query -m dir && a2dismod dir || true


# Set permissions for security
RUN chown -R www-data:www-data /var/www/html

# Copy application code to Apache's document root
COPY ./app/public/ /var/www/html/
COPY ./app/.htaccess /var/www/html/
COPY ./app/php.ini /usr/local/etc/php/conf.d/custom-php.ini

# Create a uploads directory and assign proper permissions
RUN mkdir -p /var/www/html/uploads && \
    chown -R www-data:www-data /var/www/html/uploads

# Custom Apache site configuration
COPY ./app/webapp.conf /etc/apache2/sites-available/
RUN a2dissite 000-default && a2ensite webapp

# Configure environment variables in Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    mkdir -p /etc/apache2/conf-enabled/envvars && \
    { \
        echo 'SetEnv MYSQL_DB_CONNECTION "$MYSQL_DB_CONNECTION"'; \
        echo 'SetEnv MYSQL_DB_NAME "$MYSQL_DB_NAME"'; \
        echo 'SetEnv MYSQL_USER "$MYSQL_USER"'; \
        echo 'SetEnv MYSQL_PASSWORD "$MYSQL_PASSWORD"'; \
        echo 'SetEnv SITE_URL "$SITE_URL"'; \
    } > /etc/apache2/conf-enabled/envvars.conf

# Security enhancements for Apache and PHP
RUN if ! grep -q "Options FollowSymLinks" /var/www/html/.htaccess; then \
        sed -i 's/Options Indexes FollowSymLinks/Options FollowSymLinks/g' /var/www/html/.htaccess || \
        echo "Options FollowSymLinks" >> /var/www/html/.htaccess; \
    fi && \
    echo "error_log = /proc/self/fd/2" >> /usr/local/etc/php/conf.d/docker-php-logs.ini && \
    echo "LogLevel warn" >> /etc/apache2/apache2.conf

# Expose HTTP port
EXPOSE 80

# Health check to ensure the container is running properly
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl -f http://localhost/ || exit 1

# Start Apache in the foreground
CMD ["apache2-foreground"]
