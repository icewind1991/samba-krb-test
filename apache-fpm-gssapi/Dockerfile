ARG PHP_VERSION
FROM php:$PHP_VERSION-fpm-buster
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

ENV APACHE_CONFDIR /etc/apache2
ENV APACHE_ENVVARS $APACHE_CONFDIR/envvars

RUN set -eux; \
	apt-get install -y --no-install-recommends apache2; \
	\
# generically convert lines like
#   export APACHE_RUN_USER=www-data
# into
#   : ${APACHE_RUN_USER:=www-data}
#   export APACHE_RUN_USER
# so that they can be overridden at runtime ("-e APACHE_RUN_USER=...")
	sed -ri 's/^export ([^=]+)=(.*)$/: ${\1:=\2}\nexport \1/' "$APACHE_ENVVARS"; \
	\
# setup directories and permissions
	. "$APACHE_ENVVARS"; \
	for dir in \
		"$APACHE_LOCK_DIR" \
		"$APACHE_RUN_DIR" \
		"$APACHE_LOG_DIR" \
	; do \
		rm -rvf "$dir"; \
		mkdir -p "$dir"; \
		chown "$APACHE_RUN_USER:$APACHE_RUN_GROUP" "$dir"; \
# allow running as an arbitrary user (https://github.com/docker-library/php/issues/743)
		chmod 777 "$dir"; \
	done; \
	\
# delete the "index.html" that installing Apache drops in here
	rm -rvf /var/www/html/*; \
	\
# logs should go to stdout / stderr
	ln -sfT /dev/stderr "$APACHE_LOG_DIR/error.log"; \
	ln -sfT /dev/stdout "$APACHE_LOG_DIR/access.log"; \
	ln -sfT /dev/stdout "$APACHE_LOG_DIR/other_vhosts_access.log"; \
	chown -R --no-dereference "$APACHE_RUN_USER:$APACHE_RUN_GROUP" "$APACHE_LOG_DIR"

RUN a2dismod proxy && a2enmod proxy_fcgi
RUN apt-get install -y libapache2-mod-auth-gssapi
RUN sed -i -e "s|clear_env = no|clear_env = yes|" /usr/local/etc/php-fpm.d/docker.conf

ADD 000-default.conf /etc/apache2/sites-enabled/000-default.conf
ADD entrypoint.sh /entrypoint.sh
COPY apache2-foreground /usr/local/bin/
RUN echo 'memory_limit = 512M' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini

ENTRYPOINT ["/entrypoint.sh"]


