FROM php:7.4-apache-buster

ADD krb5.seed /krb5.seed
RUN apt-get update && \
    apt-get -y install debconf-utils nano && \
    debconf-set-selections /krb5.seed && \
	apt-get install -y libkrb5-dev libsmbclient-dev smbclient libapache2-mod-auth-kerb

RUN pecl install krb5 smbclient && \
	docker-php-ext-enable krb5 smbclient

ADD 000-default.conf /etc/apache2/sites-enabled/000-default.conf
ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]


