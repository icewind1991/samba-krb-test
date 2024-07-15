#!/bin/bash
set -o errexit -o nounset -o pipefail

[ "${DEBUG:-false}" == true ] && set -x

mv /etc/samba/smb.conf /etc/samba/smb.conf.orig
samba-tool domain provision --domain=DOMAIN --use-rfc2307 --realm=DOMAIN.TEST --adminpass=passwOrd1 --option="acl_xattr:security_acl_name = user.NTACL"
cp /var/lib/samba/private/krb5.conf /etc/ 

service smbd stop
service nmbd stop
service samba-ad-dc start
service samba-ad-dc restart
service samba-ad-dc status

samba-tool domain level show
samba-tool user create testuser passw5rd.12

