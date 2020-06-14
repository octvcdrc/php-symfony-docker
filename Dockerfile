FROM php:7-apache

MAINTAINER Cedric Octave <docker@octvcdrc.fr>

RUN apt-get update -y && apt-get install -y \
    libpng-dev \
    libzip-dev \
    imagemagick \
    ghostscript \
    libmagickwand-dev
RUN docker-php-ext-install mysqli bcmath exif gd opcache zip
RUN pecl install imagick
RUN docker-php-ext-enable imagick
RUN a2enmod rewrite
RUN a2enmod headers
RUN apt-get clean
