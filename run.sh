#!/bin/bash

function getContainerHealth {
  docker inspect --format "{{.State.Health.Status}}" $1
}

function waitContainer {
  while STATUS=$(getContainerHealth $1); [ $STATUS != "healthy" ]; do
    if [ $STATUS == "unhealthy" ]; then
      echo "Failed!"
      exit -1
    fi
    printf .
    lf=$'\n'
    sleep 1
  done
  printf "$lf"
}

docker rm -f dc apache

mkdir /tmp/shared

# start the dc
docker run -dit --name dc -v /tmp/shared:/shared --hostname krb.domain.test --cap-add SYS_ADMIN icewind1991/samba-krb-test-dc
DC_IP=$(docker inspect dc --format '{{.NetworkSettings.IPAddress}}')

waitContainer dc

echo "started2"

# start apache
docker run -d --name apache -v /srv/http/smb:/var/www/html -v /tmp/shared:/shared --dns $DC_IP --hostname httpd.domain.test icewind1991/samba-krb-test-apache
APACHE_IP=$(docker inspect apache --format '{{.NetworkSettings.IPAddress}}')

# add the dns record for apache
docker exec dc samba-tool dns add krb.domain.test domain.test httpd A $APACHE_IP -U administrator --password=passwOrd1

# run our commands
LIST=$(docker run -it --rm --name client -v /tmp/shared:/shared --dns $DC_IP --hostname client.domain.test icewind1991/samba-krb-test-client \
  curl --negotiate -u testuser@DOMAIN.TEST: --delegation always http://httpd.domain.test/example-apache-kerberos.php)
LIST=$(echo $LIST | tr -d '[:space:]')

echo $LIST

[[ $LIST == "test.txt" ]]
