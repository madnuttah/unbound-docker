# CacheDB (REDIS)

I prefer accessing the CacheDB rather via socket than via TCP, you can learn about the benefits [here](https://www.techandme.se/performance-tips-for-redis-cache-server/).

Due to the `chroot` of the image, I wasn't able to just map and access the redis server's socket but had to use a "proxy" container which provides access from both containers, `unbound` as well as `redis`, so there's an additional busybox container containing the socket.

You need to enable the module in your `unbound.conf` first:

```
server:
  module-config: "cachedb validator iterator"
```

Create a fresh mountpoint like `.../unbound-db/`, make it available via `fstab` and place this [`redis.conf`](https://raw.githubusercontent.com/madnuttah/unbound-docker/main/doc/redis/examples/redis.conf) there.

Place a new entry for cachedb in your `unbound.conf` from my [`cachedb.conf`](https://raw.githubusercontent.com/madnuttah/unbound-docker/main/doc/redis/examples/cachedb.conf) or put the file in your `conf.d` directory.

Extend your ***existing*** `docker-compose.yaml` `servers:` section with the content of [`this snippet`](https://raw.githubusercontent.com/madnuttah/unbound-docker/main/doc/redis/examples/docker-compose_snippet.yaml).

