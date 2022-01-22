<p align="center">
    <img src="https://repository-images.githubusercontent.com/440215882/b79c7ae3-c3d4-4a6a-a1d7-d27fa626754b" alt="Logo">
</p>

# Alpine Linux Based Unbound Hyperlocal & DNSSEC Validating DNS Server Docker Image

<p align="Left">
    <img width=100 src="https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png" alt="Github Logo">
</p>

[![Build Multiarch Unbound Docker Images](https://github.com/madnuttah/unbound-docker/actions/workflows/build-multiarch-docker-images.yaml/badge.svg?branch=main)](https://github.com/madnuttah/unbound-docker/actions/workflows/build-multiarch-docker-images.yaml)<br>
[![Release date](https://img.shields.io/github/release-date/madnuttah/unbound-docker)](https://github.com/madnuttah/unbound-docker/releases)
[![Latest commit main branch](https://img.shields.io/github/last-commit/madnuttah/unbound-docker/main)](https://github.com/madnuttah/unbound-docker/commits/main)
[![License](https://img.shields.io/github/license/madnuttah/unbound-docker "License")](https://github.com/madnuttah/unbound-docker/blob/main/LICENSE)


<a href="https://github.com/madnuttah">
  <img align="top" style="margin:0.5rem" src=https://github-readme-stats.vercel.app/api?username=madnuttah&repo=unbound-docker&show_icons=true&title_color=9f9f9f&icon_color=79ff97&text_color=9f9f9f&bg_color=00ff0000&disable_animations=true&hide_border=true&hide=contribs,commits&count_private=false&hide_title=true)
/>

<a href="https://github.com/madnuttah">
  <img align="top" style="margin:0.5rem" src=https://github-readme-stats.vercel.app/api/top-langs/?username=madnuttah&&repo=unbound-docker&show_icons=true&title_color=9f9f9f&icon_color=79ff97&text_color=9f9f9f&bg_color=00ff0000&disable_animations=true&hide_border=true&hide_title=true)
/><br>

<p align="Left">
    <img width=100 src="https://www.docker.com/sites/default/files/d8/2019-07/horizontal-logo-monochromatic-white.png" alt="Docker Logo">
</p>

[![Docker Image Size](https://img.shields.io/docker/image-size/madnuttah/unbound/latest "Docker Image Size")](https://hub.docker.com/r/madnuttah/unbound/)
[![Docker Pulls](https://img.shields.io/docker/pulls/madnuttah/unbound "Docker Pulls")](https://hub.docker.com/r/madnuttah/unbound/)
[![Docker Stars](https://img.shields.io/docker/stars/madnuttah/unbound "Docker Start")](https://hub.docker.com/r/madnuttah/unbound/)
  
## Maintainer

- [`madnuttah`](https://github.com/madnuttah/)

## Supported Docker tags

<details> 
    
  <summary>Tags</summary>
    
   - [1.14.0, latest](https://hub.docker.com/r/madnuttah/unbound/tags)
    
</details>
    
## Table of Contents

- [What is Unbound](#What-is-Unbound)
- [About this image](#About-this-image)
- [Installation](#Installation)
- [How to use this image](#How-to-use-this-image)
  - [Folder structure](#Folder-structure)
  - [Environment Variables](#Environment-Variables)
  - [Standard usage](#Standard-usage)
- [Documentation and feedback](#Documentation-and-feedback)
  - [Documentation](#Documentation)
  - [Feedback](#Feedback)
  - [Contributing](#Contributing)
- [Acknowledgements](#Acknowledgements)
- [Licenses](#Licenses)
   
## What is Unbound

Unbound is a validating, recursive, caching DNS resolver. 

It is designed to be fast and lean and incorporates modern features based on open standards. 
Late 2019, Unbound has been rigorously audited, which means that the code base is more resilient than ever.

> [unbound.net](https://unbound.net/)

## About this image

This container image is based on Alpine Linux with focus on security, performance and a small image size.
The unbound process runs in the context of a non-root user, is sealed with chroot and utilizes unprivileged ports (5335 tcp/udp).

Unbound is configured as an DNSSEC aware DNS resolver, which directly queries DNS root servers utilizing zone transfers to build a "hyperlocal" setup as an upstream DNS server in combination with [Pi-hole](https://pi-hole.net/) for adblocking in mind, but works also as a standalone server.

The image is completely built online via a [Github action](https://github.com/features/actions) and not locally on my systems. All downloads are verified with their corresponding PGP keys and signature files if available to guarantee maximum security and trust.

## Installation

Current multiarch-builds of the image are available on [Docker Hub](https://hub.docker.com/r/madnuttah/unbound) and is the recommended method of installation on any Linux 386, arm, arm64 or amd64 platform.

## How to use this image

You should adapt the [`/usr/local/unbound/unbound.conf`](https://github.com/madnuttah/unbound-docker/blob/main/root/usr/local/unbound/unbound.conf) file and my example [`docker-compose.yaml`](https://github.com/madnuttah/unbound-docker/blob/main/examples/docker-compose.yaml) file to your needs. The compose file also deploys [Pi-hole](https://pi-hole.net/) and [Watchtower](https://containrrr.dev/watchtower/) for keeping your images up to date. 

For a better structuring of the unbound.conf file, folders for storing zone and other configuration files have been created and can be mounted as volumes: 

- "/usr/local/unbound/conf.d/" for your configuration files like interfaces.conf, performance.conf, security.conf, etc.

- "/usr/local/unbound/zones.d/" for your zone configuration files like auth-zone.conf, stub-zone.conf, etc.

**These files must be named with the suffix .conf.**

### Folder structure

<details> 
    
  <summary>/usr/local/</summary>
    
```
├── libevent
│   └── ...
├── openssl
│   └── ... 
├── unbound/
│   ├── conf.d/
│   │   └── *.conf
│   ├── iana.d/
│   │   ├── root.hints
│   │   ├── root.key
│   │   └── root.zone
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
│   ├── log.d/
│   │   └── unbound.log
│   ├── zones.d/
│   │   └── *.conf
│   └── unbound.conf 
├── ...
...
```
    
</details>

### Environment Variables

Below is an incomplete list of available options that can be used to customize your installation.

| Parameter | Description    | Default |
| --------- | -------------- | ------- |

### Networking

| Port      | Description              |
| --------- | ------------------------ |
| `5335`    | Listening Port (TCP/UDP) |

### Standard usage

The best way to get started is using [docker-compose](https://docs.docker.com/compose/). I have provided a Pi-hole/Unbound/Watchtower [`docker-compose.yaml`](https://github.com/madnuttah/unbound-docker/blob/main/examples/docker-compose.yaml) sample which I'm using in slightly modified form that makes use of a MACVLAN network which **must** be adapted to your network environment and to suit your needs for development or production use. **Especially all entries in angle brackets needs your very attention**! 

*I prefer using a [MACVLAN](https://docs.docker.com/network/macvlan/) network configuration instead of a bridged or rather unsafe host network, but other network configurations will run as well*

Anyway, you can also run this container with the following command:

```console
docker run --name madnuttah-unbound -d \
-p 5335:5335/udp \
-p 5335:5335/tcp \
--restart=unless-stopped \
madnuttah/unbound:latest
```

# Documentation and feedback

## Documentation

You can find the documentation of this image here: [`RREADME.md`](https://github.com/madnuttah/unbound-docker/blob/master/README.md).

In-depth documentation for Unbound is available on the [Unbound project's website](https://unbound.net/).

## Feedback

Feel free to contact me through a [`GitHub issue`](https://github.com/madnuttah/unbound-docker/issues) if you have any questions, requests for new features or encounter problems with this image.

## Contributing

If you intend to contribute to this repo, just go ahead and make a [`pull request`](https://github.com/madnuttah/unbound-docker/pulls). I'd love to see what you made to improve the image.

## Acknowledgements

- [Alpine Linux](https://www.alpinelinux.org/)
- [Docker](https://www.docker.com/)
- [Unbound](https://unbound.net/)
- [OpenSSL](https://www.openssl.org/)
- [libevent](https://libevent.org/)
- [Pi-hole](https://pi-hole.net/)
- [Watchtower](https://containrrr.dev/watchtower/)
- You. Thank you for using my image.

## Licenses

### License

Unless otherwise specified, all code is released under the MIT license.
See the [`LICENSE`](https://github.com/madnuttah/unbound-docker/blob/main/LICENSE) for details.

### Licenses for other components

- Docker: [Apache 2.0](https://github.com/docker/docker/blob/master/LICENSE)
- Unbound: [BSD License](https://unbound.nlnetlabs.nl/svn/trunk/LICENSE)
- OpenSSL: [Apache-style license](https://www.openssl.org/source/license.html)
- libevent: [BSD License](https://libevent.org/LICENSE.txt)
