# Alpine Linux Based DNSSEC Validating Recursive Unbound DNS Resolver Docker Image

<details>
  <summary>Build status (click to expand)</summary><br>

[![CD Build Docker Image](https://img.shields.io/github/actions/workflow/status/madnuttah/unbound-docker/cd-build-unbound.yaml?branch=main&label=CD%20madnuttah/unbound%20build%20status&style=flat-square)](https://github.com/madnuttah/unbound-docker/blob/main/.github/workflows/cd-build-unbound.yaml)
[![CD Build QUIC Docker Image](https://img.shields.io/github/actions/workflow/status/madnuttah/unbound-docker/cd-build-unbound-quic.yaml?branch=main&label=CD%20madnuttah/unbound%20quic%20build%20status&style=flat-square)](https://github.com/madnuttah/unbound-docker/blob/main/.github/workflows/cd-build-unbound-quic.yaml)
[![CD Build Canary Docker Image](https://img.shields.io/github/actions/workflow/status/madnuttah/unbound-docker/cd-build-canary-unbound.yaml?branch=main&label=CD%20madnuttah/unbound%20canary%20build%20status&style=flat-square)](https://github.com/madnuttah/unbound-docker/blob/main/.github/workflows/cd-build-canary-unbound.yaml)
[![CD Build Canary QUIC Docker Image](https://img.shields.io/github/actions/workflow/status/madnuttah/unbound-docker/cd-build-canary-unbound-quic.yaml?branch=main&label=CD%20madnuttah/unbound%20canary%20quic%20build%20status&style=flat-square)](https://github.com/madnuttah/unbound-docker/blob/main/.github/workflows/cd-build-canary-unbound-quic.yaml)

</details>

[![GitHub version](https://img.shields.io/github/v/release/madnuttah/unbound-docker?include_prereleases&label=madnuttah/unbound%20release&style=flat-square)](https://github.com/madnuttah/unbound-docker/releases)
[![OpenSSL buildenv](https://img.shields.io/github/v/release/madnuttah/openssl-buildenv?include_prereleases&label=madnuttah/openssl-buildenv%20release&style=flat-square)](https://github.com/madnuttah/openssl-buildenv/releases)


[![GitHub Actions Security Analysis with zizmor](https://github.com/madnuttah/unbound-docker/actions/workflows/cd-gh-action-zizmor-scan.yaml/badge.svg)](https://github.com/madnuttah/unbound-docker/actions/workflows/cd-gh-action-zizmor-scan.yaml)
[![CodeQL Advanced](https://github.com/madnuttah/unbound-docker/actions/workflows/codeql.yml/badge.svg)](https://github.com/madnuttah/unbound-docker/actions/workflows/codeql.yml)
[![Lint GitHub Actions](https://github.com/madnuttah/unbound-docker/actions/workflows/cd-github-actions-linting.yaml/badge.svg)](https://github.com/madnuttah/unbound-docker/actions/workflows/cd-github-actions-linting.yaml)
[![Lint Dockerfiles](https://github.com/madnuttah/unbound-docker/actions/workflows/cd-dockerfiles-linting.yaml/badge.svg)](https://github.com/madnuttah/unbound-docker/actions/workflows/cd-dockerfiles-linting.yaml)
[![Security Scan](https://github.com/madnuttah/unbound-docker/actions/workflows/cd-security-scan.yaml/badge.svg)](https://github.com/madnuttah/unbound-docker/actions/workflows/cd-security-scan.yaml)

[![renovate](https://img.shields.io/badge/Maintained%20with-Renovate-blue?logo=renovatebot&style=flat-square)](https://app.renovatebot.com/dashboard)
[![StepSecurity Harden Runner](https://img.shields.io/badge/Secured%20by-StepSecurity-blue?style=flat-square)](https://github.com/step-security/harden-runner)

This repository provides a lightweight Alpine Linux based Docker image running [Unbound](https://unbound.net), an open source high performance DNS resolver developed by the people at [NLnet Labs](https://nlnetlabs.nl). The image is a secure single layer distroless scratch build that follows best practice principles and is suitable for professional and personal use alike.

<details>
  <summary>Features (click to expand)</summary><br>

| Feature                                  | Supported | Explanation |
| ---------------------------------------- | --------- | ----------- |
| Unprivileged user                        | yes | Runs Unbound without root to reduce attack surface. |
| Unprivileged port (privileged possible)  | yes | Allows binding to high ports by default or low ports when needed. |
| Custom UID and GID build and environment variables | yes | Lets you match container permissions to host requirements. |
| Optional full rootless mode              | yes | Enables running the container without any root privileges. |
| CD built single layer distroless scratch image running Alpine Linux | yes | Produces a minimal and secure runtime with no package manager or shell. |
| Per hardware architecture optimized and CD built [OpenSSL&OpenSSL+QUIC](https://github.com/madnuttah/openssl-buildenv) | yes | Ensures optimal crypto performance and QUIC support per architecture. |
| Libevent                                 | yes | Provides efficient event handling for high performance DNS resolution. |
| Recursive DNS as default                 | yes | Configured to perform full recursion without relying on upstream resolvers. |
| DNSSEC                                   | yes | Validates DNS responses cryptographically for authenticity. |
| DNSCrypt                                 | yes | Supports encrypted DNS queries using the DNSCrypt protocol. |
| DNSTap                                   | yes | Allows structured logging of DNS queries for analysis and debugging. |
| DNS64                                    | yes | Synthesizes IPv6 addresses for IPv4 only destinations. |
| DNS over HTTPS                           | yes | Accepts and serves DNS queries over HTTPS. |
| DNS over TLS                             | yes | Accepts and serves DNS queries over TLS. |
| DNS over Quic (separate [-quic] builds)  | yes | Provides DNS over QUIC support in dedicated QUIC enabled images. |
| Redis via UNIX socket or network         | yes | Enables caching or persistent storage through Redis. |
| EDNS Client Subnet                       | yes | Supports forwarding client subnet information when required. |
| Optional privacy respecting and meaningful healthcheck | yes | Offers a healthcheck that avoids leaking DNS queries. |
| Optional Unbound statistics for Grafana via Zabbix without third party tools | yes | Exposes metrics directly for monitoring without extra exporters. |
| Python                                   | no | Python is intentionally excluded to keep the image minimal. |

</details>

<details>
  <summary>Supported Architectures (click to expand)</summary><br>

This image is built for a wide range of hardware architectures. All builds are produced using Docker Buildx with QEMU emulation where required and optimized OpenSSL or OpenSSL QUIC build environments.

| Architecture | Supported | Notes |
|-------------|-----------|-------|
| linux/amd64 | yes | Fully supported and optimized |
| linux/arm64 | yes | Fully supported and optimized |
| linux/386   | yes | Legacy compatibility |
| linux/arm/v6 | yes | For older ARM devices |
| linux/arm/v7 | yes | Common for SBCs like Raspberry Pi 2 and 3 |
| linux/ppc64le | yes | Little endian PowerPC |
| linux/s390x | yes | IBM Z and LinuxONE |
| linux/riscv64 | yes | Experimental but supported |

All architectures are built and published automatically through continuous delivery pipelines.

</details>


## Getting started

Docker containers are most easily used with Docker Compose.

> [!IMPORTANT]  
> Please read the [Documentation](https://github.com/madnuttah/unbound-docker/blob/main/doc/README.md) to learn how to get this image running.  
> Example Docker Compose files can be found [here](https://github.com/madnuttah/unbound-docker/tree/main/doc/examples).  
> If you prefer Podman and systemd, example Quadlets can be found [here](https://github.com/madnuttah/unbound-docker/tree/main/doc/examples/podman-systemd).

## Available Docker Tags

This image is published in four variants: standard, QUIC, canary, and canary QUIC.

All tags follow a consistent versioning scheme based on the upstream Unbound release.

---

### Standard Images (DNS over TLS/DoT, UDP, TCP)

The standard Unbound images can be pulled using the latest tag or a specific version:

```
docker pull madnuttah/unbound:latest
docker pull madnuttah/unbound:1.1.0-0
```

Versioning scheme:

```
<UNBOUND_VERSION>-<REVISION>
e.g. 1.1.0-0
```

---

### QUIC Images (DNS over QUIC/DoQ)

QUIC enabled images follow the same versioning scheme as the standard images but append -quic:

```
docker pull madnuttah/unbound:latest-quic
docker pull madnuttah/unbound:1.1.0-0-quic
```

Versioning scheme:

```
<UNBOUND_VERSION>-<REVISION>-quic
e.g. 1.1.0-0-quic
```

---

### Canary Images (Nightly Builds)

Nightly builds of the standard image are published under the canary tag:

```
docker pull madnuttah/unbound:canary
```

These builds track the latest upstream Unbound master branch.

---

### Canary QUIC Images (Nightly QUIC Builds)

Nightly QUIC enabled builds are available under the canary-quic tag:

```
docker pull madnuttah/unbound:canary-quic
```

These builds combine the latest Unbound master branch with the QUIC enabled OpenSSL and NGTCP2 stack.

---

> [!NOTE]  
> Canary builds may contain bugs and are not recommended for production use. They are untested and unsupported.

## Changes

You can view the changes in the [Releases](https://github.com/madnuttah/unbound-docker/releases) section.

## Feedback

If you have questions or encounter issues, please open a [GitHub Issue](https://github.com/madnuttah/unbound-docker/issues).

Feature requests and general discussion are welcome in the repository [Discussions](https://github.com/madnuttah/unbound-docker/discussions) tab.

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
- [zizmor](https://github.com/zizmorcore/zizmor)  
- The many Docker images that inspired this project

## Licenses

### License

Unless otherwise specified, all code is released under the MIT license.  
See the [LICENSE](https://github.com/madnuttah/unbound-docker/blob/main/LICENSE) for details.

### Licenses for other components

- Docker: [Apache 2.0](https://github.com/docker/docker/blob/master/LICENSE)  
- Unbound: [BSD License](https://unbound.nlnetlabs.nl/svn/trunk/LICENSE)  
- OpenSSL: [Apache style license](https://www.openssl.org/source/license.html)

## Legal

Please note that this is a work of private contributors and we're neither affiliated with NLnet Labs, Pi-hole or AdGuard nor is NLnet Labs, Pi-hole or AdGuard involved in the development of the image. The marks and properties 'Unbound', 'Pi-hole' and 'AdGuard Home' are properties of NLnet Labs, Pi-hole and AdGuard respectively. All rights in the source codes, including logos relating to said marks and properties belong to their respective owners.

## Supporting our mission

In case you would like to donate money, please rather spend it on the upstream projects this image depends on.

If you like what we do and if you find this image protecting your privacy and giving back your DNS liberty useful - spread the word, fork our repo, open an issue, make a pull request and don't forget to leave a star on Docker Hub and GitHub. Many thanks for your support!
