#!/usr/bin/env bash

cd apache

docker build -t icewind1991/samba-krb-test-apache .

cd ../client

docker build -t icewind1991/samba-krb-test-client .

cd ../dc

docker build -t icewind1991/samba-krb-test-dc .
