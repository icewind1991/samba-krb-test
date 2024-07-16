#!/usr/bin/env bash

MODE=${1:-"apache"}

DC_IP=$(./start-dc.sh)

echo "DC: $DC_IP"
PHP_VERSION=${2:-"8.1"}

# start server
SERVER_IP=$(./start-server.sh "$DC_IP" /srv/http/smb "$MODE" "$PHP_VERSION")
echo "SERVER: $SERVER_IP"

LIST=$(./client-cmd.sh "$DC_IP" curl --negotiate -u testuser@DOMAIN.TEST: --delegation always http://httpd.domain.test/kerb/example-sso-kerberos.php)

echo $LIST

LIST=$(echo $LIST | tr -d '[:space:]')

[[ $LIST == "test.txt" ]]
