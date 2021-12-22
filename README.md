# Alpine Linux Based Unbound Hyperlocal & DNSSEC Validating DNS Server Docker Image

<p align="Left">
    <img width=100 src="https://www.docker.com/sites/default/files/d8/2019-07/horizontal-logo-monochromatic-white.png" alt="Docker Logo">
</p>

![Docker Image Size](https://img.shields.io/docker/image-size/madnuttah/unbound/latest "Docker Image Size")
![Docker Pulls](https://img.shields.io/docker/pulls/madnuttah/unbound "Docker Pulls")
![Docker Stars](https://img.shields.io/docker/stars/madnuttah/unbound "Docker Start")
  
<p align="Left">
    <img width=100 src="https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png" alt="Github Logo">
</p>

![Issues](https://img.shields.io/github/issues/madnuttah/unbound-docker "Issues")
![Forks](https://img.shields.io/github/forks/madnuttah/unbound-docker "Forks")
![Stars](https://img.shields.io/github/stars/madnuttah/unbound-docker "Stars")
![License](https://img.shields.io/github/license/madnuttah/unbound-docker "License")
  
## Maintainer

- [`madnuttah`](https://github.com/madnuttah/)

## Supported tags and respective `Dockerfile` links

- [`1.14.0`, `latest` (*1.14.0/Dockerfile*)](Dockerfile)

#### Changes

- [`Changelog`](https://github.com/madnuttah/unbound-docker/blob/master/CHANGELOG.md)

## Table of Contents

- ![What is Unbound](#What-is-Unbound)
- [About this image](#About-this-image)
- [Installation](#Installation)
- [How to use this image](#How-to-use-this-image)
  - [Environment Variables](#Environment-Variables)
  - [Standard usage](#Standard-usage)
- [Documentation and feedback](#Documentation-and-feedback)
  - [Documentation](#Documentation)
  - [Issues](#Issues)
- [Acknowledgements](#Acknowledgements)
- [Licenses](#Licenses)
   
## What is Unbound

Unbound is a validating, recursive, caching DNS resolver. 

It is designed to be fast and lean and incorporates modern features based on open standards. 
Late 2019, Unbound has been rigorously audited, which means that the code base is more resilient than ever.

> [unbound.net](https://unbound.net/)

## About this image

This container image is based on a customized Alpine Linux base with focus on security, performance and a small image size.
The unbound process runs in the context of a non-root user, is jailed with chroot and utilizes unprivileged ports (5335 tcp/udp).

Unbound is configured as an DNSSEC aware DNS resolver, which directly queries DNS root servers utilizing zone tranfers 
to build a "hyperlocal" setup as an upstream DNS server in combination with e.g. PiHole for adblocking, but works also as a standalone server.

## Installation

Current builds of the image are available on [Docker Hub](https://hub.docker.com/r/madnuttah/unbound) and is the recommended method of installation.

## How to use this image

### Environment Variables

Below is the complete list of available options that can be used to customize your installation.

| Parameter | Description    | Default |
| --------- | -------------- | ------- |

### Networking

| Port      | Description              |
| --------- | ------------------------ |
| `5335`    | Listening Port (TCP/UDP) |

### Standard usage

My recommended way to get started is using [docker-compose](https://docs.docker.com/compose/). I have provided a working Pi-Hole/Unbound [`docker-compose.yaml`](https://github.com/madnuttah/unbound-docker/blob/main/examples/docker-compose.yaml) sample that makes use of a MCVLAN network which **must** be adapted to your network environment and to suit your needs for development or production use.

Anyway, you can also run this container with the following command:

```console
docker run --name madnuttah-unbound -d \
-p 5335:5335/udp \
-p 5335:5335/tcp \
--restart=unless-stopped \
madnuttah/unbound:latest
```

*I recommend using a MCVLAN network configuration instead of a bridged or unsafe host network*

# Documentation and feedback

## Documentation

You can find the documentation of this image here: [`README.md`](https://github.com/madnuttah/unbound-docker/blob/master/README.md).

In-depth documentation for Unbound is available on the [Unbound project's website](https://unbound.net/).

## Issues

Feel free to contact me through a [`GitHub issue`](https://github.com/madnuttah/unbound-docker/issues) if you have any questions or encounter problems with this image.

## Acknowledgements

- [Alpine Linux](https://www.alpinelinux.org/)
- [Docker](https://www.docker.com/)
- [Unbound](https://unbound.net/)

## Licenses

### License

Unless otherwise specified, all code is released under the MIT license.
See the [`LICENSE`](https://github.com/madnuttah/unbound-docker/blob/main/LICENSE) for details.

### Licenses for other components

- Docker: [Apache 2.0](https://github.com/docker/docker/blob/master/LICENSE)
- OpenSSL: [Apache-style license](https://www.openssl.org/source/license.html)
- Unbound: [BSD License](https://unbound.nlnetlabs.nl/svn/trunk/LICENSE)
