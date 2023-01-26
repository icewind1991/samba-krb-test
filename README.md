# samba-krb-test

Docker images for testing kerberos sso with php.

## Images

### DC

`icewind1991/samba-krb-test-dc` contains a pre-configured samba to act as the domain controller

### Apache

`icewind1991/samba-krb-test-apache` contains an apache+php setup based on `php:8.1-apache-buster` with the required kerberos bits installed

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

- Run a curl command from the client with Kerberos SSO
```bash
./client-cmd.sh $DC_IP curl --negotiate -u testuser@DOMAIN.TEST: --delegation always http://httpd.domain.test/example-apache-kerberos.php
```
