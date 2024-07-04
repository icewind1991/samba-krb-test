#!/usr/bin/env bash

docker rm -f server 2>/dev/null > /dev/null

MODE=${3:-"apache"}
PHP_VERSION=${4:-"8.1"}

docker run -d --name server -v $2:/var/www/html -v /tmp/shared:/shared --dns $1 --hostname httpd.domain.test "icewind1991/samba-krb-test-$MODE" 1>&2
SERVER_IP=$(docker inspect server --format '{{.NetworkSettings.IPAddress}}')

# add the dns record for server
docker exec dc samba-tool dns add krb.domain.test domain.test httpd A $SERVER_IP -U administrator --password=passwOrd1 1>&2

echo $SERVER_IP
