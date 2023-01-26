# samba-krb-test

Docker images for testing kerberos sso with php.

## Images

### DC

`icewind1991/samba-krb-test-dc` contains a pre-configured samba to act as the domain controller

### Apache

`icewind1991/samba-krb-test-apache` contains an apache+mod-auth-kerb+php setup based on `php:8.1-apache-buster`
`icewind1991/samba-krb-test-apache-gssapi` contains an apache+php+mod-auth-gssapi setup based on `php:8.1-apache-buster`

### Client

`icewind1991/samba-krb-test-client` contains a modified `ubuntu:20.04` with kerberos authentication configured.

## Usage

- Start the DC and get its IP
```bash
DC_IP=$(./start-dc.sh)

echo "DC: $DC_IP"
```

- Start Apache with the desired php app
```bash
./start-apache.sh $DC_IP /path/to/php/root
```

or
```bash
./start-apache.sh $DC_IP /path/to/php/root -gssapi
```

- Run a curl command from the client with Kerberos SSO
```bash
./client-cmd.sh $DC_IP curl --negotiate -u testuser@DOMAIN.TEST: --delegation always http://httpd.domain.test/example-apache-kerberos.php
```
