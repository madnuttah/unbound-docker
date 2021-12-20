# Alpine Based Unbound Hyperlocal And DNSSEC Validating DNS Server Docker Image

## Supported tags and respective `Dockerfile` links

- [`1.14.0`, `latest` (*1.14.0/Dockerfile*)]("https://github.com/madnuttah/unbound-docker")

[Changelog](CHANGELOG.md)

## Maintainer

- [madnuttah](https://github.com/madnuttah/)

## Table of Contents

- [What is Unbound](#What is Unbound?)
- [About this image](#About this image)
- [Installation](#Installation)
- [How to use this image](#How to use this image)
  - [Environment Variables](#Environment Variables)
   
## What is Unbound?

Unbound is a validating, recursive, caching DNS resolver. 

It is designed to be fast and lean and incorporates modern features based on open standards. 
Late 2019, Unbound has been rigorously audited, which means that the code base is more resilient than ever.

> [unbound.net](https://unbound.net/)

## About this image

This container image is based on a customized Alpine Linux base with focus on security, performance and a small image size.
The unbound process runs in the context of a non-root user and utilizes unprivileged ports (5335 tcp/udp).

Unbound is configured as an authoritative DNSSEC aware DNS resolver, which directly queries DNS root servers utilizing 
zone tranfers to build a "hyperlocal" setup as an upstream DNS server in combination with e.g. PiHole for adblocking, 
but works also as a standalone server.

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

My recommended way to get started is using [docker-compose](https://docs.docker.com/compose/). I have provided a working [docker-compose.yml](examples/docker-compose.yml) sample that can be modified to your needs for development or production use.

Run this container with the following command:

```console
docker run --name my-unbound -d \
-p 5335:5335/udp \
-p 5335:5335/tcp \
--restart=unless-stopped \
madnuttah/unbound:latest
```

*I recommend using a MCVLAN network configuration instead of a bridged or unsafe host network*

### Serve Custom DNS Records for your local Network

While Unbound is not a full authoritative name server, it supports resolving
custom entries on a private LAN. In other words, you can use Unbound as your own 
DNS server to resolve names such as somedevice.domain.local within your network.

To support such custom entries using this image, you need to provide an
`a-records.conf` or `srv-records.conf` file in the folder /etc/unbound/conf.d/.
This conf file is where you should define your custom entries for forward and reverse resolution.

#### A records

The `a-records.conf` file should use the following format:

```
# A Record
  #local-data: "somedevice.domain.lan. A 192.168.1.1"
  local-data: "someotherdevice.domain.lan. A 192.168.1.2"

# PTR Record
  #local-data-ptr: "192.168.1.1 somedevice.lan."
  local-data-ptr: "192.168.1.2 someotherdevice.lan."
```

Once the file has your entries in it, mount your version of the file as a volume
when starting the container:

```console
docker run --name my-unbound -d \
-p 5335:5335/udp \
-p 5335:5335/tcp \
-v $(pwd)/a-records.conf:/etc/unbound/conf.d/a-records.conf:ro \
--restart=unless-stopped \
madnuttah/unbound:latest
```

#### SRV records

The `srv-records.conf` file should use the following format:

```
# SRV records
# _service._proto.name. | TTL | class | SRV | priority | weight | port | target.
_etcd-server-ssl._tcp.domain.lan.  86400 IN    SRV 0        10     2380 etcd-0.domain.lan.
_etcd-server-ssl._tcp.domain.lan.  86400 IN    SRV 0        10     2380 etcd-1.domain.lan.
_etcd-server-ssl._tcp.domain.lan.  86400 IN    SRV 0        10     2380 etcd-2.domain.lan.
```

Run a container that use this SRV config file:
```console
docker run --name my-unbound -d \
-p 5335:5335/udp \
-p 5335:5335/tcp \
-v $(pwd)/srv-records.conf:/etc/unbound/conf.d/srv-records.conf:ro \
--restart=unless-stopped \
madnuttah/unbound:latest
```

### Override default forward

By default, no forwarders are configured to provide direct access to the iana root servers. 
Anyway, you can set the configuration in the [1.14.0/forward-records.conf](1.14.0/forward-records.conf) file 
and comment out (#) or delete the entries in the /etc/unbound/zones.d/auth-zone.conf file.

You can create your own configuration file in `/etc/unbound/conf.d/forward-records.conf` in the container.

Example `forward-records.conf`:
```
forward-zone:
  # Forward all queries (except those in cache and local zone) to
  # upstream recursive servers
  name: "."

  # my DNS forwarder
  forward-addr: 192.168.0.1@5335#domain.lan
```

Once the file has your entries in it, mount your version of the file as a volume
when starting the container:

```console
docker run --name my-unbound -d \
-p 5335:5335/udp \
-p 5335:5335/tcp -v \
$(pwd)/forward-records.conf:/etc/unbound/conf.d/forward-records.conf:ro \
--restart=unless-stopped \
madnuttah/unbound:latest
```

### Use a customized Unbound configuration

Instead of using this image's default configuration for Unbound, you may supply your own configuration. If your customized configuration is located at `/my-directory/unbound/unbound.conf`, pass `/my-directory/unbound` as a volume when creating your container:

```console
docker run --name=my-unbound \
-v=/my-directory/unbound:/etc/unbound/ \
-p=5335:5335/tcp \
-p=5335:5335/udp \
--restart=unless-stopped \
--detach=true \
madnuttah/unbound:latest
```

This will expose all files in `/my-directory/unbound/` to the container.

```
include: /etc/unbound/zones.d/local-zone-unbound.conf
```

Your volume's contents might eventually look something like this:

```
/my-directory/unbound/
-- unbound.conf
-- conf.d
  -- security.conf
  -- performance.conf
  -- ...
-- zones.d
  -- auth-zone.conf
  -- ...
-- iana.d
  -- root.key
  -- root.zone
-- log.d
  -- unbound.log
```

This approach is very similar to the `a-records.conf` described above.

# Documentation and feedback

## Documentation

You can find the documentation of this image here: [`README.md`](https://github.com/madnuttah/unbound-docker/blob/master/README.md).

In-depth documentation for Unbound is available on the [project's website](https://unbound.net/).

## Issues

If you have any problems with or questions about this image, please contact me
through a [GitHub issue](https://github.com/madnuttah/unbound-docker/issues).

## Acknowledgments

- [Docker](https://www.docker.com/)
- [Unbound](https://unbound.net/)

## Licenses

### License

Unless otherwise specified, all code is released under the Creative Commons license v4 (CC BY 4.0).
See the [`LICENSE`](https://creativecommons.org/licenses/by/4.0/) for details.

### Licenses for other components

- Docker: [Apache 2.0](https://github.com/docker/docker/blob/master/LICENSE)
- OpenSSL: [Apache-style license](https://www.openssl.org/source/license.html)
- Unbound: [BSD License](https://unbound.nlnetlabs.nl/svn/trunk/LICENSE)
