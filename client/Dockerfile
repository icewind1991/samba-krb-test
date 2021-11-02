FROM ubuntu:20.04

ADD krb5.seed /krb5.seed
RUN apt-get update && \
    apt-get -y install debconf-utils nano && \
    debconf-set-selections /krb5.seed && \
    apt-get -y install smbclient curl heimdal-clients

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]


