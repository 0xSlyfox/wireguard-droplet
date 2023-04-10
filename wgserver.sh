#!/bin/bash
# Update the system and install required dependencies
sudo apt update
sudo apt upgrade -y
sudo apt install -y software-properties-common

# Add WireGuard repository and install WireGuard
sudo add-apt-repository -y ppa:wireguard/wireguard
sudo apt update
sudo apt install -y wireguard
sudo touch /etc/wireguard/wg0.conf

# Generate WireGuard keys
private_key=$(wg genkey)
public_key=$(echo "${private_key}" | wg pubkey)
inface=$(ip route list default | grep -oP 'dev \K\S+')

# Configure WireGuard
sudo mkdir -p /etc/wireguard
sudo bash -c "cat > /etc/wireguard/wg0.conf << EOL
[Interface]
PrivateKey = ${private_key}
Address = 10.8.0.1/24
ListenPort = 51820
SaveConfig = true
PostUp = ufw route allow in on wg0 out on ${inface}
PostUp = iptables -t nat -I POSTROUTING -o ${inface} -j MASQUERADE
PostUp = ip6tables -t nat -I POSTROUTING -o ${inface} -j MASQUERADE
PreDown = ufw route delete allow in on wg0 out on ${inface}
PreDown = iptables -t nat -D POSTROUTING -o ${inface} -j MASQUERADE
PreDown = ip6tables -t nat -D POSTROUTING -o ${inface} -j MASQUERADE

[Peer]
PublicKey = ${public_key}
AllowedIPs = 10.0.0.2/32
EOL
"

# Configure firewall
sudo apt install -y ufw
sudo ufw allow 51820/udp
sudo ufw allow OpenSSH
sudo ufw disable
sudo ufw enable


# Enable and start the WireGuard service
sudo systemctl enable wg-quick@wg0.service
sudo systemctl start wg-quick@wg0.service

# Checks for errors in the install and provides Public Key and status for service
sudo systemctl status wg-quick@wg0.service
sudo ufw status
echo "WireGuard is installed and configured on your Digital Ocean droplet!"
echo "Public Key: ${public_key}"
echo "Private Key: ${private_key}"
echo "Run wg-peer.sh on your machine"
