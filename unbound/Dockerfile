ARG IMAGE_BUILD_DATE="2023-02-07" \
  ALPINE_VERSION="3.17.1" \
  OPENSSL_VERSION="3.0.8" \
  LIBEVENT_VERSION="2.1.12" \
  UNBOUND_VERSION="1.17.1" \
  IMAGE_REVISION="2"
   
FROM madnuttah/unbound:libevent-buildenv-latest AS unbound
LABEL maintainer="madnuttah"

ARG UNBOUND_VERSION

ENV UNBOUND_VERSION=${UNBOUND_VERSION} \
  UNBOUND_DOWNLOAD_URL="https://www.nlnetlabs.nl/downloads/unbound/unbound-"${UNBOUND_VERSION}".tar.gz" \
  UNBOUND_PGP="EDFAA3F2CA4E6EB05681AF8E9F6F1C2D7E045F8D" \
  UNBOUND_SHA256="ee4085cecce12584e600f3d814a28fa822dfaacec1f94c84bfd67f8a5571a5f4" \
  INTERNIC_PGP="F0CB1A326BDF3F3EFA3A01FA937BB869E3A238C5"

WORKDIR /tmp/src

RUN set -xe; \
  apk --update --no-cache add \
  ca-certificates \
  gnupg \
  curl \
  file \ 
  binutils && \
  apk --update --no-cache add --virtual .build-deps \
    build-base \
    libsodium-dev \
    linux-headers \
    nghttp2-libs \
    expat-dev \
    protobuf-c-dev \
    apk-tools && \
  curl -sSL "$UNBOUND_DOWNLOAD_URL" -o unbound.tar.gz && \
  curl -sSL "${UNBOUND_DOWNLOAD_URL}".asc -o unbound.tar.gz.asc && \
  echo "${UNBOUND_SHA256} *unbound.tar.gz" | sha256sum -c - && \
  GNUPGHOME="$(mktemp -d)" && \
  export GNUPGHOME && \
  gpg --no-tty --keyserver hkps://keys.openpgp.org --recv-keys "$UNBOUND_PGP" && \
  gpg --batch --verify unbound.tar.gz.asc unbound.tar.gz && \
  tar -xzf unbound.tar.gz && \
  rm unbound.tar.gz && \
  cd unbound-${UNBOUND_VERSION} && \
  addgroup -S _unbound -g 1000 && \
  adduser -S -D -H -h /usr/local/unbound -u 1000 -s /sbin/nologin -G _unbound _unbound && \
  ./configure \
    --prefix=/usr/local/unbound/unbound.d \
    --with-conf-file=/usr/local/unbound/unbound.conf \
    --sysconfdir=/usr/local/unbound/unbound.d \
    --libdir=/usr/local/unbound/unbound.d/lib \
    --mandir=/usr/share/man \
    --libexecdir=/usr/local/unbound/unbound.d/lib \
    --localstatedir=/usr/local/unbound/unbound.d \ 
    --with-chroot-dir=/usr/local/unbound \
    --with-pidfile=/usr/local/unbound/unbound.d/unbound.pid \ 
    --with-run-dir=/usr/local/unbound/unbound.d \ 
    --with-rootkey-file=/usr/local/unbound/iana.d/root.key \
    --with-libevent=/usr/local/libevent \
    --with-ssl=/usr/local/openssl \
    --with-username=_unbound \
    --enable-dnstap \
    --with-pthreads \
    --without-pythonmodule \
    --without-pyunbound \
    --enable-event-api \
    --enable-dnscrypt \
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
  /usr/local/unbound/sbin/unbound-anchor -v -a /usr/local/unbound/iana.d/root.key || true && \
  pkill -9 gpg-agent && \
  pkill -9 dirmngr && \
  rm -rf \
    /usr/share/man \
    /usr/share/docs \
    /tmp/* \
    /var/tmp/* \
    /var/log/* \
    /usr/local/libevent/lib/*.la \
    /usr/local/libevent/bin \
    /usr/local/libevent/include \
    /usr/local/libevent/lib/pkgconfig \
    /usr/local/openssl/misc \
    /usr/local/openssl/private \
    /usr/local/openssl/include \
    /usr/local/openssl/lib/pkgconfig \
    /usr/local/openssl/lib/*.a \
    /usr/local/unbound/unbound.d/share \
    /usr/local/unbound/etc \
    /usr/local/unbound/unbound.conf \
    /usr/local/unbound/iana.d/root.hints.* \
    /usr/local/unbound/iana.d/root.zone.* \
    /usr/local/unbound/unbound.d/lib/pkgconfig \
    /usr/local/unbound/unbound.d/include \
    /usr/local/unbound/unbound.d/lib/*.a \
    /usr/local/unbound/unbound.d/lib/*.la && \
    find /usr/local/libevent/lib/lib* -type f | xargs strip --strip-all && \
    strip --strip-all /usr/local/openssl/lib/ossl-modules/legacy.so && \
    strip --strip-all /usr/local/openssl/bin/openssl && \
    find /usr/local/openssl/lib/lib* -type f | xargs strip --strip-all && \
    find /usr/local/openssl/lib/engines-3/*.so -type f | xargs strip --strip-all && \
    find /usr/local/unbound/unbound.d/lib/lib* -type f | xargs strip --strip-all && \
    strip --strip-all /usr/local/unbound/unbound.d/sbin/unbound && \
    strip --strip-all /usr/local/unbound/unbound.d/sbin/unbound-anchor && \
    strip --strip-all /usr/local/unbound/unbound.d/sbin/unbound-checkconf  && \
    strip --strip-all /usr/local/unbound/unbound.d/sbin/unbound-control && \
    strip --strip-all /usr/local/unbound/unbound.d/sbin/unbound-host
	
FROM alpine:latest
LABEL maintainer="madnuttah"

ARG UNBOUND_VERSION \
  ALPINE_VERSION \
  OPENSSL_VERSION \
  LIBEVENT_VERSION \
  IMAGE_BUILD_DATE \
  IMAGE_REVISION

ENV BUILD_DATE=${IMAGE_BUILD_DATE} \
  IMAGE_REVISION=${IMAGE_REVISION} \
  UNBOUND_VERSION=${UNBOUND_VERSION} \
  ALPINE_VERSION=${ALPINE_VERSION} \
  OPENSSL_VERSION=${OPENSSL_VERSION} \
  LIBEVENT_VERSION=${LIBEVENT_VERSION}
  
LABEL org.opencontainers.image.title="madnuttah/unbound" \
  org.opencontainers.image.created=$BUILD_DATE \
  org.opencontainers.image.version=$UNBOUND_VERSION \
  org.opencontainers.image.revision=$IMAGE_REVISION \
  org.opencontainers.image.description="Unbound is a validating, recursive, and caching DNS resolver." \
  org.opencontainers.image.summary="This multiarch Unbound Docker image is based on Alpine Linux with focus on security, privacy, performance and a small image size. And with Pi-hole in mind." \
  org.opencontainers.image.base.name="https://hub.docker.com/r/madnuttah/unbound-docker:latest" \
  org.opencontainers.image.url="https://github.com/madnuttah/unbound-docker" \
  org.opencontainers.image.source="https://github.com/madnuttah/unbound-docker" \
  org.opencontainers.image.authors="madnuttah" \
  org.opencontainers.image.vendor="madnuttah" \
  org.opencontainers.image.licenses="MIT"
	
RUN set -xe; \
  addgroup -S _unbound -g 1000 && \
  adduser -S -D -H -h /etc/unbound -u 1000 -s /sbin/nologin -G _unbound _unbound && \
  apk --update --no-cache add \
    ca-certificates \
    tzdata \
    libsodium \
    nghttp2 \
    protobuf-c \
    expat
	
COPY ./unbound/root/usr/local/unbound/ \
  /usr/local/unbound/

COPY ./unbound/root/*.sh \
    /usr/local/sbin/

COPY --from=unbound /usr/local/openssl/ \
  /usr/local/openssl/
  
COPY --from=unbound /usr/local/libevent/ \
  /usr/local/libevent/
  
COPY --from=unbound /usr/local/unbound/ \
  /usr/local/unbound/

RUN mkdir -p \
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
    /usr/local/sbin/*.sh && \
  rm -rf \
    /usr/share/man \
    /usr/share/docs \
    /tmp/* \
    /var/tmp/* \
    /var/log/* 
	
ENV PATH=/usr/local/unbound/unbound.d/sbin:"$PATH"

HEALTHCHECK --interval=1m CMD /usr/local/sbin/healthcheck.sh

CMD [ "/usr/local/sbin/unbound.sh" ]
