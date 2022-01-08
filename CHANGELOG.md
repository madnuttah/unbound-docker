## 1.14.0 2021-01-08 <madnuttah>

   ### Update
      - Multiarch builds for arm/arm64/amd64 platforms compiled

## 1.14.0 2021-01-02 <madnuttah>

   ### Update
      - Added self compiled OpenSSL3 3.0.1 and libevent 2.1.12
      - Internic root.zone, root.hints and root.key files will be downloaded in the build process
      - All downloaded files get verified with PGP and their corresponding checksum files
      - Optimizations

## 1.14.0 2021-12-31 <madnuttah>

   ### Update
      - Moved folder from /etc/unbound to /usr/local/unbound. You may need to review your Volumes in your docker-compose.yaml.
      - Optimizations

## 1.14.0 2021-12-24 <madnuttah>

   ### Initial release
      - Alpine Base 3.15
      - OpenSSL3
      - Unbound 1.14.0
