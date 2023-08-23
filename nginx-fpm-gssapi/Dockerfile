FROM php:8.1-fpm-bullseye@sha256:45d0b87bee8b630648ec7b1d788475f98820a12bd81abc6ebdf3462d9614eb54
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
		libpng-dev \
    	nginx

RUN pecl install krb5 smbclient xdebug && \
	docker-php-ext-enable krb5 smbclient xdebug && \
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

COPY libnginx-mod-http-auth-spnego_1.18.0-6.1+deb11u3_amd64.deb /usr/local
RUN dpkg --install /usr/local/libnginx-mod-http-auth-spnego_1.18.0-6.1+deb11u3_amd64.deb

RUN sed -i -e "s|clear_env = no|clear_env = yes|" /usr/local/etc/php-fpm.d/docker.conf

ADD nginx.conf /etc/nginx/nginx.conf
RUN nginx -t
ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]


