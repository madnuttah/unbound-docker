<p align="center">
    <img src="https://repository-images.githubusercontent.com/440215882/b79c7ae3-c3d4-4a6a-a1d7-d27fa626754b" alt="Logo">
</p>

# Alpine Linux Based Unbound Hyperlocal & DNSSEC Validating DNS Server Multiarch Docker Image

## Maintainer

- [`madnuttah`](https://github.com/madnuttah/)

## Statistics

<p align="Left">
    <img width=100 src="https://www.docker.com/sites/default/files/d8/2019-07/horizontal-logo-monochromatic-white.png" alt="Docker Logo">
</p><br>

[![Docker Image Version](https://img.shields.io/docker/v/madnuttah/unbound/latest "Docker Image Version")](https://hub.docker.com/r/madnuttah/unbound/tags)
[![Docker Image Size](https://img.shields.io/docker/image-size/madnuttah/unbound/latest "Docker Image Size")](https://hub.docker.com/r/madnuttah/unbound/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/madnuttah/unbound "Docker Pulls")](https://hub.docker.com/r/madnuttah/unbound/)
[![Docker Stars](https://img.shields.io/docker/stars/madnuttah/unbound "Docker Start")](https://hub.docker.com/r/madnuttah/unbound/)
<br><br>

<p align="Left">
    <img width=100 src="https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png" alt="Github Logo">
</p>

<a href="https://github.com/madnuttah/unbound-docker">
  <img align="top" style="margin:1.0rem" src=https://github-readme-stats.vercel.app/api?username=madnuttah&repo=unbound-docker&show_icons=true&title_color=9f9f9f&icon_color=79ff97&text_color=9f9f9f&bg_color=00ff0000&disable_animations=true&hide_border=true&hide=contribs&count_private=false&hide_title=true)
/><br>

<a href="https://github.com/madnuttah/unbound-docker">
  <img align="top" style="margin:1.0rem" src=https://github-readme-stats.vercel.app/api/top-langs/?username=madnuttah&&repo=unbound-docker&layout=compact&show_icons=true&title_color=9f9f9f&icon_color=79ff97&text_color=9f9f9f&bg_color=00ff0000&disable_animations=true&hide_border=true&hide_title=true)
/><br><br>
    
[![Build Multiarch Unbound Docker Images](https://img.shields.io/github/workflow/status/madnuttah/unbound-docker/Build%20Multiarch%20Unbound%20Docker%20Images/main)](https://github.com/madnuttah/unbound-docker/actions/workflows/build-multiarch-docker-images.yaml)
[![Release date](https://img.shields.io/github/release-date/madnuttah/unbound-docker)](https://github.com/madnuttah/unbound-docker/releases)
[![Latest commit main branch](https://img.shields.io/github/last-commit/madnuttah/unbound-docker/main)](https://github.com/madnuttah/unbound-docker/commits/main)
[![License](https://img.shields.io/github/license/madnuttah/unbound-docker "License")](https://github.com/madnuttah/unbound-docker/blob/main/LICENSE)

## Supported Docker Tags

<details> 
    
  <summary>Tags</summary>
    
   - [1.14.0, latest](https://hub.docker.com/r/madnuttah/unbound/tags)
    
</details>
    
## Changes
    
You can view the changelogs in the [`Releases`](https://github.com/madnuttah/unbound-docker/releases) section.
    
## Table of Contents

- [What is Unbound](#What-is-Unbound)
- [About this Image](#About-this-Image)
- [Installation](#Installation)
- [How to use this Image](#How-to-use-this-Image)
  - [Folder Structure](#Folder-Structure)
  - [Environment Variables](#Environment-Variables)
  - [Standard Usage](#Standard-Usage)
- [Documentation and Feedback](#Documentation-and-Feedback)
  - [Documentation](#Documentation)
  - [Feedback](#Feedback)
  - [Contributing](#Contributing)
- [Acknowledgements](#Acknowledgements)
- [Licenses](#Licenses)
- [Social](#Social)
   
## What is Unbound

_Unbound is a validating, recursive, caching DNS resolver._

_It is designed to be fast and lean and incorporates modern features based on open standards. 
Late 2019, Unbound has been rigorously audited, which means that the code base is more resilient than ever._

Source:
> [unbound.net](https://unbound.net/)

## About this Image

This container image is based on Alpine Linux with focus on security, performance and a small image size.
The unbound process runs in the context of a non-root user, is sealed with chroot and utilizes unprivileged ports (5335 tcp/udp).

Unbound is configured as an DNSSEC validating DNS resolver, which directly queries DNS root servers utilizing zone transfers to build a "hyperlocal" setup as an upstream DNS server in combination with [Pi-hole](https://pi-hole.net/) for adblocking in mind, but works also as a standalone server. However, even though the image is intended to run a "hyperlocal" setup, it does not neccessarily mean that it has to be used that way. You are absolutely free to edit the [unbound.conf](https://www.nlnetlabs.nl/documentation/unbound/unbound.conf/) file according to your own needs and requirements, especially if you'd rather like to use an upstream DNS server which provides DoT or DoH features.
       
To provide always the latest versions, the following software components are self compiled in the build process and are not just installed:
    
- Unbound
- Libevent
- OpenSSL
    
**The image is completely built online via a [GitHub Action](https://github.com/features/actions) and _not_ locally on my systems. All components are verified with their corresponding PGP keys and signature files if available to guarantee maximum security and trust.**
    
I hope you enjoy the image as much as I do.
  
## Installation

Current multiarch-builds of the image are available on [Docker Hub](https://hub.docker.com/r/madnuttah/unbound) and is the recommended method of installation on any Linux-based 386, arm, arm64 or amd64 platform.

## How to use this Image

You should adapt the [`/usr/local/unbound/unbound.conf`](https://github.com/madnuttah/unbound-docker/blob/main/root/usr/local/unbound/unbound.conf) file and my example [`docker-compose.yaml`](https://github.com/madnuttah/unbound-docker/blob/main/examples/docker-compose.yaml) file to your needs. The compose file also deploys [Pi-hole](https://pi-hole.net/) for blocking ads and [Watchtower](https://containrrr.dev/watchtower/) for keeping your images up to date. 

To provide a better structuring of the unbound.conf file, folders for optionally storing zone and other configuration files as well as for your certificates and the unbound.log file have been created and can be mounted as volumes: 
    
- [`/usr/local/unbound/certs.d/`](https://github.com/madnuttah/unbound-docker/tree/main/examples/usr/local/unbound/certs.d/) for storing your certificate files.

- [`/usr/local/unbound/conf.d/`](https://github.com/madnuttah/unbound-docker/tree/main/examples/usr/local/unbound/conf.d/) for your configuration files like interfaces.conf, performance.conf, security.conf, etc.
    
- [`/usr/local/unbound/log.d/`](https://github.com/madnuttah/unbound-docker/tree/main/examples/usr/local/unbound/log.d/) for your unbound.log in case you need to view it for troubleshooting and debugging purposes.

- [`/usr/local/unbound/zones.d/`](https://github.com/madnuttah/unbound-docker/tree/main/examples/usr/local/unbound/zones.d/) for your zone configuration files like auth-zone.conf, stub-zone.conf, forward-zone.conf, etc.
    
The splitted configuration files located in [`examples/usr/local/unbound`](https://github.com/madnuttah/unbound-docker/tree/main/examples/usr/local/unbound) are meant to give you an impression on how to structure the configs. Please mind that those files are just examples which also needs to be edited to make them work for your environment. Other than that, splitting ain't neccessary as your standard unbound.conf will perfectly do the job.
    
**These config files must be named with the suffix .conf - except the unbound.log and your certificate files of course.**

### Folder Structure

<details> 
    
  <summary>Filesystem</summary>
    
```
/usr/local/
├── libevent
│   └── ...
├── openssl
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

### Environment Variables

Below is an incomplete list of available options that can be used to customize your installation.

| Parameter | Description    | Default |
| --------- | -------------- | ------- |

### Networking

| Port      | Description              |
| --------- | ------------------------ |
| `5335`    | Listening Port (TCP/UDP) |

### Standard Usage

The best way to get started is using [docker-compose](https://docs.docker.com/compose/). I have provided a Pi-hole/Unbound/Watchtower [`docker-compose.yaml`](https://github.com/madnuttah/unbound-docker/blob/main/examples/docker-compose.yaml) sample which I'm using in slightly modified form that makes use of a [MACVLAN](https://docs.docker.com/network/macvlan/) network which **must** be adapted to your network environment and to suit your needs for development or production use. **Especially all entries in angle brackets (<>) needs your very attention!** 

*I prefer using a MACVLAN network configuration instead of a bridged or rather unsafe host network, but other network configurations will run as well.*

Anyway, you can also spin up the container with the following command:

```console
docker run --name madnuttah-unbound -d \
-p 5335:5335/udp \
-p 5335:5335/tcp \
--restart=unless-stopped \
madnuttah/unbound:latest
```

# Documentation and Feedback

## Documentation

In-depth documentation for NLnetLabs Unbound is available on the [Unbound project's website](https://unbound.net/) and [here](https://www.nlnetlabs.nl/documentation/unbound/unbound.conf/) goes a direct link to the documentation of the default unbound.conf file. 
    
There'a also a dedicated Unbound documentation website which can be accessed using this [link](https://unbound.docs.nlnetlabs.nl/en/latest/).

## Feedback

Feel free to contact me through a [`GitHub Issue`](https://github.com/madnuttah/unbound-docker/issues) if you have any questions, requests for new features or encounter problems with the image.

## Contributing

If you like to contribute to this repository, take a look at the [`Contributing Guidelines`](https://github.com/madnuttah/unbound-docker/blob/main/CONTRIBUTING.md).

## Acknowledgements

- [Alpine Linux](https://www.alpinelinux.org/)
- [Docker](https://www.docker.com/)
- [Unbound](https://unbound.net/)
- [OpenSSL](https://www.openssl.org/)
- [Libevent](https://libevent.org/)
- [Pi-hole](https://pi-hole.net/)
- [Watchtower](https://containrrr.dev/watchtower/)
- **Thank you for using my image** :heart:

## Licenses

### License

Unless otherwise specified, all code is released under the MIT license.
See the [`LICENSE`](https://github.com/madnuttah/unbound-docker/blob/main/LICENSE) for details.

### Licenses for other components

- Docker: [Apache 2.0](https://github.com/docker/docker/blob/master/LICENSE)
- Unbound: [BSD License](https://unbound.nlnetlabs.nl/svn/trunk/LICENSE)
- OpenSSL: [Apache-style license](https://www.openssl.org/source/license.html)
- Libevent: [BSD License](https://libevent.org/LICENSE.txt)
    
## Social
    
### Twitter
    
Stay up-to-date with the development by following my Twitter account.

[![Follow me on Twitter](https://img.shields.io/twitter/follow/madnuttah?style=social)](https://twitter.com/madnuttah)
