#!/bin/sh

set -e

# enable IP forwarding
sysctl -w net.ipv4.ip_forward=1

# configure firewall
#iptables -t nat -A POSTROUTING -s 172.21.243.0/20 ! -d 172.21.242.0/20 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 172.21.242.0/27 -o eth0 -j MASQUERADE
iptables -A FORWARD -s 172.21.242.0/27 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j TCPMSS --set-mss 1356
iptables -A INPUT -i ppp+ -j ACCEPT
iptables -A OUTPUT -o ppp+ -j ACCEPT
iptables -A FORWARD -i ppp+ -j ACCEPT
iptables -A FORWARD -o ppp+ -j ACCEPT

exec "$@"
