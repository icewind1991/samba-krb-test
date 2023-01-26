#!/bin/bash

cp /shared/krb5-server.conf /etc/krb5.conf
chmod 0777 /shared/httpd.keytab

exec apache2-foreground
