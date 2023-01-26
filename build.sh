#!/usr/bin/env bash

docker build -t icewind1991/samba-krb-test-apache apache
docker build -t icewind1991/samba-krb-test-apache-gssapi apache-gssapi

docker build -t icewind1991/samba-krb-test-client client

docker build -t icewind1991/samba-krb-test-dc dc
