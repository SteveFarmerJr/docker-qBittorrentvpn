qBittorrent and OpenVPN
#
# Version 1.8

FROM ubuntu:18.04
MAINTAINER MarkusMcNugen

VOLUME /downloads
VOLUME /config

ENV DEBIAN_FRONTEND noninteractive

RUN usermod -u 99 nobody

# Update packages and install software
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils openssl \
    && apt-get install -y software-properties-common \
    && add-apt-repository ppa:qbittorrent-team/qbittorrent-stable \
    && apt-get update \
    && apt-get install -y qbittorrent-nox openvpn curl moreutils net-tools dos2unix kmod iptables ipcalc unrar \
#    && apt-get install -y cifs-utils \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add configuration and scripts
ADD openvpn/ /etc/openvpn/
ADD qbittorrent/ /etc/qbittorrent/

RUN chmod +x /etc/qbittorrent/*.sh /etc/qbittorrent/*.init /etc/openvpn/*.sh
RUN mkdir -p /mnt/shares/thor
#RUN mount.cifs //192.168.2.1/CloudShare/TORRENTS/ mnt/shares/thor/ -o user=admin, pass=jakelake3624!
# Expose ports and run
EXPOSE 8080
EXPOSE 8999
EXPOSE 8999/udp
EXPOSE 5050
CMD ["/bin/bash", "/etc/openvpn/start.sh"]
