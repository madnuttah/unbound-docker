## Statistics

<details>

<summary>Stats</summary><br>

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
</p>

[![Maintenance](https://img.shields.io/maintenance/yes/2024?style=flat-square)](https://github.com/madnuttah/unbound-docker/)
[![Commit Activity](https://img.shields.io/github/commit-activity/y/madnuttah/unbound-docker/main?style=flat-square)](https://github.com/madnuttah/unbound-docker/commits/main)
[![Forks](https://img.shields.io/github/forks/madnuttah/unbound-docker?style=flat-square "Forks")](https://github.com/madnuttah/unbound-docker/network/members)
[![Stars](https://img.shields.io/github/stars/madnuttah/unbound-docker?style=flat-square "Stars")](https://github.com/madnuttah/unbound-docker/stargazers)
[![Issues](https://img.shields.io/github/issues/madnuttah/unbound-docker?style=flat-square "Issues")](https://github.com/madnuttah/unbound-docker/issues)
[![Pull Requests](https://img.shields.io/github/issues-pr/madnuttah/unbound-docker?style=flat-square)](https://github.com/madnuttah/unbound-docker/pulls)

</details>

[![Current Unbound release](https://img.shields.io/github/v/tag/nlnetlabs/unbound?label=Current%20NLnet%20Labs%20Unbound%20release&style=flat-square)](https://github.com/NLnetLabs/unbound/tags)
[![Current OpenSSL release](https://img.shields.io/github/v/tag/openssl/openssl?label=Current%20OpenSSL%20release&style=flat-square)](https://github.com/openssl/openssl/tags)

## Table of Contents

- [What is Unbound](#What-is-Unbound)
- [About this Image](#About-this-Image)
- [Installation](#Installation)
- [How to use this Image](#How-to-use-this-Image)
  - [Directory Structure](#Directory-Structure)
  - [Available Commands](#Available-Commands)
  - [Recommended Environment Variables](#Recommended-Environment-Variables)
  - [Optional Environment Variables](#Optional-Environment-Variables)
  - [Networking](#Networking)
  - [Usage](#Usage)
  - [CacheDB (Redis)](#cachedb-redis)
  - [Healthcheck](#healthcheck)
  - [Updating the image](#updating-the-image)
  - [Unbound Statistics](#unbound-statistics)
- [Known Issues](#Known-Issues)
- [Troubleshooting](#Troubleshooting)  
- [Documentation](#Documentation)
- [Contributing](#Contributing)
   
## What is Unbound

> _Unbound is a validating, recursive, caching DNS resolver._
> _It is designed to be fast and lean and incorporates modern features based on open standards. 
Late 2019, Unbound has been rigorously audited, which means that the code base is more resilient than ever._

Source: [unbound.net](https://unbound.net/)

## About this Image

This advanced Unbound Docker image is based on Alpine Linux with focus on security, privacy, performance and a small size.

The Unbound process runs in the context of an unpriviledged non-root user, makes use of unprivileged ports (5335 tcp/udp) and the image is built using a secure [distroless](https://hackernoon.com/distroless-containers-hype-or-true-value-2rfl3wat) scratch image.

Unbound is configured as a [DNSSEC](https://en.wikipedia.org/wiki/Domain_Name_System_Security_Extensions) validating DNS resolver, which directly queries DNS root servers utilizing zone transfers holding a local copy of the root zone (see [IETF RFC 8806](https://www.rfc-editor.org/rfc/rfc8806.txt)) as your own recursive upstream DNS server in combination with [Pi-hole](https://pi-hole.net/) or [AdGuard Home](https://adguard.com/en/welcome.html) for adblocking in mind, but works also as a standalone server. 

__There's a really nice explanation at the [Pi-hole documentation page](https://docs.pi-hole.net/guides/dns/unbound/) of what that means without becoming too technical:__

>_**Whom can you trust?** Recently, more and more small (and not so small) DNS upstream providers have appeared on the market, advertising free and private DNS service, but how can you know that they keep their promises? Right, you can't.
>Furthermore, from the point of an attacker, the DNS servers of larger providers are very worthwhile targets, as they only need to poison one DNS server, but millions of users might be affected. Instead of your bank's actual IP address, you could be sent to a phishing site hosted on some island. This scenario has already happened and it isn't unlikely to happen again...
>When you operate your own (tiny) recursive DNS server, then the likeliness of getting affected by such an attack is greatly reduced._

However, even though the image is intended to run a recursive setup, it does not necessarily mean that it has to be used that way. You are absolutely free to edit the [unbound.conf](https://www.nlnetlabs.nl/documentation/unbound/unbound.conf/) file according to your own needs and requirements[`*`](https://github.com/madnuttah/unbound-docker/blob/main/doc/DETAILS.md#troubleshooting), especially if you'd rather like to use an upstream DNS server which provides [DoT](https://en.wikipedia.org/wiki/DNS_over_TLS) or [DoH](https://en.wikipedia.org/wiki/DNS_over_HTTPS) features.
       
To provide always the latest stable, hardened and optimized versions per hardware architecture, the following software components are compiled online from source in the build processes of their own dedicated repositories using workflow driven CD pipelines using trusted GitHub Actions:
    
- [`Unbound`](https://github.com/madnuttah/unbound-docker/tree/main/.github/workflows)
- [`OpenSSL`](https://github.com/madnuttah/openssl-buildenv/tree/main/.github/workflows)
    
All components as well as the Internic files (root.hints and root.zone) are verified with their corresponding PGP keys and signature files if available to guarantee maximum security and trust.

When NLnet Labs publishes a new stable Unbound release, the image will be built, pushed to Docker Hub, tagged and released -including the required signing by the bot [`@madnuttah-bot`](https://github.com/madnuttah-bot) according to the repo's strict security policies- to GitHub on a week-daily schedule without sacrificing security measures like SHA256 verification of the downloaded source tarball. As we take your network security serious, we are still able to manually update the image as soon as security fixes of the images' components were released. The same applies to the OpenSSL build environment when an OpenSSL update got released. 

> [!NOTE]
> We're not manually building release candidates of Unbound anymore, instead there are automated canary builds which will be created from the most recent NLnet Labs Unbound GitHub commit at 20:00 UTC from Monday to Friday if you want to ride on the bleeding edge of the development of Unbound.

The `latest` image is scanned for vulnerabilities using the [Aqua Security Trivy](https://trivy.dev/) and [Docker Scout](https://docs.docker.com/scout/) vulnerability scan on a daily schedule. If vulnerabilities have been detected, they'll show up in [Security](https://github.com/madnuttah/unbound-docker/security). The `canary` build only shows the results in the workflow's run details and are being scanned at buildtime. You need to be logged into GitHub to view the logs.

## Installation

Distroless production and canary multiarch-builds for Linux-based 386, arm/v6, arm/v7, arm64 or amd64 platforms are available on [Docker Hub](https://hub.docker.com/r/madnuttah/unbound).

## How to use this Image

Please adapt the [`/usr/local/unbound/unbound.conf`](https://github.com/madnuttah/unbound-docker/blob/main/doc/examples/usr/local/unbound/unbound.conf) file and our example [`docker-compose.yaml`](https://github.com/madnuttah/unbound-docker/tree/main/doc/examples) files to your needs. The docker-compose files also deploy [Pi-hole](https://pi-hole.net/) for blocking ads and to prevent tracking but isn't limited to Pi-hole. The image can also be used as an upstream for AdGuard Home or any similar ad blocking solution.

**We don't like large, monolithic config files much.** 

Luckily Unbound can load configs through a `include:` clause. To provide a better structuring of the `unbound.conf` file, directories for **optionally** storing zone and other configuration files as well as for your certificates and the `unbound.log` file have been created and can be mounted as volumes: 
    
- [`/usr/local/unbound/certs.d/`](https://github.com/madnuttah/unbound-docker/tree/main/doc/examples/usr/local/unbound/certs.d/) for storing your certificate files.

- [`/usr/local/unbound/conf.d/`](https://github.com/madnuttah/unbound-docker/tree/main/doc/examples/usr/local/unbound/conf.d/) for your configuration files like interfaces.conf, performance.conf, security.conf, etc.
    
- [`/usr/local/unbound/log.d/unbound.log`](https://github.com/madnuttah/unbound-docker/tree/main/doc/examples/usr/local/unbound/log.d/unbound.log) in case you need to access it for troubleshooting and debugging purposes.

- [`/usr/local/unbound/zones.d/`](https://github.com/madnuttah/unbound-docker/tree/main/doc/examples/usr/local/unbound/zones.d/) for your zone configuration files like auth-zone.conf, stub-zone.conf, forward-zone.conf, etc.

> [!WARNING]    
> The config files in the `conf.d` and `zones.d` folders must be named with the suffix .conf to prevent issues with specific host configurations. 
>
> ***Don't forget to secure your setup when everything runs.***
    
The splitted configuration files located in [`doc/examples/usr/local/unbound`](https://github.com/madnuttah/unbound-docker/tree/main/doc/examples/usr/local/unbound) are only meant to give you an impression on how to separating and structuring the configs. Please mind that those files are **examples** which also needs to be edited to make them work for your environment if you intend to use them.

> [!NOTE]
> Splitting ain't really necessary as the included default [`unbound.conf`](https://raw.githubusercontent.com/madnuttah/unbound-docker/main/unbound/root/usr/local/unbound/unbound.conf) will perfectly do the job after you adapted the settings to suit your environment. You don't need to bind mount the config folders, just ignore them.
    
### Directory Structure

<details> 
    
  <summary>Filesystem</summary><br>
    
```
/
├── entrypoint
├── usr
│   ├── local
│   │   └── unbound
│   │       ├── certs.d
│   │       │   └── ...
│   │       ├── conf.d
│   │       │   └── *.conf
│   │       ├── iana.d
│   │       │   ├── root.hints
│   │       │   ├── root.key
│   │       │   └── root.zone
│   │       ├── log.d
│   │       │   └── unbound.log
│   │       ├── sbin
│   │       │   ├── healthcheck.sh
│   │       │   └── unbound.sh
│   │       ├── unbound.conf
│   │       ├── unbound.d
│   │       │   ├── null -> /dev/null
│   │       │   ├── random -> /dev/random
│   │       │   ├── sbin
│   │       │   │   ├── unbound
│   │       │   │   ├── unbound-anchor
│   │       │   │   ├── unbound-checkconf
│   │       │   │   ├── unbound-control
│   │       │   │   ├── unbound-control-setup
│   │       │   │   └── unbound-host
│   │       │   ├── unbound.pid
│   │       │   └── urandom -> /dev/urandom
│   │       └── zones.d
│   │           └── *.conf
│   ├── ...  
│   │
│   ... 
...
```
    
</details>

### Available Commands

<details> 
    
  <summary>Commands list</summary><br>

```
.                      fg                     shift
:                      getopts                source
[                      grep                   su-exec
[[                     groupmod               sys/
alias                  hash                   test
awk                    help                   times
bg                     history                trap
bin/                   id                     true
break                  jobs                   type
cd                     kill                   ulimit
chdir                  let                    umask
chgrp                  lib/                   unalias
chown                  local                  unbound
command                netstat                unbound-anchor
continue               printf                 unbound-checkconf
dev/                   proc/                  unbound-control
drill                  pwd                    unbound-control-setup
echo                   read                   unbound-host
etc/                   readonly               unset
eval                   return                 usermod
exec                   sbin/                  usr/
exit                   sed                    wait
export                 set
false                  sh
```

</details>

### Recommended Environment Variables

| Variable | Default | Value | Description |
| -------- | ------- | ----- | ---------- |
| `TZ` | `UTC` | `<Timezone>` | Set your local [timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) as DNSSEC, logging and the optional redis and statistics rely on precise time
| `UNBOUND_UID` | `1000` | `INT` | Your desired user id for user `_unbound` |
| `UNBOUND_GID` | `1000` | `INT` | Your desired group id for group `_unbound` |

### Optional Environment Variables

| Variable | Default | Value | Description |
| -------- | ------- | ----- | ---------- |
| `HEALTHCHECK_PORT` | `5335` | `INT` | The port Unbound uses (only used by the extended healthcheck) |
| `EXTENDED_HEALTHCHECK` | `false` | `BOOL` | Set this to `true` if you want to use the extended healthcheck |
| `EXTENDED_HEALTHCHECK_DOMAIN` | `nlnetlabs.nl` | `string` | The domain/host to run the extended healthcheck against |
| `DISABLE_SET_PERMS` | `false` | `BOOL` | Set this to `true` and define user `_unbound` for full rootless mode like as it was before v1.20.0-2. The `UNBOUND_UID` and `UNBOUND_GID` will both be overridden with `1000` in that case |

> [!CAUTION]   
> Setting `DISABLE_SET_PERMS` to `true` ***without*** defining `user: _unbound` or `--user _unbound` will run the container under the root account. The init screen in the log will show you the user who is running Unbound.
>
> ***If you ain't sure what this variable does, you'll most likely don't need it.***

### Networking

| Port      | Description              |
| --------- | ------------------------ |
| `5335`    | Listening Port (tcp/udp) |

### Usage

The most elegant way to get started is using [docker-compose](https://docs.docker.com/compose/). We have provided combined Pi-hole/Unbound [`docker-compose.yaml`](https://github.com/madnuttah/unbound-docker/tree/main/doc/examples/) samples which we're using in slightly modified form that makes use of a [MACVLAN](https://docs.docker.com/network/macvlan/)/shim [Bridge](https://docs.docker.com/network/bridge/) network which must be adapted to your network environment. 

> [!IMPORTANT]
> All entries in angle brackets (<...>) need your very attention!

> [!NOTE]
> You'll probably want an additional custom bridge network so your host is able communicate with the container and vice versa (for updating the Docker host, etc.). If you don't like to have an additional shim network, take a look at [this workaround](https://blog.oddbit.com/post/2018-03-12-using-docker-macvlan-networks/). We prefer using a combined MACVLAN/Bridge network configuration, but other network configurations will run as well.

If you don't want to run Unbound in recursive mode but rather having it forwarding your queries to an upstream server, make sure your `../iana.d/root.hints` file is [up-to-date](https://www.internic.net/domain/named.root) and change the following lines in your `unbound.conf`:

```
server:
...
  for-upstream: no
...
forward-zone:
  name: "."
  # Forward queries to i.e. quad9
  forward-addr: 9.9.9.9
  forward-addr: 149.112.112.112
...
```

This image can also be used as a standalone DNS resolver _without_ Pi-hole or AdGuard Home. The given ports must be changed to `53` (tcp/udp) in your `unbound.conf` and `docker-compose.yaml` then. Additionally verify that connections to localhost are allowed (see [`healthcheck`](https://github.com/madnuttah/unbound-docker/blob/main/doc/DETAILS.md#Healthcheck)). You need to enable a capability in your compose file as the `_unbound` user only has limited permissions, see [`issue 54`](https://github.com/madnuttah/unbound-docker/issues/54). You can find more information about runtime privileges and Linux capabilities [here](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities).

```yaml
cap_add: 
  - NET_BIND_SERVICE
```

If you use a Synology Diskstation with `Container Manager`, take also a look [`here`](https://github.com/madnuttah/unbound-docker/blob/main/doc/DETAILS.md#Known-Issues).

Anyway, you can also spin up the container with the following command:

```
docker run --name unbound -d \
  -p 5335:5335/udp \
  -p 5335:5335/tcp \
  --restart=unless-stopped \
  madnuttah/unbound:latest
```

### CacheDB (Redis)

> [!TIP]
> Even it takes a little more effort, we recommend accessing the CacheDB rather via [Unix Socket](https://www.howtogeek.com/devops/what-are-unix-sockets-and-how-do-they-work/) than via tcp. The speed is superior in comparison to a tcp connection.

Due to the restricted environment of the image, it's not possible to just map and access the redis server's socket but need to use a "proxy" container which provides access to both containers, `unbound` as well as `unbound-db`, so there's an additional busybox container providing the socket in an own volume.

Extend your **existing** `docker-compose.yaml` `server:` section with the content of [`this snippet`](https://raw.githubusercontent.com/madnuttah/unbound-docker/main/doc/examples/redis/docker-compose_snippet.yaml). The loading order of the modules is also important, `cachedb` has to be loaded before `iterator`and after `validator`.

```
server:
  module-config: "validator cachedb iterator"
```

Create a new mountpoint like `../unbound-db/`, make it available via `fstab` and place this [`redis.conf`](https://raw.githubusercontent.com/madnuttah/unbound-docker/main/doc/examples/redis/redis.conf) there.

Create a new entry for cachedb in your `unbound.conf` with the content of this [`cachedb.conf`](https://raw.githubusercontent.com/madnuttah/unbound-docker/main/doc/examples/redis/cachedb.conf) or put the file in your `conf.d` directory if you use the structured directories.

If using structured directories uncomment the line `include: "/usr/local/unbound/conf.d/*.conf"` of this [`unbound.conf`](https://raw.githubusercontent.com/madnuttah/unbound-docker/main/unbound/root/usr/local/unbound/unbound.conf).

You can verify the connection to redis in the `unbound.log` or by typing `docker logs unbound` in the shell (for alternative methods like monitoring using the `redis-cli` consult the corresponding documentation): 

```
...
Feb 18 22:01:02 unbound[1:0] notice: init module 1: cachedb
Feb 18 22:01:02 unbound[1:0] notice: Redis initialization 
Feb 18 22:01:02 unbound[1:0] notice: Connection to Redis established
...
```

If you like to have a healtheck for this container which we'd recommend strongly, [`you got our back`](https://raw.githubusercontent.com/madnuttah/unbound-docker/main/doc/examples/redis/healthcheck.sh). Read on, we'll explain how to set this up in the next heading.

In [Portainer](https://portainer.io) you can also view the `cachedb.d` volume with a contained `redis.sock` file by clicking `browse`.

<img width="292" alt="image" src="https://github.com/madnuttah/unbound-docker/assets/96331755/7e0e0587-b940-42f7-a807-5e55697313af">

The boot order set in your docker compose is also important. **Redis depends on the 'socket server', Unbound depends on Redis. If you use Pi-hole or AdGuard Home, it will depend on Unbound.**

For the sake of completeness, you can also flange Unbound to Redis by network. Just follow the given steps, except the part preparing and creating the unbound-db-socket container. Use proper name resolution by whether docker internal resolution, your DNS or use fixed IP addresses and change your `cachedb.conf` or your `unbound.conf` according to this:

```
cachedb:
  backend: "redis"
  redis-server-host: unbound-db # The hostname or IP of your Redis server
  redis-server-port: 6379
  redis-expire-records: yes
```

### Healthcheck

> [!IMPORTANT]
> The general use of the healthcheck is optional but highly recommended.

The healthcheck can be enabled and configured quite self-explanatory in your compose file. Check out the [`example`](https://github.com/madnuttah/unbound-docker/tree/main/doc/examples) compose files to get you started; each compose file has got the healthcheck included, the most complete example is the one [`we use ourselves`](https://raw.githubusercontent.com/madnuttah/unbound-docker/main/doc/examples/docker-compose-madnuttah.yaml). The same procedure applies for the [`CacheDB (Redis)`](#cachedb-redis) server healthcheck except it has no 'extended' feature in it's own [`healthcheck script`](https://raw.githubusercontent.com/madnuttah/unbound-docker/main/doc/examples/redis/healthcheck.sh).

The default healthcheck _only_ checks for opened Unbound ports using netstat and grep. We got asked why we don't include netcat (nc) into the image to _actually_ connect to opened ports, [this](https://www.sciencedirect.com/science/article/abs/pii/B9781597492577000054) is the reason.

To enable the _extended_ healthcheck, which uses NLnet Labs' [LDNS](https://www.nlnetlabs.nl/documentation/ldns/index.html) drill tool to query domains or hosts, please set the [optional environment variables](https://github.com/madnuttah/unbound-docker/blob/main/doc/DETAILS.md#Optional-Environment-Variables) in your compose file or run command.

> [!NOTE]
> The _extended_ healthcheck is deactivated by default in favor of your privacy and security.

To verify that the healthcheck is working and the container is doing what it is supposed to do, consult your Portainer instance or execute `docker exec -ti unbound /usr/local/unbound/sbin/healthcheck.sh` in the shell of your Docker host.

Standard healthcheck console output:

```bash
yourdockerhost:~# docker exec -ti unbound /usr/local/unbound/sbin/healthcheck.sh
✅ Port 5335 open
```

Standard healthcheck console output showing an issue:

```bash
yourdockerhost:~# docker exec -ti unbound /usr/local/unbound/sbin/healthcheck.sh
⚠️ Port 5335 not open
```

Extended healthcheck console output:

```bash
yourdockerhost:~# docker exec -ti unbound /usr/local/unbound/sbin/healthcheck.sh
✅ Port 5335 open
✅ Domain 'unbound.net' resolved to '185.49.140.10'
```

Extended healthcheck console output showing an issue:

```bash
yourdockerhost:~# docker exec -ti unbound /usr/local/unbound/sbin/healthcheck.sh
 ✅ Port 5335 open
 ⚠️ Domain 'unbound.net' not resolved
```

Not in the console but rather in Portainer (and here on this page of course) the colored unicode emoji icons will show you the condition of your container at a first glance.

### Updating the Image

> [!WARNING]
> Even we use it by ourselves to keep less important containers updated, we don't recommend using solutions like [Watchtower](https://github.com/containrrr/watchtower) to update critical services like your production DNS infrastructure automatically.
>
> A notification service like [DIUN](https://github.com/crazy-max/diun) can inform you when an update has been released so you can take appropriate action if needed.

If you want to update to the `latest` version available on Docker Hub, just pull the image using `docker-compose pull` and recreate your container by executing `docker-compose up -d`.

Pulling the latest image without a compose file can be done by `docker pull madnuttah/unbound:latest`.

### Unbound Statistics

<p>
    <img width="292" img src="https://github.com/madnuttah/unbound-docker-stats/blob/main/unbound-stats/screenshots/Screenshot.png" alt="Image">
</p>

We also created a [`companion project`](https://github.com/madnuttah/unbound-docker-stats) using [Zabbix](https://zabbix.com) for shipping the Unbound stats via a `Zabbix Active Agent` to [Grafana](https://grafana.com) _without_ using additional tools like [Zabbix Sender](https://www.zabbix.com/documentation/current/en/manpages/zabbix_sender) using a _frankensteined_ [`healthcheck script`](https://raw.githubusercontent.com/madnuttah/unbound-docker-stats/main/unbound-stats/healthcheck.sh).

# Known Issues

- There's a difference between 'vanilla' Docker and the variant Synology uses. If the container won't spin up when trying to use a privileged port like `53 tcp/udp` you might need to run the container in `root mode` by setting the `DISABLE_SET_PERMS` environment variable to `true` without a `user` definition or define `user: root` in the compose file's Unbound service section or your shell command.

# Troubleshooting

> [!TIP]
> You can run the [`available commands`](https://github.com/madnuttah/unbound-docker/blob/main/doc/DETAILS.md#Available-Commands) directly from the shell of your Docker host like `docker exec -ti unbound COMMAND`. To check your Unbound config(s) for errors for example, execute `docker exec -ti unbound unbound-checkconf`.

* You'd like to use a different `unbound.conf` than the one [`included`](https://raw.githubusercontent.com/madnuttah/unbound-docker/main/unbound/root/usr/local/unbound/unbound.conf)? No problem, just make sure to change at least the following settings and fix crucial paths, otherwise the container will fail to start:

```
server:
   username="" # Not set in config but compose or command if needed
   chroot="" # Distroless, so no chroot necessary
   directory="/usr/local/unbound" # This is the folder where Unbound lives in
```

* If you have trouble spinning up the container, start it with the [minimal config](https://raw.githubusercontent.com/madnuttah/unbound-docker/main/doc/examples/docker-compose-minimal.yaml) first. Analyze the logs using `docker logs unbound` or your `unbound.log` and fix warnings and errors there. When it runs, attach volumes one by one. Success means to adapt the default `unbound.conf` to your needs then.

* Most issues take place because there are missing files like the `unbound.log` or due to incorrect permissions on Unbound's volumes. The container won't start up in such cases. Make sure your `UNBOUND_UID/UNBOUND_GID`, default: `1000:1000`, (`_unbound:_unbound`) has read/write permissions on it's folders.

* When you see log entries like those below or similar issues in the healthcheck, verify that you permit connections to localhost. There are multiple places in the `unbound.conf` where this could be disabled, from `access control` to `Do-Not-Query-Localhost` and so on. You'll likely need to check the whole file. Isn't that alone one good reason for the concept with the separated config directories? If you can't find the culprit, don't hesitate giving us a shout. 

```
unbound[1:0] fatal error: could not open ports
unbound[1:0] error: can't bind socket: Permission denied for 127.0.0.1 port 53 
```

* If you see the warning `unbound[1:0] warning: unbound is already running as pid 1`, executing `docker compose down && docker compose up -d` will remove the PID and also the warnings in the log. As we're not shipping the image with an init system like `tini` or `dumb-init`, you might want to set `init: true` in your unbound service section or run command. See [Specify an init process](https://docs.docker.com/reference/cli/docker/container/run/#init) for further information.

* This is no issue and shows that Unbound is doing trust anchor signaling to the root name servers. See [this URL](https://tools.ietf.org/html/rfc8145) for more details.

```
unbound[0:1] info: generate keytag query _ta-4f66. NULL IN
```

**You'll find a redacted version of the Docker compose stack we`re currently using for comparison purposes [here](https://raw.githubusercontent.com/madnuttah/unbound-docker/main/doc/examples/docker-compose-madnuttah.yaml).**

# Documentation

In-depth documentation for NLnet Labs Unbound is available on the [Unbound documentation website](https://unbound.docs.nlnetlabs.nl/en/latest/) and [here](https://www.nlnetlabs.nl/documentation/unbound/unbound.conf/) goes a direct link to the documentation of the default unbound.conf file. 

# Contributing

You have found a bug, got something to make better, have an idea for a shiny new feature or just a question? That's amazing! Feel free to submit an issue or a pull request, we ❤️ contributions by the open source community.
