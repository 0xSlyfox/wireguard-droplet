#!/bin/bash
IPT="/sbin/iptables"
IPT6="/sbin/ip6tables"

IN_FACE="enp1s0"
WG_FACE="wg0"
SUB_NET="10.120.0.1/24"
WG_PORT="26535"

## IPv4 ##
$IPT -t nat -I POSTROUTING 1 -s $SUB_NET -o $IN_FACE -j MASQUERADE
$IPT -I INPUT 1 -i $WG_FACE -j ACCEPT
$IPT -I FORWARD 1 -i $IN_FACE -o $WG_FACE -j ACCEPT
$IPT -I FORWARD 1 -i $WG_FACE -o $IN_FACE -j ACCEPT
$IPT -I INPUT 1 -i $IN_FACE -p udp --dport $WG_PORT -j ACCEPT
