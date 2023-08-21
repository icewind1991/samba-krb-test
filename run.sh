#!/usr/bin/env bash

MODE=${1:-"apache"}

DC_IP=$(./start-dc.sh)

echo "DC: $DC_IP"

# start server
SERVER_IP=$(./start-server.sh "$DC_IP" /srv/http/smb "$MODE")
echo "SERVER: $SERVER_IP"

LIST=$(./client-cmd.sh "$DC_IP" curl --negotiate -u testuser@DOMAIN.TEST: --delegation always http://httpd.domain.test/kerb/example-sso-kerberos.php)

echo $LIST

LIST=$(echo $LIST | tr -d '[:space:]')

[[ $LIST == "test.txt" ]]
