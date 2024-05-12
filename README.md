# `Alpine Linux Based DNSSEC Validating Recursive Unbound DNS Resolver Docker Image`

<details> 
    
  <summary>Build status</summary><br>
  
[![CD Check NLnet Labs Unbound release](https://img.shields.io/github/actions/workflow/status/madnuttah/unbound-docker/cd-check-unbound-release.yaml?branch=main&label=CD%20NLnet%20Labs%20Unbound%20Release&style=flat-square)](https://github.com/madnuttah/unbound-docker/blob/main/.github/workflows/cd-check-unbound-release.yaml)
[![CD Build Docker Image](https://img.shields.io/github/actions/workflow/status/madnuttah/unbound-docker/cd-build-unbound.yaml?branch=main&label=CD%20madnuttah/unbound%20build%20status&style=flat-square)](https://github.com/madnuttah/unbound-docker/blob/main/.github/workflows/cd-build-unbound.yaml)
[![CD Build Nightly Docker Image](https://img.shields.io/github/actions/workflow/status/madnuttah/unbound-docker/cd-build-canary-unbound.yaml?branch=main&label=CD%20madnuttah/unbound%20canary%20build%20status&style=flat-square)](https://github.com/madnuttah/unbound-docker/blob/main/.github/workflows/cd-build-canary-unbound.yaml)
[![CD Security Scan](https://img.shields.io/github/actions/workflow/status/madnuttah/unbound-docker/cd-security-scan.yaml?branch=main&label=CD%20security%20scan&style=flat-square)](https://github.com/madnuttah/unbound-docker/blob/main/.github/workflows/cd-security-scan.yaml)
[![Manual Build Unbound Docker Image](https://img.shields.io/github/actions/workflow/status/madnuttah/unbound-docker/manually-build-unbound.yaml?branch=main&label=Manually%20madnuttah/unbound%20build%20status&style=flat-square)](https://github.com/madnuttah/unbound-docker/blob/main/.github/workflows/manually-build-unbound.yaml)

</details>

[![GitHub version](https://img.shields.io/github/v/release/madnuttah/unbound-docker?include_prereleases&label=madnuttah/unbound%20release&style=flat-square)](https://github.com/madnuttah/unbound-docker/releases)
[![OpenSSL buildenv](https://img.shields.io/github/v/release/madnuttah/openssl-buildenv?include_prereleases&label=madnuttah/openssl-buildenv%20release&style=flat-square)](https://github.com/madnuttah/openssl-buildenv/releases)

This is a lightweight Alpine Linux based Docker image that runs [Unbound](https://unbound.net), an open source high-performance DNS resolver developed by the nice people at [NLnet Labs](https://nlnetlabs.nl) running as **your own recursive DNS server** in a secure single-layer distroless scratch image modeled by following the best practice principles.

While it leaves _almost_ nothing to be desired, it is perfectly suited for professional and personal use alike. 

<details> 
    
  <summary>Features</summary><br>
    
| Feature                                  | Supported |
| ---------------------------------------- | --------- |
| Unprivileged user                        | yes |
| Unprivileged port (privileged possible)  | yes |
| Custom UID/GID environment variables      | yes |
| CD built single-layer distroless scratch image running Alpine Linux | yes |
| Per hardware architecture optimized & CD built [`OpenSSL`](https://github.com/madnuttah/openssl-buildenv) | yes |
| Libevent                                 | yes |
| Recursive DNS as default                 | yes |
| DNSSEC                                   | yes |
| DNSCrypt                                 | yes |
| DNSTap                                   | yes |
| DNS64                                    | yes |
| DNS over HTTPS                           | yes |
| DNS over TLS                             | yes |
| Redis via UNIX Socket or network         | yes |
| Optional privacy respecting & meaningful healthcheck | yes |
| Optional Unbound statistics for Grafana via Zabbix utilizing on-board means | yes |
| Python                                   | no |
| EDNS Client Subnet                       | no |
    
</details>

## Getting started

Docker containers are most easily used with docker compose. 

> [!IMPORTANT] 
> We encourage you to read the [`Details`](https://github.com/madnuttah/unbound-docker/blob/main/doc/DETAILS.md) page to learn how to get this up and running, some example `Docker-Compose` files can be found [`here`](https://github.com/madnuttah/unbound-docker/tree/main/doc/examples).
>
> If you prefer to use Podman and systemd to manage your containers, example `Quadlets` can be found [`here`](https://github.com/madnuttah/unbound-docker/tree/main/doc/examples/podman-systemd).

## Available Docker Tags

You can pull the most recent image from Docker Hub using it's `latest` tag or by using the corresponding image version number:

`docker pull madnuttah/unbound:latest` or `docker pull madnuttah/unbound:1.1.0-0`

The image versioning scheme follows unbound - complemented by a dash and the desired image revision, for example `1.1.0-0`.
 
There are canary builds of the image available. You can pull the image using it's `canary` tag: 

`docker pull madnuttah/unbound:canary`

> [!NOTE] 
> Canary builds may contain bugs and are not recommended to be used in production environments. These builds are untested and also unsupported by me.
 
## Changes
    
You can view the changes in the [`Releases`](https://github.com/madnuttah/unbound-docker/releases) section.

## Feedback

We are here to help! Don't hesitate to contact us through a [`GitHub Issue`](https://github.com/madnuttah/unbound-docker/issues) if you have any questions, requests or problems with the image. 

You can also reach us on Fosstodon: 

[![Follow me on Mastodon](https://img.shields.io/mastodon/follow/107779375129112763?domain=https%3A%2F%2Ffosstodon.org%2F&style=social)](https://fosstodon.org/@madnuttah)

## Acknowledgements

- [Alpine Linux](https://www.alpinelinux.org/)
- [Docker](https://www.docker.com/)
- [Unbound](https://unbound.net/)
- [OpenSSL](https://www.openssl.org/)
- [Redis](https://redis.io/)
- [Pi-hole](https://pi-hole.net/)
- [Aqua Security](https://trivy.dev/)
- The many Docker Images which got us inspired

## Licenses

### License

Unless otherwise specified, all code is released under the MIT license.
See the [`LICENSE`](https://github.com/madnuttah/unbound-docker/blob/main/LICENSE) for details.

### Licenses for other components

- Docker: [Apache 2.0](https://github.com/docker/docker/blob/master/LICENSE)
- Unbound: [BSD License](https://unbound.nlnetlabs.nl/svn/trunk/LICENSE)
- OpenSSL: [Apache-style license](https://www.openssl.org/source/license.html)

## Legal

Please note that this is a work of a private contributor and I'm neither affiliated with NLnet Labs or Pi-hole nor is NLnet Labs or Pi-hole involved in the development of the image. The marks and properties 'Unbound' and 'Pi-hole' are properties of NLnet Labs and Pi-hole respectively. All rights in the source codes, including logos relating to said marks and properties belong to their respective owners.

## Supporting our mission

In case you would like to donate money, please rather spend it on the upstream projects this image relies on.

If you like what we do and if you find this image protecting your privacy and giving back your DNS liberty useful - consider becoming a stargazer ⭐ on Docker Hub and GitHub. Thank you for your support! ❤️
