ARG PHP_VERSION
FROM php:$PHP_VERSION-apache-trixie
LABEL org.opencontainers.image.source="https://github.com/icewind1991/samba-krb-test"

ADD krb5.seed /krb5.seed
RUN apt-get update && \
    apt-get -y install debconf-utils nano && \
    debconf-set-selections /krb5.seed && \
	apt-get install -y libkrb5-dev \
		libsmbclient-dev \
		smbclient \
		libzip-dev \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libmcrypt-dev \
		libpng-dev

RUN pecl install krb5 smbclient && \
	docker-php-ext-enable krb5 smbclient && \
    echo "xdebug.mode=debug" >> $PHP_INI_DIR/conf.d/xdebug.ini && \
    echo "xdebug.start_with_request=trigger" >> $PHP_INI_DIR/conf.d/xdebug.ini && \
    echo "xdebug.discover_client_host=true" >> $PHP_INI_DIR/conf.d/xdebug.ini && \
    echo "xdebug.client_host=host.docker.internal" >> $PHP_INI_DIR/conf.d/xdebug.ini && \
    echo "xdebug.log_level=0" >> $PHP_INI_DIR/conf.d/xdebug.ini && \
    echo "memory_limit = 512M" > $PHP_INI_DIR/conf.d/docker-php-memlimit.ini

RUN docker-php-ext-configure gd \
		--enable-gd \
		--with-jpeg \
		--with-freetype && \
	docker-php-ext-install gd zip pcntl

RUN apt-get install -y libapache2-mod-auth-kerb

ADD 000-default.conf /etc/apache2/sites-enabled/000-default.conf
ADD entrypoint.sh /entrypoint.sh
RUN echo 'memory_limit = 512M' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini

ENTRYPOINT ["/entrypoint.sh"]


