#!/bin/bash

# 1. Configure docker options to fix the bridge address of the docker process to a known IP
echo 'OPTIONS="$OPTIONS --bip=172.17.0.1/16"' >> /etc/sysconfig/docker

# 2. Add the fixed bridge address to /etc/resolv.conf via configuration of dhclient
echo 'prepend domain-name-servers 172.17.0.1;' >> /etc/dhcp/dhclient.conf

# 3. Script initialisation of dnsdock container on instance boot
echo 'docker run --restart=always -d -v /var/run/docker.sock:/var/run/docker.sock --name dnsdock -p 172.17.0.1:53:53/udp tonistiigi/dnsdock:v1.9.0' >> /etc/rc.local
