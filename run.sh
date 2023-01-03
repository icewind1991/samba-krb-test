#!/usr/bin/env bash

DC_IP=$(./start-dc.sh)

echo "DC: $DC_IP"

# start apache
APACHE_IP=$(./start-apache.sh $DC_IP /srv/http/smb)
echo "APACHE: $APACHE_IP"

LIST=$(./client-cmd.sh $DC_IP curl --negotiate -u testuser@DOMAIN.TEST: --delegation always http://httpd.domain.test/example-apache-kerberos.php)

echo $LIST

LIST=$(echo $LIST | tr -d '[:space:]')

[[ $LIST == "test.txt" ]]
