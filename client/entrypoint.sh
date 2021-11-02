#!/bin/bash

cp /shared/krb5-server.conf /etc/krb5.conf

echo 'passw5rd.12' | kinit --password-file=STDIN -f testuser@DOMAIN.TEST

exec "$@"
