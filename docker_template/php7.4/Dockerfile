FROM php:7.4-apache

ARG HOST_USER_ID=1000
ARG HOST_GROUP_ID=1000

RUN a2enmod rewrite \
    && service apache2 restart \
    && apt-get update && apt-get install -y \
        openssl \
        unzip \
        git \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libzip-dev \
        zlib1g-dev libicu-dev g++ \
        libc-client-dev \
        libkrb5-dev \
    && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_mysql mysqli \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && docker-php-ext-install bcmath \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap \
    && docker-php-ext-install zip \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && groupmod -g ${HOST_GROUP_ID} www-data \
    && usermod -u ${HOST_USER_ID} www-data \
    && service apache2 restart
