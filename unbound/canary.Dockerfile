ARG IMAGE_BUILD_DATE \
  UNBOUND_VERSION \
  UNBOUND_UID="1000" \
  UNBOUND_GID="1000" \
  OPENSSL_BUILDENV_VERSION

FROM madnuttah/openssl-buildenv:"${OPENSSL_BUILDENV_VERSION}" AS buildenv

ARG UNBOUND_UID \
  UNBOUND_GID

ENV INTERNIC_PGP="F0CB1A326BDF3F3EFA3A01FA937BB869E3A238C5" \
  UNBOUND_UID="${UNBOUND_UID}" \
  UNBOUND_GID="${UNBOUND_GID}"

WORKDIR /tmp/src

RUN set -xe; \
  addgroup -S -g "${UNBOUND_GID}" _unbound && \
  adduser -S -H -h /usr/local/unbound -g _unbound -u "${UNBOUND_UID}" -D -G _unbound _unbound && \
  apk --update --no-cache add \
  ca-certificates \
  gnupg \
  curl \
  file \ 
  binutils && \
  apk --update --no-cache add --virtual .build-deps \
    build-base\
    libsodium-dev \
    linux-headers \
    nghttp2-dev \
    ngtcp2-dev \
    libevent-dev \
    expat-dev \
    protobuf-c-dev \
    hiredis-dev \
    git \
    flex \
    bison \
    apk-tools && \
  git clone "https://github.com/NLnetLabs/unbound" && \
  cd unbound && \
  ./configure \
    --prefix=/usr/local/unbound/unbound.d \
    --with-run-dir=/usr/local/unbound/unbound.d \
    --with-conf-file=/usr/local/unbound/unbound.conf \
    --with-pidfile=/usr/local/unbound/unbound.d/unbound.pid \
    --mandir=/usr/share/man \
    --with-rootkey-file=/usr/local/unbound/iana.d/root.key \
    --with-ssl=/usr/local/openssl  \
    --with-libevent \
    --with-libnghttp2 \
    --with-libhiredis \
    --with-username=_unbound \
    --disable-shared \
    --enable-dnstap \
    --enable-dnscrypt \
    --enable-cachedb \
    --with-pthreads \
    --without-pythonmodule \
    --without-pyunbound \
    --enable-event-api \
    --enable-tfo-server \
    --enable-tfo-client \
    --enable-pie \
    --enable-relro-now && \
  make && \
  make install && \
  apk del --no-cache .build-deps && \
  mkdir -p \
    "/usr/local/unbound/iana.d/" && \
  curl -sSL https://www.internic.net/domain/named.cache -o /usr/local/unbound/iana.d/root.hints && \
  curl -sSL https://www.internic.net/domain/named.cache.md5 -o /usr/local/unbound/iana.d/root.hints.md5 && \
  curl -sSL https://www.internic.net/domain/named.cache.sig -o /usr/local/unbound/iana.d/root.hints.sig && \
  ROOT_HINTS_MD5=`cat /usr/local/unbound/iana.d/root.hints.md5` && \
  echo "${ROOT_HINTS_MD5} */usr/local/unbound/iana.d/root.hints" | md5sum -c - && \
  curl -sSL https://www.internic.net/domain/root.zone -o /usr/local/unbound/iana.d/root.zone && \
  curl -sSL https://www.internic.net/domain/root.zone.md5 -o /usr/local/unbound/iana.d/root.zone.md5 && \
  curl -sSL https://www.internic.net/domain/root.zone.sig -o /usr/local/unbound/iana.d/root.zone.sig && \
  ROOT_ZONE_MD5=`cat /usr/local/unbound/iana.d/root.zone.md5` && \
  echo "${ROOT_ZONE_MD5} */usr/local/unbound/iana.d/root.zone" | md5sum -c - && \   
  GNUPGHOME="$(mktemp -d)" && \
  export GNUPGHOME && \
  gpg --no-tty --keyserver hkps://keys.openpgp.org --recv-keys "$INTERNIC_PGP" && \
  gpg --verify /usr/local/unbound/iana.d/root.hints.sig /usr/local/unbound/iana.d/root.hints && \
  gpg --verify /usr/local/unbound/iana.d/root.zone.sig /usr/local/unbound/iana.d/root.zone && \
    /usr/local/unbound/sbin/unbound-anchor -v -a /usr/local/unbound/iana.d/root.key || true
  
COPY ./unbound/root/*.sh \
  /usr/local/unbound/sbin/
   
RUN set -xe; \
    apk --update --no-cache add \
    ca-certificates \
    tzdata \
    drill \
    libsodium \
    nghttp2 \
    ngtcp2 \
    libevent \
    protobuf-c \
    hiredis \
    expat && \
  mkdir -p \   
    "/usr/local/unbound/conf.d/" \
    "/usr/local/unbound/certs.d/" \
    "/usr/local/unbound/zones.d/" \
    "/usr/local/unbound/log.d/" && \
  touch /usr/local/unbound/log.d/unbound.log && \  
  chown -R _unbound:_unbound \
    /usr/local/unbound/ && \
  ln -s /dev/random /dev/urandom /dev/null \
    /usr/local/unbound/unbound.d/ && \
  chown -Rh _unbound:_unbound \
    /usr/local/unbound/unbound.d/random \
    /usr/local/unbound/unbound.d/null \
    /usr/local/unbound/unbound.d/urandom && \
  chmod -R 770 \
    /usr/local/unbound/sbin/*.sh && \
  rm -rf \  
    /usr/local/unbound/unbound.conf \
    /usr/local/unbound/unbound.d/share \
    /usr/local/unbound/etc \
    /usr/local/unbound/iana.d/root.hints.* \
    /usr/local/unbound/iana.d/root.zone.* \
    /usr/local/unbound/unbound.d/include \
    /usr/local/unbound/unbound.d/lib && \
    find /usr/local/openssl/lib/libssl.so.* -type f | xargs strip --strip-all && \
    find /usr/local/openssl/lib/libcrypto.so.* -type f | xargs strip --strip-all && \  
    strip --strip-all /usr/local/unbound/unbound.d/sbin/unbound && \
    strip --strip-all /usr/local/unbound/unbound.d/sbin/unbound-anchor && \
    strip --strip-all /usr/local/unbound/unbound.d/sbin/unbound-checkconf  && \
    strip --strip-all /usr/local/unbound/unbound.d/sbin/unbound-control && \
    strip --strip-all /usr/local/unbound/unbound.d/sbin/unbound-host
    
COPY ./unbound/root/usr/local/unbound/unbound.conf \
  /usr/local/unbound/unbound.conf 

FROM scratch as stage   

COPY --from=buildenv /usr/local/unbound/ \
  /app/usr/local/unbound/
 
COPY --from=buildenv /lib/*-musl-* \
  /app/lib/

COPY --from=buildenv /bin/sh /bin/sed /bin/grep /bin/netstat \
  /app/bin/
  
COPY --from=buildenv /usr/bin/awk /usr/bin/drill \
  /app/usr/bin/

COPY --from=buildenv /usr/local/openssl/lib/libssl.so.* /usr/local/openssl/lib/libcrypto.so.* \
  /app/lib/

COPY --from=buildenv /usr/lib/libgcc_s* \
  /usr/lib/libsodium* \
  /usr/lib/libexpat* \
  /usr/lib/libprotobuf-c* \
  /usr/lib/libnghttp2* \
  /usr/lib/libldns* \
  /usr/lib/libhiredis* \
  /usr/lib/libevent* \
  /usr/lib/libngtcp2* \
  /app/usr/lib/
 
COPY --from=buildenv /etc/ssl/ \
  /app/etc/ssl/
  
COPY --from=buildenv /etc/passwd /etc/group \
  /app/etc/
  
COPY --from=buildenv /usr/share/zoneinfo/ \
  /app/usr/share/zoneinfo/

WORKDIR /

FROM scratch as unbound

ARG IMAGE_BUILD_DATE \
  UNBOUND_VERSION \
  OPENSSL_BUILDENV_VERSION \
  UNBOUND_UID 

ENV IMAGE_BUILD_DATE="${IMAGE_BUILD_DATE}" \
  UNBOUND_VERSION="${UNBOUND_VERSION}" \  
  OPENSSL_BUILDENV_VERSION="${OPENSSL_BUILDENV_VERSION}" \
  UNBOUND_UID="${UNBOUND_UID}" \
  PATH=/usr/local/unbound/unbound.d/sbin:"$PATH" 
  
LABEL org.opencontainers.image.title="madnuttah/unbound" \
  org.opencontainers.image.created="${IMAGE_BUILD_DATE}" \
  org.opencontainers.image.version="${UNBOUND_VERSION} (canary)" \
  org.opencontainers.image.description="Unbound is a validating, recursive, and caching DNS resolver." \
  org.opencontainers.image.summary="This distroless Unbound Docker image is based on Alpine Linux with focus on security, privacy, performance and a small image size. And with Pi-hole in mind." \
  org.opencontainers.image.base.name="madnuttah/unbound" \
  org.opencontainers.image.url="https://hub.docker.com/r/madnuttah/unbound" \
  org.opencontainers.image.source="https://github.com/madnuttah/unbound-docker" \
  org.opencontainers.image.authors="madnuttah" \
  org.opencontainers.image.licenses="MIT"

COPY --from=stage /app/ /

USER "${UNBOUND_UID}"

CMD [ "/usr/local/unbound/sbin/unbound.sh" ]
