FROM  php:7.3-fpm-alpine

WORKDIR /var/www/html
RUN apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev && \
    docker-php-ext-configure gd \
    --with-gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ && \
    NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    docker-php-ext-install -j${NPROC} gd && \
    apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

RUN apk add --no-cache libzip-dev && docker-php-ext-configure zip --with-libzip=/usr/include

RUN apk add --no-cache icu-dev

RUN docker-php-ext-install zip && docker-php-ext-configure intl && docker-php-ext-install intl

RUN apk update && apk add build-base nodejs tzdata git libxml2-dev
RUN docker-php-ext-install xmlrpc

RUN docker-php-ext-install opcache
RUN docker-php-ext-install soap

RUN docker-php-ext-install pdo pdo_mysql

RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

RUN echo 'max_execution_time=240' >> /usr/local/etc/php/conf.d/php.ini \
    && echo 'memory_limit=4G' >> /usr/local/etc/php/conf.d/php.ini

# Add UID '1000' to www-data
RUN apk add shadow && usermod -u 1000 www-data && groupmod -g 1000 www-data

# Copy existing application directory permissions
COPY --chown=www-data:www-data . $REMOTE_WORKING_DIR

# Change current user to www
USER www-data

# Expose port 9000 and start php-fpm server
EXPOSE 9000

# Run php-fpm
CMD ["php-fpm"]
