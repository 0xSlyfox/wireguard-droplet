#!/bin/bash

IPT="/sbin/iptables"
IPT6="/sbin/ip6tables"

IN_FACE="enp1s0"
WG_FACE="wg0"
SUB_NET="10.120.0.1/24"
WG_PORT="26535"

$IPT -t nat -D POSTROUTING -s $SUB_NET -o $IN_FACE -j MASQUERADE
$IPT -D INPUT -i $WG_FACE -j ACCEPT
$IPT -D FORWARD -i $IN_FACE -o $WG_FACE -j ACCEPT
$IPT -D FORWARD -i $WG_FACE -o $IN_FACE -j ACCEPT
$IPT -D INPUT -i $IN_FACE -p udp --dport $WG_PORT -j ACCEPT
