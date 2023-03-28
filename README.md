<p align="center">
    <img src="https://repository-images.githubusercontent.com/440215882/b79c7ae3-c3d4-4a6a-a1d7-d27fa626754b" alt="Logo">
</p>

# Alpine Linux Based Unbound Hyperlocal & DNSSEC Validating DNS Resolver Multiarch Docker Image

## Maintainer

- [`madnuttah`](https://github.com/madnuttah/)

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
[![GitHub version](https://img.shields.io/github/v/release/madnuttah/unbound-docker?include_prereleases&style=flat-square)](https://github.com/madnuttah/unbound-docker/releases)
[![Release date](https://img.shields.io/github/release-date/madnuttah/unbound-docker?style=flat-square)](https://github.com/madnuttah/unbound-docker/releases)
[![Latest commit main branch](https://img.shields.io/github/last-commit/madnuttah/unbound-docker/main?style=flat-square)](https://github.com/madnuttah/unbound-docker/commits/main)
[![License](https://img.shields.io/github/license/madnuttah/unbound-docker?style=flat-square "License")](https://github.com/madnuttah/unbound-docker/blob/main/LICENSE)

[![Commit Activity](https://img.shields.io/github/commit-activity/y/madnuttah/unbound-docker/main?style=flat-square)](https://github.com/madnuttah/unbound-docker/commits/main)
[![Forks](https://img.shields.io/github/forks/madnuttah/unbound-docker?style=flat-square "Forks")](https://github.com/madnuttah/unbound-docker/network/members)
[![Stars](https://img.shields.io/github/stars/madnuttah/unbound-docker?style=flat-square "Stars")](https://github.com/madnuttah/unbound-docker/stargazers)
[![Issues](https://img.shields.io/github/issues/madnuttah/unbound-docker?style=flat-square "Issues")](https://github.com/madnuttah/unbound-docker/issues)
[![Pull Requests](https://img.shields.io/github/issues-pr/madnuttah/unbound-docker?style=flat-square)](https://github.com/madnuttah/unbound-docker/pulls)

[![Build Multiarch Unbound Docker Image](https://img.shields.io/github/actions/workflow/status/madnuttah/unbound-docker/build-unbound.yaml?branch=main&label=Unbound%20build%20status&style=flat-square)](https://github.com/madnuttah/unbound-docker/actions/workflows/build-unbound.yaml)
[![Build Multiarch OpenSSL BuildEnv Docker Image](https://img.shields.io/github/actions/workflow/status/madnuttah/unbound-docker/build-openssl-buildenv.yaml?branch=main&label=OpenSSL%20build%20status&style=flat-square)](https://github.com/madnuttah/unbound-docker/actions/workflows/build-openssl-buildenv.yaml)
[![Build Multiarch Libevent BuildEnv Docker Image](https://img.shields.io/github/actions/workflow/status/madnuttah/unbound-docker/build-libevent-buildenv.yaml?branch=main&label=Libevent%20build%20status&style=flat-square)](https://github.com/madnuttah/unbound-docker/actions/workflows/build-libevent-buildenv.yaml)

## Image Dependencies Versions

[![Current Alpine Linux release](https://img.shields.io/docker/v/_/alpine/latest?label=Current%20Alpine%20Linux%20release&style=flat-square)](https://github.com/alpinelinux/docker-alpine)
[![Current Unbound release](https://img.shields.io/github/v/tag/nlnetlabs/unbound?label=Current%20Unbound%20release&style=flat-square)](https://github.com/NLnetLabs/unbound/tags)
[![Current OpenSSL release](https://img.shields.io/github/v/tag/openssl/openssl?label=Current%20OpenSSL%20release&style=flat-square)](https://github.com/openssl/openssl/tags)
[![Current Libevent release](https://img.shields.io/github/v/tag/libevent/libevent?label=Current%20Libevent%20release&style=flat-square)](https://github.com/libevent/libevent/tags)

## Available Docker Tags

<details> 
    
  <summary>Tags</summary><br>  
  
   - [1.17.1-3 (latest)](https://hub.docker.com/r/madnuttah/unbound/tags)  
   - [1.17.1-2](https://hub.docker.com/r/madnuttah/unbound/tags)  
   - [1.17.1-1](https://hub.docker.com/r/madnuttah/unbound/tags)  
   - [1.17.1](https://hub.docker.com/r/madnuttah/unbound/tags)
   - [1.17.1rc2 (Pre-release)](https://hub.docker.com/r/madnuttah/unbound/tags)
   - [1.17.1rc1 (Pre-release)](https://hub.docker.com/r/madnuttah/unbound/tags) 
   - [1.17.0-5](https://hub.docker.com/r/madnuttah/unbound/tags) 
   - [1.17.0-4](https://hub.docker.com/r/madnuttah/unbound/tags) 
   - [1.17.0-3](https://hub.docker.com/r/madnuttah/unbound/tags) 
   - [1.17.0-2](https://hub.docker.com/r/madnuttah/unbound/tags) 
   - [1.17.0-1](https://hub.docker.com/r/madnuttah/unbound/tags) 
   - [1.17.0](https://hub.docker.com/r/madnuttah/unbound/tags) 
   - [1.16.3-1](https://hub.docker.com/r/madnuttah/unbound/tags) 
   - [1.17.0rc1 (Pre-release)](https://hub.docker.com/r/madnuttah/unbound/tags)  
   - [1.16.3](https://hub.docker.com/r/madnuttah/unbound/tags)  
   - [1.16.2-1](https://hub.docker.com/r/madnuttah/unbound/tags)  
   - [1.16.2](https://hub.docker.com/r/madnuttah/unbound/tags)
   - [1.16.1-1](https://hub.docker.com/r/madnuttah/unbound/tags)
   - [1.16.1](https://hub.docker.com/r/madnuttah/unbound/tags)
   - [1.16.1rc1-1 (Pre-release)](https://hub.docker.com/r/madnuttah/unbound/tags)
   - [1.16.1rc1 (Pre-release)](https://hub.docker.com/r/madnuttah/unbound/tags)
   - [1.16.0-2](https://hub.docker.com/r/madnuttah/unbound/tags)
   - [1.16.0-1](https://hub.docker.com/r/madnuttah/unbound/tags)
   - [1.16.0](https://hub.docker.com/r/madnuttah/unbound/tags)
   - [1.16.0rc1 (Pre-release)](https://hub.docker.com/r/madnuttah/unbound/tags)    
   - [1.15.0-7](https://hub.docker.com/r/madnuttah/unbound/tags)
   - [1.15.0-6](https://hub.docker.com/r/madnuttah/unbound/tags)
   - [1.15.0-5](https://hub.docker.com/r/madnuttah/unbound/tags)
   - [1.15.0-4](https://hub.docker.com/r/madnuttah/unbound/tags)
   - [1.15.0-3](https://hub.docker.com/r/madnuttah/unbound/tags)
   - [1.15.0-2](https://hub.docker.com/r/madnuttah/unbound/tags)
   - [1.15.0-1](https://hub.docker.com/r/madnuttah/unbound/tags)
   - [1.15.0](https://hub.docker.com/r/madnuttah/unbound/tags)
   - [1.15.0rc1 (Pre-release)](https://hub.docker.com/r/madnuttah/unbound/tags)
   - [1.14.0](https://hub.docker.com/r/madnuttah/unbound/tags)
    
</details>
    
## Changes
    
You can view the changelogs in the [`Releases`](https://github.com/madnuttah/unbound-docker/releases) section.

# About this Image
Are you looking for a simple and secure way to run your own DNS resolver? Do you want to block ads, malware, and trackers at the network level with an actively maintained Docker image? Here's my lightweight and trustworthy Alpine Linux based Docker image that runs Unbound, a high-performance recursive DNS server brought to you by the nice folks @nlnetlabs.

## [`Detailed Readme`](https://github.com/madnuttah/unbound-docker/blob/main/doc/README_EN.md)
