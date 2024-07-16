FROM ubuntu:24.04

ADD krb5.seed /krb5.seed
RUN apt-get update && \
    apt-get -y install debconf-utils nano && \
    debconf-set-selections /krb5.seed && \
    apt-get -y install samba krb5-config winbind smbclient python3 tcpdump

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ADD init-config.sh /init-config.sh
RUN chmod +x /init-config.sh

HEALTHCHECK --interval=1s --start-period=60s CMD bash -c '[ -f /done ]'

ENTRYPOINT ["/entrypoint.sh"]
