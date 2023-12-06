## Statistics

<p align="Left">
    <img width=100 src="https://www.docker.com/wp-content/uploads/2022/03/horizontal-logo-monochromatic-white.png" alt="Docker Logo">
</p><br>

[![Docker](https://img.shields.io/badge/Docker%20Hub-madnuttah/unbound-blue.svg?logo=docker&style=flat-square)](https://hub.docker.com/r/madnuttah/unbound/)

[![Docker Image Version](https://img.shields.io/docker/v/madnuttah/unbound/latest?label='latest'%20version&style=flat-square "Docker Image Version")](https://hub.docker.com/r/madnuttah/unbound/tags)
[![Docker Image Size](https://img.shields.io/docker/image-size/madnuttah/unbound/latest?label=compressed%20image%20size&style=flat-square "Docker Image Size")](https://hub.docker.com/r/madnuttah/unbound/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/madnuttah/unbound?label=pulls&style=flat-square "Pulls")](https://hub.docker.com/r/madnuttah/unbound/)
[![Docker Stars](https://img.shields.io/docker/stars/madnuttah/unbound?label=stars&style=flat-square "Stars")](https://hub.docker.com/r/madnuttah/unbound/)
<br><br>

<p align="Left">
    <img width=100 src="https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png" alt="Github Logo">
</p><br>

[![Maintenance](https://img.shields.io/maintenance/yes/2023?style=flat-square)](https://github.com/madnuttah/unbound-docker/)
[![Commit Activity](https://img.shields.io/github/commit-activity/y/madnuttah/unbound-docker/main?style=flat-square)](https://github.com/madnuttah/unbound-docker/commits/main)
[![Forks](https://img.shields.io/github/forks/madnuttah/unbound-docker?style=flat-square "Forks")](https://github.com/madnuttah/unbound-docker/network/members)
[![Stars](https://img.shields.io/github/stars/madnuttah/unbound-docker?style=flat-square "Stars")](https://github.com/madnuttah/unbound-docker/stargazers)
[![Issues](https://img.shields.io/github/issues/madnuttah/unbound-docker?style=flat-square "Issues")](https://github.com/madnuttah/unbound-docker/issues)
[![Pull Requests](https://img.shields.io/github/issues-pr/madnuttah/unbound-docker?style=flat-square)](https://github.com/madnuttah/unbound-docker/pulls)

## Image Dependencies Versions

[![Current Alpine Linux release](https://img.shields.io/docker/v/_/alpine/latest?label=Current%20Alpine%20Linux%20release&style=flat-square)](https://github.com/alpinelinux/docker-alpine)
[![Current Unbound release](https://img.shields.io/github/v/tag/nlnetlabs/unbound?label=Current%20Unbound%20release&style=flat-square)](https://github.com/NLnetLabs/unbound/tags)
[![Current OpenSSL release](https://img.shields.io/github/v/tag/openssl/openssl?label=Current%20OpenSSL%20release&style=flat-square)](https://github.com/openssl/openssl/tags)
[![Current Libevent release](https://img.shields.io/github/v/tag/libevent/libevent?label=Current%20Libevent%20release&style=flat-square)](https://github.com/libevent/libevent/tags)

## Table of Contents

- [What is Unbound](#What-is-Unbound)
- [About this Image](#About-this-Image)
- [Installation](#Installation)
- [How to use this Image](#How-to-use-this-Image)
  - [Folder Structure](#Folder-Structure)
  - [Networking](#Networking)
  - [Usage](#Usage)
  - [CacheDB (REDIS)](#CacheDB-REDIS)
- [Troubleshooting](#Troubleshooting)  
- [Documentation](#Documentation)
   
## What is Unbound

> _Unbound is a validating, recursive, caching DNS resolver._
> _It is designed to be fast and lean and incorporates modern features based on open standards. 
Late 2019, Unbound has been rigorously audited, which means that the code base is more resilient than ever._

Source: [unbound.net](https://unbound.net/)

## About this Image

This container image is based on Alpine Linux with focus on security, performance and a small image size.
The unbound process runs in the context of a non-root user, is sealed with chroot and makes use of unprivileged ports (5335 tcp/udp).

Unbound is configured as an DNSSEC validating DNS resolver, which directly queries DNS root servers utilizing zone transfers holding a local copy of the root zone (see [IETF RFC 8806](https://www.rfc-editor.org/rfc/rfc8806.txt)) to build a "hyperlocal" setup as a recursive upstream DNS server in combination with [Pi-hole](https://pi-hole.net/) for adblocking in mind, but works also as a standalone server. 

__There's a really nice explanation at the [Pi-hole documentation page](https://docs.pi-hole.net/guides/dns/unbound/) of what that means without becoming too technical:__

>_**Whom can you trust?**_ _Recently, more and more small (and not so small) DNS upstream providers have appeared on the market, advertising free and private DNS service, but how can you know that they keep their promises? Right, you can't.
>Furthermore, from the point of an attacker, the DNS servers of larger providers are very worthwhile targets, as they only need to poison one DNS server, but millions of users might be affected. Instead of your bank's actual IP address, you could be sent to a phishing site hosted on some island. This scenario has already happened and it isn't unlikely to happen again...
>When you operate your own (tiny) recursive DNS server, then the likeliness of getting affected by such an attack is greatly reduced._

However, even though the image is intended to run a "hyperlocal" setup, it does not necessarily mean that it has to be used that way. You are absolutely free to edit the [unbound.conf](https://www.nlnetlabs.nl/documentation/unbound/unbound.conf/) file according to your own needs and requirements, especially if you'd rather like to use an upstream DNS server which provides [DoT](https://en.wikipedia.org/wiki/DNS_over_TLS) or [DoH](https://en.wikipedia.org/wiki/DNS_over_HTTPS) features instead of using the "hyperlocal" feature.
       
To provide always the latest stable versions, the following software components are self compiled in the build process using separated workflows and are not just installed:
    
- [`Unbound`](https://github.com/madnuttah/unbound-docker/actions/workflows/build-unbound.yaml)
- [`Libevent`](https://github.com/madnuttah/unbound-docker/actions/workflows/build-libevent-buildenv.yaml)
- [`OpenSSL`](https://github.com/madnuttah/unbound-docker/actions/workflows/build-openssl-buildenv.yaml)
    
**The image is completely built online via [GitHub Actions](https://github.com/features/actions) with [hardened runners by StepSecurity](https://github.com/step-security/harden-runner) and _not_ locally on my systems. All components as well as the Internic files (root.hints and root.zone) are verified with their corresponding PGP keys and signature files if available to guarantee maximum security and trust.**

**Unbound itself is compiled from source with hardening security features such as [PIE](https://en.wikipedia.org/wiki/Position-independent_code) (Position Independent Executables), which randomizes the application's position in memory which makes attacks more difficult and [RELRO](https://www.redhat.com/en/blog/hardening-elf-binaries-using-relocation-read-only-relro) (Relocation Read-Only) which also can mitigate exploitations by preventing memory corruption.**
      
<details> 
    
  <summary>Features</summary><br>
    
| Feature                                  | Supported          |
| ---------------------------------------- | ------------------ |
| chroot                                   | :white_check_mark: |
| Unprivileged user                        | :white_check_mark: |
| DNSSEC                                   | :white_check_mark: |
| DNSCrypt                                 | :white_check_mark: |
| DNSTap                                   | :white_check_mark: |
| DNS64                                    | :white_check_mark: |
| Draft-0x20 (caps-for-id: yes)            | :white_check_mark: |    
| DNS over HTTPS                           | :white_check_mark: |
| DNS over TLS                             | :white_check_mark: |
| QName Minimization                       | :white_check_mark: |
| Auth. zones with local copy of root zone | :white_check_mark: |
| Aggressive use of DNSSEC-Validated Cache | :white_check_mark: |
| Response Policy Zones                    | :white_check_mark: |
| REDIS                    | :white_check_mark: |
| Python.                                  | :x:                |
| EDNS Client Subnet                       | :x:                |
    
</details>

I hope you enjoy the image as much as I do. 
    
## Installation

Multiarch-builds for Linux-based 386, arm, arm64 or amd64 platforms are available on [Docker Hub](https://hub.docker.com/r/madnuttah/unbound).

## How to use this Image

Please adapt the [`/usr/local/unbound/unbound.conf`](https://github.com/madnuttah/unbound-docker/blob/main/unbound/root/usr/local/unbound/unbound.conf) file and my example [`docker-compose.yaml`](https://github.com/madnuttah/unbound-docker/tree/main/unbound/examples) files to your needs. The docker-compose files also deploy [Pi-hole](https://pi-hole.net/) for blocking ads and to prevent tracking.

To provide a better structuring of the unbound.conf file, directories for **optionally** storing zone and other configuration files as well as for your certificates and the unbound.log file have been created and can be mounted as volumes: 
    
- [`/usr/local/unbound/certs.d/`](https://github.com/madnuttah/unbound-docker/tree/main/unbound/examples/usr/local/unbound/certs.d/) for storing your certificate files.

- [`/usr/local/unbound/conf.d/`](https://github.com/madnuttah/unbound-docker/tree/main/unbound/examples/usr/local/unbound/conf.d/) for your configuration files like interfaces.conf, performance.conf, security.conf, etc.
    
- [`/usr/local/unbound/log.d/unbound.log`](https://github.com/madnuttah/unbound-docker/tree/main/unbound/examples/usr/local/unbound/log.d/unbound.log) in case you need to access it for troubleshooting and debugging purposes.

- [`/usr/local/unbound/zones.d/`](https://github.com/madnuttah/unbound-docker/tree/main/unbound/examples/usr/local/unbound/zones.d/) for your zone configuration files like auth-zone.conf, stub-zone.conf, forward-zone.conf, etc.
    
**The config files in the `conf.d` and `zones.d` folders must be named with the suffix .conf to prevent issues with specific host configurations.**
    
The splitted configuration files located in [`unbound/examples/usr/local/unbound`](https://github.com/madnuttah/unbound-docker/tree/main/unbound/examples/usr/local/unbound) are only meant to give you an impression on how to separating and structuring the configs. Please mind that those files are **examples** which also needs to be edited to make them work for your environment if you intend to use them. It might be necessary to fix permissions and ownership of the files put in the persistent volumes if unbound refuses to start. 

Other than that, splitting ain't really necessary as your standard unbound.conf will perfectly do the job.
    
### Folder Structure

<details> 
    
  <summary>Filesystem</summary><br>
    
```
/usr/local/
├── libevent/
│   └── ...
├── openssl/
│   └── ... 
├── sbin/
│   ├── healthcheck.sh 
│   ├── unbound.sh 
│   └── ...
├── unbound/
│   ├── certs.d/
│   │   └── ...
│   ├── conf.d/
│   │   └── *.conf
│   ├── iana.d/
│   │   ├── root.hints
│   │   ├── root.key
│   │   └── root.zone
│   ├── log.d/
│   │   └── unbound.log
│   ├── unbound.d/
│   │   ├── lib/
│   │   │   └── libunbound.*
│   │   ├── sbin/
│   │   │   ├── unbound
│   │   │   ├── unbound-anchor
│   │   │   ├── unbound-checkconf
│   │   │   ├── unbound-control
│   │   │   ├── unbound-control-setup
│   │   │   └── unbound-host
│   │   ├── null
│   │   ├── random
│   │   ├── urandom
│   │   └── unbound.pid
│   ├── zones.d/
│   │   └── *.conf
│   └── unbound.conf 
├── ...
...
```
    
</details>

### Networking

| Port      | Description              |
| --------- | ------------------------ |
| `5335`    | Listening Port (TCP/UDP) |

If you want to use this image as a standalone DNS resolver _without_ Pi-hole, the given ports must be changed to `53` (TCP/UDP) in your unbound.conf and docker-compose.yaml.

### Usage

The most elegant way to get started is using [docker-compose](https://docs.docker.com/compose/). I have provided combined Pi-hole/Unbound [`docker-compose.yaml`](https://github.com/madnuttah/unbound-docker/blob/main/unbound/examples/) samples which I'm using in slightly modified form that makes use of a combined [MACVLAN/Bridge](https://docs.docker.com/network/macvlan/) or [Bridge](https://docs.docker.com/network/bridge/) network which **must** be adapted to your network environment and to suit your needs. **Especially all entries in angle brackets (<>) needs your very attention!** 

*I prefer using a combined MACVLAN/Bridge network configuration, but other network configurations will run as well.* 

I have added a custom bridge network to the [`MACVLAN example`](https://github.com/madnuttah/unbound-docker/blob/main/unbound/examples/docker-compose.yaml%20(mcvlan)) so your host is able communicate with the container and vice versa. If you don't like to have an additional bridge network, take a look at [this workaround](https://blog.oddbit.com/post/2018-03-12-using-docker-macvlan-networks/).

Anyway, you can also spin up the container with the following command:

```console
docker run --name madnuttah-unbound -d \
-p 5335:5335/udp \
-p 5335:5335/tcp \
--restart=unless-stopped \
madnuttah/unbound:latest
```

### CacheDB REDIS

I prefer accessing the CacheDB rather via socket than via TCP, you can learn about the benefits [here](https://www.techandme.se/performance-tips-for-redis-cache-server/).

Due to the `chroot` environment of the image, it's not possible to just map and access the redis server's socket but had to use a "proxy" container which provides access for both containers, `unbound` as well as `redis`, so there's an additional busybox container containing the socket in an own volume.

You need to enable the module in your `unbound.conf` first:

```
server:
  module-config: "cachedb validator iterator"
```

Create a new mountpoint like `.../unbound-db/`, make it available via `fstab` and place this [`redis.conf`](https://raw.githubusercontent.com/madnuttah/unbound-docker/main/doc/redis/examples/redis.conf) there.

Place a new entry for cachedb in your `unbound.conf` from my [`cachedb.conf`](https://raw.githubusercontent.com/madnuttah/unbound-docker/main/doc/redis/examples/cachedb.conf) or put the file in your `conf.d` directory.

Extend your ***existing*** `docker-compose.yaml` `servers:` section with the content of [`this snippet`](https://raw.githubusercontent.com/madnuttah/unbound-docker/main/doc/redis/examples/docker-compose_snippet.yaml).

# Troubleshooting

You can access the _running_ image by executing the following command in your shell: `sudo docker exec -ti madnuttah-unbound /bin/sh`. If you have assigned a different name for the image than `madnuttah-unbound`, this must be adjusted of course.

# Documentation

In-depth documentation for NLnet Labs Unbound is available on the [Unbound documentation website](https://unbound.docs.nlnetlabs.nl/en/latest/) and [here](https://www.nlnetlabs.nl/documentation/unbound/unbound.conf/) goes a direct link to the documentation of the default unbound.conf file. 
