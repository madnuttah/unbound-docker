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

[![Docker Image Version](https://img.shields.io/docker/v/madnuttah/unbound/latest?label='latest'%20version&style=flat-square "Docker Image Version")](https://hub.docker.com/r/madnuttah/unbound/tags)
[![Docker Image Size](https://img.shields.io/docker/image-size/madnuttah/unbound/latest?label=compressed%20image%20size&style=flat-square "Docker Image Size")](https://hub.docker.com/r/madnuttah/unbound/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/madnuttah/unbound?label=pulls&style=flat-square "Pulls")](https://hub.docker.com/r/madnuttah/unbound/)
[![Docker Stars](https://img.shields.io/docker/stars/madnuttah/unbound?label=stars&style=flat-square "Stars")](https://hub.docker.com/r/madnuttah/unbound/)
<br><br>

<p align="Left">
    <img width=100 src="https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png" alt="Github Logo">
</p><br>

[![GitHub version](https://img.shields.io/github/v/release/madnuttah/unbound-docker?include_prereleases&style=flat-square)](https://github.com/madnuttah/unbound-docker/releases)
[![Release date](https://img.shields.io/github/release-date/madnuttah/unbound-docker?style=flat-square)](https://github.com/madnuttah/unbound-docker/releases)
[![Latest commit main branch](https://img.shields.io/github/last-commit/madnuttah/unbound-docker/main?style=flat-square)](https://github.com/madnuttah/unbound-docker/commits/main)
[![License](https://img.shields.io/github/license/madnuttah/unbound-docker?style=flat-square "License")](https://github.com/madnuttah/unbound-docker/blob/main/LICENSE)

[![Commit Activity](https://img.shields.io/github/commit-activity/y/madnuttah/unbound-docker/main?style=flat-square)](https://github.com/madnuttah/unbound-docker/commits/main)
[![Forks](https://img.shields.io/github/forks/madnuttah/unbound-docker?style=flat-square "Forks")](https://github.com/madnuttah/unbound-docker/network/members)
[![Stars](https://img.shields.io/github/stars/madnuttah/unbound-docker?style=flat-square "Stars")](https://github.com/madnuttah/unbound-docker/stargazers)
[![Issues](https://img.shields.io/github/issues/madnuttah/unbound-docker?style=flat-square "Issues")](https://github.com/madnuttah/unbound-docker/issues)
[![Pull Requests](https://img.shields.io/github/issues-pr/madnuttah/unbound-docker?style=flat-square)](https://github.com/madnuttah/unbound-docker/pulls)

[![Build Multiarch Unbound Docker Image](https://img.shields.io/github/workflow/status/madnuttah/unbound-docker/Build%20Multiarch%20Unbound%20Docker%20Image/main?label=Unbound%20build%20status&style=flat-square)](https://github.com/madnuttah/unbound-docker/actions/workflows/build-unbound.yaml)
[![Build Multiarch OpenSSL BuildEnv Docker Image](https://img.shields.io/github/workflow/status/madnuttah/unbound-docker/Build%20Multiarch%20OpenSSL%20BuildEnv%20Docker%20Image/main?label=OpenSSL%20build%20status&style=flat-square)](https://github.com/madnuttah/unbound-docker/actions/workflows/build-openssl-buildenv.yaml)
[![Build Multiarch Libevent BuildEnv Docker Image](https://img.shields.io/github/workflow/status/madnuttah/unbound-docker/Build%20Multiarch%20Libevent%20BuildEnv%20Docker%20Image/main?label=Libevent%20build%20status&style=flat-square)](https://github.com/madnuttah/unbound-docker/actions/workflows/build-libevent-buildenv.yaml)

## Available Docker Tags

<details> 
    
  <summary>Tags</summary><br>  
    
   - [1.15.0rc1 (Pre-release)](https://hub.docker.com/r/madnuttah/unbound/tags)
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
- [Legal](#Legal)
- [Social](#Social)
   
## What is Unbound

_Unbound is a validating, recursive, caching DNS resolver._

_It is designed to be fast and lean and incorporates modern features based on open standards. 
Late 2019, Unbound has been rigorously audited, which means that the code base is more resilient than ever._

Source:
> [unbound.net](https://unbound.net/)

## About this Image

This container image is based on Alpine Linux with focus on security, performance and a small image size.
The unbound process runs in the context of a non-root user, is sealed with chroot and makes use of unprivileged ports (5335 tcp/udp).

Unbound is configured as an DNSSEC validating DNS resolver, which directly queries DNS root servers utilizing zone transfers holding a local copy of the root zone (see [IETF RFC 8806](https://www.rfc-editor.org/rfc/rfc8806.txt)) to build a "hyperlocal" setup as an upstream DNS server in combination with [Pi-hole](https://pi-hole.net/) for adblocking in mind, but works also as a standalone server. However, even though the image is intended to run a "hyperlocal" setup, it does not neccessarily mean that it has to be used that way. You are absolutely free to edit the [unbound.conf](https://www.nlnetlabs.nl/documentation/unbound/unbound.conf/) file according to your own needs and requirements, especially if you'd rather like to use an upstream DNS server which provides DoT or DoH features.
       
To provide always the latest versions, the following software components are self compiled in the build process using separated workflows and are not just installed:
    
- [`Unbound`](https://github.com/madnuttah/unbound-docker/actions/workflows/build-unbound.yaml)
- [`Libevent`](https://github.com/madnuttah/unbound-docker/actions/workflows/build-libevent-buildenv.yaml)
- [`OpenSSL`](https://github.com/madnuttah/unbound-docker/actions/workflows/build-openssl-buildenv.yaml)
    
**The image is completely built online via a [GitHub Action](https://github.com/features/actions) and _not_ locally on my systems. All components are verified with their corresponding PGP keys and signature files if available to guarantee maximum security and trust.**
      
<details> 
    
  <summary>Features</summary><br>
    
| Feature                                  | Supported          |
| ---------------------------------------- | ------------------ |
| chroot                                   | :white_check_mark: |
| Unprivileged user                        | :white_check_mark: |
| DNSSEC                                   | :white_check_mark: |
| DNSCrypt                                 | :white_check_mark: |
| DNSTap                                   | :x:                |
| DNS64                                    | :white_check_mark: |
| Draft-0x20 (caps-for-id: yes)            | :white_check_mark: |    
| DNS over HTTPS                           | :white_check_mark: |
| DNS over TLS                             | :white_check_mark: |
| QName Minimization                       | :white_check_mark: |
| Auth. zones with local copy of root zone | :white_check_mark: |
| Aggressive use of DNSSEC-Validated Cache | :white_check_mark: |
| Response Policy Zones                    | :white_check_mark: |
| EDNS Client Subnet                       | :x:                |
    
</details>

I hope you enjoy the image. 
    
## Installation

Current multiarch-builds of the image are available on [Docker Hub](https://hub.docker.com/r/madnuttah/unbound) and is the recommended source of installation on any Linux-based 386, arm, arm64 or amd64 platform.

## How to use this Image

You should adapt the [`/usr/local/unbound/unbound.conf`](https://github.com/madnuttah/unbound-docker/blob/main/unbound/root/usr/local/unbound/unbound.conf) file and my example [`docker-compose.yaml`](https://github.com/madnuttah/unbound-docker/blob/main/unbound/examples/docker-compose.yaml) file to your needs. The compose file also deploys [Pi-hole](https://pi-hole.net/) for blocking ads and [Watchtower](https://containrrr.dev/watchtower/) for keeping your images up to date. 

To provide a better structuring of the unbound.conf file, directories for **optionally** storing zone and other configuration files as well as for your certificates and the unbound.log file have been created and can be mounted as volumes: 
    
- [`/usr/local/unbound/certs.d/`](https://github.com/madnuttah/unbound-docker/tree/main/unbound/examples/usr/local/unbound/certs.d/) for storing your certificate files.

- [`/usr/local/unbound/conf.d/`](https://github.com/madnuttah/unbound-docker/tree/main/unbound/examples/usr/local/unbound/conf.d/) for your configuration files like interfaces.conf, performance.conf, security.conf, etc.
    
- [`/usr/local/unbound/iana.d/`](https://github.com/madnuttah/unbound-docker/tree/main/unbound/examples/usr/local/unbound/iana.d/) for the root.key, root.hints and root.zone files in case you need to update or view them for troubleshooting and debugging purposes.
    
- [`/usr/local/unbound/log.d/unbound.log`](https://github.com/madnuttah/unbound-docker/tree/main/unbound/examples/usr/local/unbound/log.d/unbound.log) in case you need to access it for troubleshooting and debugging purposes.

- [`/usr/local/unbound/zones.d/`](https://github.com/madnuttah/unbound-docker/tree/main/unbound/examples/usr/local/unbound/zones.d/) for your zone configuration files like auth-zone.conf, stub-zone.conf, forward-zone.conf, etc.
    
**The config files in the `conf.d` and `zones.d` folders must be named with the suffix .conf to prevent issues with specific host configurations.**
    
The splitted configuration files located in [`unbound/examples/usr/local/unbound`](https://github.com/madnuttah/unbound-docker/tree/main/unbound/examples/usr/local/unbound) are only meant to give you an impression on how to separating and structuring the configs. Please mind that those files are **examples** which also needs to be edited and even updated (root.key, root.zone, root.hints in the `iana.d` folder) to make them work for your environment if you intend to use them. It might be neccessary to fix permissions and ownership of the files put in the persistent volumes if unbound refuses to start. You can access the _running_ image by executing the following command in your shell: `sudo docker exec -ti madnuttah-unbound /bin/sh`. If you have assigned a different name for the image than `madnuttah-unbound`, this must be adjusted of course.

Other than that, splitting ain't neccessary as your standard unbound.conf will perfectly do the job.
    
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

### Environment Variables

Below is an incomplete list of available options that can be used to customize your installation.

| Parameter | Description    | Default |
| --------- | -------------- | ------- |

### Networking

| Port      | Description              |
| --------- | ------------------------ |
| `5335`    | Listening Port (TCP/UDP) |

### Standard Usage

The best way to get started is using [docker-compose](https://docs.docker.com/compose/). I have provided a combined Pi-hole/Unbound/Watchtower [`docker-compose.yaml`](https://github.com/madnuttah/unbound-docker/blob/main/unbound/examples/docker-compose.yaml) sample which I'm using in slightly modified form that makes use of a [MACVLAN](https://docs.docker.com/network/macvlan/) network which **must** be adapted to your network environment and to suit your needs for development or production use. **Especially all entries in angle brackets (<>) needs your very attention!** 

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
    
There's also a dedicated Unbound documentation website which can be accessed using this [link](https://unbound.docs.nlnetlabs.nl/en/latest/).

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

## Legal

Please note that this is a work of a private contributor and I'm neither affiliated with NLnetLabs or Pi-Hole nor is NLnetLabs or Pi-Hole involved in the development of the image. The marks and properties, 'Unbound' and 'Pi-Hole' are properties of NLnetLabs and Pi-Hole. All rights in the source codes, including logos relating to said marks and properties belong to their respective owners.
    
## Social
    
### Twitter
    
Stay up-to-date with the development by following my Twitter account.

[![Follow me on Twitter](https://img.shields.io/twitter/follow/madnuttah?style=social)](https://twitter.com/madnuttah)
