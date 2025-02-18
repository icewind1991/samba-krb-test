#!/bin/bash
set -o errexit -o nounset -o pipefail
/init-config.sh

samba-tool user create httpd-service --random-password
samba-tool spn add HTTP/httpd.domain.test httpd-service
samba-tool domain exportkeytab httpd.keytab --principal=HTTP/httpd.domain.test@domain.test

#enable delegation for all service (later only needed services)
samba-tool delegation for-any-service httpd-service on

echo "testfile" > /var/lib/samba/sysvol/domain.test/scripts/test.txt

cp /httpd.keytab /shared
cp /etc/krb5.conf /shared/krb5-server.conf

echo "Done"
echo 1 > /done

exec /bin/bash
