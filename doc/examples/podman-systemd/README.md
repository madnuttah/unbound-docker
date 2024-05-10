# Unbound and AdGuard Home deployment using Podman Quadlet (systemd unit files)
Please refer to the [official documentation](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html) for Quadlet generated systemd unit files.

## Prerequisites
* Podman ≥ 4.4

## Rootful implementation
1. Place these files in the root or subdirectory of `/etc/containers/systemd/` or `/usr/share/containers/systemd/`
2. Edit `adguardhome.network` with the host parent interface and network settings you would like to assign to the Adguard Home container
2. Simply reboot or run the following commands in order:
```
sudo systemctl daemon-reload
sudo systemctl start br-dns-network.service
sudo systemctl start unbound.service
sudo systemctl start adguardhome-network.service
sudo systemctl start adguardhome.service
```
4. Browse to `http://<IPAddr>:3000` to configure AdGuard Home
5. After logging into the Dashboard, navigate to DNS settings and make sure to add the `br-dns` network gateway to the list of Bootstrap DNS servers (eg. 10.89.0.1)
6. Configure your upstream DNS server as `unbound:5335`
7. Click Apply
8. Point your clients to the IP address you assigned in `adguardhome.network`

## Rootless implementation
* Reserved
* Please consider contributing to a Podman 5.x solution using [`pasta`](https://passt.top/passt/about/#pasta-pack-a-subtle-tap-abstraction) or some other networking magic