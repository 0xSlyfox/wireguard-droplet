# wireguard-droplet
Auto-generation scripts to setup a wireguard server on a digital ocean droplet

### Install
Clone to the server and to the client
```
git clone https://github.com/0xSlyfox/wireguard-droplet.git
```
Change permissions
```
chmod +x wgclient
chmod +x wgserver
```
### Running on the Server
```
./wgserver.sh
```

### Running on the client
This cant be run until after the server script has ran.
Make sure that you have the ability to access the droplets ip and droplets public key from the wgserver.sh
```
./wgclient.sh -s DROPLET IP -p SERVER PUBLIC KEY
```

