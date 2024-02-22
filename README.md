<p align="center">
    <img src="https://repository-images.githubusercontent.com/440215882/b79c7ae3-c3d4-4a6a-a1d7-d27fa626754b" alt="Logo">
</p>

# Alpine Linux Based DNSSEC Validating Recursive Unbound DNS Resolver Docker Image

[![CD Check NLnet Labs Unbound release](https://img.shields.io/github/actions/workflow/status/madnuttah/unbound-docker/cd-check-unbound-release.yaml?branch=main&label=CD%20NLnet%20Labs%20Unbound%20Release&style=flat-square)](https://github.com/madnuttah/unbound-docker/blob/main/.github/workflows/cd-check-unbound-release.yaml)
[![CD Build Docker Image](https://img.shields.io/github/actions/workflow/status/madnuttah/unbound-docker/cd-build-unbound.yaml?branch=main&label=CD%20madnuttah/unbound%20build%20status&style=flat-square)](https://github.com/madnuttah/unbound-docker/blob/main/.github/workflows/cd-build-unbound.yaml)

[![Manual Build Unbound Docker Image](https://img.shields.io/github/actions/workflow/status/madnuttah/unbound-docker/manually-build-unbound.yaml?branch=main&label=Manual%20madnuttah/unbound%20build%20status&style=flat-square)](https://github.com/madnuttah/unbound-docker/blob/main/.github/workflows/manually-build-unbound.yaml)

[![GitHub version](https://img.shields.io/github/v/release/madnuttah/unbound-docker?include_prereleases&label=madnuttah/unbound%20release&style=flat-square)](https://github.com/madnuttah/unbound-docker/releases)

This is a lightweight Alpine Linux based Docker image that runs [Unbound](https://unbound.net), an open source high-performance DNS resolver brought to you by the nice people [@NLnetLabs](https://github.com/NLnetLabs) running as **your own** recursive DNS server in a secure distroless scratch image modeled by following the best practice principles.

<details> 
    
  <summary>Features</summary><br>
    
| Feature                                  | Supported          |
| ---------------------------------------- | ------------------ |
| Distroless scratch image                 | :white_check_mark: |
| Unprivileged user                        | :white_check_mark: |
| Unprivileged port                        | :white_check_mark: |
| Libevent                                 | :white_check_mark: |
| DNSSEC                                   | :white_check_mark: |
| DNSCrypt                                 | :white_check_mark: |
| DNSTap                                   | :white_check_mark: |
| DNS64                                    | :white_check_mark: |
| DNS over HTTPS                           | :white_check_mark: |
| DNS over TLS                             | :white_check_mark: |
| Redis                                    | :white_check_mark: |
| Optional Healthcheck                     | :white_check_mark: |
| Optional Statistics                      | :white_check_mark: |
| Python                                   | :x:                |
| EDNS Client Subnet                       | :x:                |
    
</details>

**If you would like to have Unbound statistics, take a look [`here`](https://github.com/madnuttah/unbound-docker-stats)**

## Getting started

Docker containers are most easily used with docker compose.

 - [`Installation intructions and details`](https://github.com/madnuttah/unbound-docker/blob/main/doc/DETAILS.md)
 - [`Example docker-compose files`](https://github.com/madnuttah/unbound-docker/tree/main/doc/examples)

## Available Docker Tags

You can pull the most recent image from Docker Hub using it's `latest` tag or by using the corresponding image version number. 

The image versioning scheme follows unbound - complemented by a dash and the desired image revision, for example `1.19.0-0`.
    
## Changes
    
You can view the changelogs in the [`Releases`](https://github.com/madnuttah/unbound-docker/releases) section.

## Feedback

I am here to help! Don't hesitate to contact me through a [`GitHub Issue`](https://github.com/madnuttah/unbound-docker/issues) if you have any questions, requests or problems with the image. 

You can also reach me on Fosstodon: 

[![Follow me on Mastodon](https://img.shields.io/mastodon/follow/107779375129112763?domain=https%3A%2F%2Ffosstodon.org%2F&style=social)](https://fosstodon.org/@madnuttah)

## Acknowledgements

- [Alpine Linux](https://www.alpinelinux.org/)
- [Docker](https://www.docker.com/)
- [Unbound](https://unbound.net/)
- [OpenSSL](https://www.openssl.org/)
- [Libevent](https://libevent.org/)
- [Redis](https://redis.io/)
- [Pi-hole](https://pi-hole.net/)
- [StepSecurity](https://www.stepsecurity.io/)
- The many Docker Images which got me inspired
- **Thank you for using my image** ❤️

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
