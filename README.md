# wireguard-droplet
Auto-generation scripts to setup a wireguard server on a digital ocean droplet

### Install
Clone to the server and to the client
```bash
git clone https://github.com/0xSlyfox/wireguard-droplet.git
```
Change permissions on the client and server
```bash
chmod +x wgclient
chmod +x wgserver
```
### Running on the Server
```bash
./wgserver.sh
```

### Running on the client
This cant be run until after the server script has ran.
Make sure that you have the ability to access the droplets ip and droplets public key from the wgserver.sh
```bash
./wgclient.sh -s DROPLET IP -p SERVER PUBLIC KEY
```
### Add you public key and IP to the server config
```bash
sudo wg set wg0 peer (CLIENT PUBLIC KEY) allowed-ips (CLIENT IP)
```
