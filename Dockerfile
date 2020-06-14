FROM php:7-apache

MAINTAINER Cedric Octave <docker@octvcdrc.fr>

RUN apt-get update -y && apt-get install -y \
    libpng-dev \
    libzip-dev \
    imagemagick \
    ghostscript \
    libmagickwand-dev \
	git \
	unzip
RUN docker-php-ext-install mysqli bcmath exif gd opcache zip intl && \
	pecl install imagick && \
	docker-php-ext-enable imagick && \
	a2enmod rewrite && \
	a2enmod headers && \
	apt-get clean

COPY conf/php.ini $PHP_INI_DIR/conf.d/
COPY conf/security.conf /etc/apache2/conf-available/
COPY conf/apache2.conf /etc/apache2/

RUN curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php && \
	EXPECTED_CHECKSUM="$(curl -s https://composer.github.io/installer.sig)" && \
	php -r " \
		if (hash_file('SHA384', '/tmp/composer-setup.php') === '$EXPECTED_CHECKSUM') { \
			echo 'Installer verified'; \
		} else {  \
			echo 'Installer corrupt'; \
			unlink('composer-setup.php'); \
		} \
		echo PHP_EOL;" && \
	php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
	rm /tmp/composer-setup.php
	
RUN curl -sS "https://get.symfony.com/cli/installer" -o /tmp/symfony_installer && \
	chmod u+x /tmp/symfony_installer && \
	/tmp/symfony_installer --install-dir=/usr/local/bin && \
	rm /tmp/symfony_installer
