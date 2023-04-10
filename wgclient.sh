#!/bin/bash

usage() {
  echo "Usage: $0 [-h] [-s droplet ip] [-p droplet public key]"
  echo "  -h            Display help"
  echo "  -s server_ip  (Required) Set the droplet IP address"
  echo "  -p public_key (Required) Set the droplet public key"
  exit 1
}

server_public_key=''
server_public_ip=''

while getopts "hs:p:" opt; do
  case $opt in
    h)
      usage
      ;;
    s)
      server_ip="$OPTARG"
      ;;
    p)
      public_key="$OPTARG"
      ;;
    *)
      usage
      ;;
  esac
done

if [ -z "${server_ip}" ] && [ -z "${public_key}" ]; then
  usage
fi

# Package manager update
sudo apt update
sudo apt -y upgrade
sudo apt install -y resolvconf
sudo apt install -y wireguard

# Variables for the configuration
server_port=51820
client_private_key=$(wg genkey | sudo tee /etc/wireguard/private.key)
sudo chmod go= /etc/wireguard/private.key
client_public_key=$(echo "${client_private_key}" | wg pubkey | sudo tee /etc/wireguard/public.key)
clientIP="10.8.0.1/24"
inface=$(ip route list default | grep -oP 'dev \K\S+')
IP=$(ip -brief address show eth0 | grep -oP '\b(\d{1,3}\.){3}\d{1,3}\b' | head -n 1)


# Create the WireGuard peer configuration file
sudo bash -c "cat > /etc/wireguard/wg0-client.conf << EOL
[Interface]
PrivateKey = ${client_private_key}
Address = ${clientIP}
DNS = 1.1.1.1, 1.0.0.1
PostUp = ip rule add table 200 from ${IP}
PostUp = ip route add table 200 default via ${IP}
PreDown = ip rule delete table 200 from ${IP}
PreDown = ip route delete table 200 default via ${IP}

[Peer]
PublicKey = ${server_public_key}
AllowedIPs = 10.8.0.0/24
Endpoint = ${server_public_ip}:${server_port}
EOL"

echo "WireGuard peer configuration has been generated!"
echo "Client Private Key: ${client_private_key}"
echo "Client Public Key: ${client_public_key}"
