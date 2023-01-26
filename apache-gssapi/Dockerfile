FROM php:8.1-apache-buster

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
	docker-php-ext-install gd zip

RUN apt-get install -y libapache2-mod-auth-gssapi

ADD 000-default.conf /etc/apache2/sites-enabled/000-default.conf
ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]


