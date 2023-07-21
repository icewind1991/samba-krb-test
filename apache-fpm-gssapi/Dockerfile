FROM php:8.1-fpm-buster

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
	docker-php-ext-enable krb5 smbclient

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

ENTRYPOINT ["/entrypoint.sh"]


