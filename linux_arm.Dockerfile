FROM alpine:latest AS openssl
LABEL maintainer="madnuttah"

ARG OPENSSL_VERSION=openssl-3.0.1 \
  OPENSSL_SHA256="c311ad853353bce796edad01a862c50a8a587f62e7e2100ef465ab53ec9b06d1 " \
  OPENSSL_DOWNLOAD_URL=https://www.openssl.org/source/ \
  OPENSSL_PGP=8657ABB260F056B1E5190839D9C4D26D0E604491

WORKDIR /tmp/src

RUN set -xe; \
  apk --update --no-cache add \
  ca-certificates \
  gnupg \
  curl \
  file && \
  apk --update --no-cache add --virtual .build-deps \
    build-base \
    perl \
    libidn2-dev \
    libevent-dev \
    linux-headers \
    apk-tools && \
    curl -sSL $OPENSSL_DOWNLOAD_URL$OPENSSL_VERSION.tar.gz -o openssl.tar.gz && \
    echo "${OPENSSL_SHA256} ./openssl.tar.gz" | sha256sum -c - && \
    curl -L $OPENSSL_DOWNLOAD_URL$OPENSSL_VERSION.tar.gz.asc -o openssl.tar.gz.asc && \
    GNUPGHOME="$(mktemp -d)" && \
    export GNUPGHOME && \
    gpg --no-tty --keyserver keys.openpgp.org --recv-keys "$OPENSSL_PGP" && \
    gpg --batch --verify openssl.tar.gz.asc openssl.tar.gz && \
    tar xzf openssl.tar.gz && \
    cd $OPENSSL_VERSION && \
    ./Configure \
      no-weak-ssl-ciphers \
      no-ssl3 \
      no-err \
      shared \
      -DOPENSSL_NO_HEARTBEATS \
      -fstack-protector-strong \
      --prefix=/usr/local/openssl \
      --openssldir=/usr/local/openssl \
      --libdir=/usr/local/openssl/lib && \
  make && \
  make install_sw && \
  apk del --no-cache .build-deps && \
  pkill -9 gpg-agent && \
  pkill -9 dirmngr && \
  rm -rf \
    /usr/share/man \
    /usr/share/docs \
    /tmp/* \
    /var/tmp/* \
    /var/log/*
	
FROM alpine:latest AS libevent
LABEL maintainer="madnuttah"

ARG LIBEVENT_VERSION=2.1.12 \
  LIBEVENT_DOWNLOAD_URL=https://github.com/libevent/libevent/releases/download/release \
  LIBEVENT_PGP="9E3AC83A27974B84D1B3401DB86086848EF8686D"
  
COPY --from=openssl /usr/local/openssl/ \
  /usr/local/openssl/
	
RUN set -xe; \
  apk --update --no-cache add \
  ca-certificates \
  gnupg \
  curl \
  file && \
  apk --update --no-cache add --virtual .build-deps \
    build-base \
    python2 \
    zlib-dev \
    linux-headers \
    apk-tools && \
    curl -sSL ${LIBEVENT_DOWNLOAD_URL}-${LIBEVENT_VERSION}-stable/libevent-${LIBEVENT_VERSION}-stable.tar.gz -o libevent.tar.gz && \
    curl -sSL ${LIBEVENT_DOWNLOAD_URL}-${LIBEVENT_VERSION}-stable/libevent-${LIBEVENT_VERSION}-stable.tar.gz.asc -o libevent.tar.gz.asc && \
    GNUPGHOME="$(mktemp -d)" && \
    export GNUPGHOME && \
    gpg --no-tty --keyserver pgp.mit.edu --recv-keys "$LIBEVENT_PGP" || \
    gpg --no-tty --keyserver keyserver.ubuntu.com --recv-keys "$LIBEVENT_PGP" && \
    gpg --batch --verify libevent.tar.gz.asc libevent.tar.gz && \
    tar xzf libevent.tar.gz && \
    rm libevent.tar.gz && \
    cd libevent-${LIBEVENT_VERSION}-stable && \
    env CPPFLAGS='-I/usr/local/openssl/include' \
      LDFLAGS='-L/usr/local/openssl/lib' \
    ./configure \
      --prefix=/usr/local/libevent \
      --disable-static \
      --disable-libevent-regress \
      --disable-samples \
      --disable-debug-mode \
      --enable-gcc-hardening && \
    make && \
    make install && \
    apk del --no-cache .build-deps && \
    pkill -9 gpg-agent && \
    pkill -9 dirmngr && \
    rm -rf \
      /usr/share/man \
      /usr/share/docs \
      /tmp/* \
      /var/tmp/* \
      /var/log/*

FROM alpine:latest AS unbound
LABEL maintainer="madnuttah"

ARG UNBOUND_VERSION=1.14.0 \
  UNBOUND_DOWNLOAD_URL=https://www.nlnetlabs.nl/downloads/unbound/unbound-${UNBOUND_VERSION}.tar.gz
  UNBOUND_PGP="EDFAA3F2CA4E6EB05681AF8E9F6F1C2D7E045F8D" \
  UNBOUND_SHA256=6ef91cbf02d5299eab39328c0857393de7b4885a2fe7233ddfe3c124ff5a89c8 \
  INTERNIC_PGP="F0CB1A326BDF3F3EFA3A01FA937BB869E3A238C5" \

WORKDIR /tmp/src

COPY --from=openssl /usr/local/openssl/ \
  /usr/local/openssl/
  
COPY --from=libevent /usr/local/libevent/ \
  /usr/local/libevent/

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
    apk-tools && \
  curl -sSL $UNBOUND_DOWNLOAD_URL -o unbound.tar.gz && \
  curl -sSL ${UNBOUND_DOWNLOAD_URL}.asc -o unbound.tar.gz.asc && \
  echo "${UNBOUND_SHA256} *unbound.tar.gz" | sha256sum -c - && \
  GNUPGHOME="$(mktemp -d)" && \
  export GNUPGHOME && \
  gpg --no-tty --keyserver keys.openpgp.org --recv-keys "$UNBOUND_PGP" && \
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
    --with-pthreads \
    --without-pythonmodule \
    --without-pyunbound \
    --enable-event-api \
    --enable-dnscrypt \
    --enable-tfo-server \
    --enable-tfo-client \
    --enable-event-api \
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
  gpg --no-tty --keyserver keys.openpgp.org --recv-keys "$INTERNIC_PGP" && \
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
    /usr/local/openssl/misc \
    /usr/local/openssl/private \
    /usr/local/openssl/include \
    /usr/local/openssl/lib/pkgconfig \
    /usr/local/openssl/lib/*.a \
    /usr/local/libevent/lib/*.la \
    /usr/local/libevent/bin \
    /usr/local/libevent/include \
    /usr/local/libevent/lib/pkgconfig \
    /usr/local/unbound/unbound.d/share \
    /usr/local/unbound/etc \
    /usr/local/unbound/unbound.conf \
    /usr/local/unbound/iana.d/root.hints.* \
    /usr/local/unbound/iana.d/root.zone.* \
    /usr/local/unbound/unbound.d/lib/pkgconfig \
    /usr/local/unbound/unbound.d/include \
    /usr/local/unbound/unbound.d/lib/*.a \
    /usr/local/unbound/unbound.d/lib/*.la && \
    find /usr/local/openssl/lib/lib* -type f | xargs strip --strip-all && \
    find /usr/local/openssl/lib/engines-3/*.so -type f | xargs strip --strip-all && \
    find /usr/local/libevent/lib/lib* -type f | xargs strip --strip-all && \
    find /usr/local/unbound/unbound.d/lib/lib* -type f | xargs strip --strip-all && \
    strip --strip-all /usr/local/openssl/lib/ossl-modules/legacy.so && \
    strip --strip-all /usr/local/openssl/bin/openssl && \
    strip --strip-all /usr/local/unbound/unbound.d/sbin/unbound && \
    strip --strip-all /usr/local/unbound/unbound.d/sbin/unbound-anchor && \
    strip --strip-all /usr/local/unbound/unbound.d/sbin/unbound-checkconf  && \
    strip --strip-all /usr/local/unbound/unbound.d/sbin/unbound-control && \
    strip --strip-all /usr/local/unbound/unbound.d/sbin/unbound-host

FROM alpine:latest
LABEL maintainer="madnuttah"

ARG BUILD_DATE="2022-02-02" \
  IMAGE_URL="https://github.com/madnuttah/unbound-docker" \
  IMAGE_BASE_NAME="https://hub.docker.com/r/madnuttah/unbound-docker:latest" \
  IMAGE_VEN="madnuttah" \
  IMAGE_REV=0 \
  UNBOUND_VERSION="1.14.0"

ENV NAME=Unbound \
  VENDOR_NAME=${IMAGE_VEN} \
  VERSION=${UNBOUND_VERSION} \
  IMAGE_REVISION=${IMAGE_REV} \
  IMAGE_BUILD_DATE=${BUILD_DATE} \
  SUMMARY="Unbound is a validating, recursive, and caching DNS resolver." \
  DESCRIPTION="Unbound is a validating, recursive, and caching DNS resolver." 

LABEL org.opencontainers.image.created=$BUILD_DATE \
  org.opencontainers.image.base.name=$IMAGE_BASE_NAME \
  org.opencontainers.image.title="madnuttah/unbound" \
  org.opencontainers.image.description=$DESCRIPTION \
  org.opencontainers.image.summary=$SUMMARY \
  org.opencontainers.image.url=$IMAGE_URL \
  org.opencontainers.image.source=$IMAGE_URL \
  org.opencontainers.image.authors=$IMAGE_VEN \
  org.opencontainers.image.vendor=$IMAGE_VEN \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.version=$UNBOUND_VERSION \
  org.opencontainers.image.revision=$IMAGE_REV
	
RUN set -xe; \
  addgroup -S _unbound -g 1000 && \
  adduser -S -D -H -h /etc/unbound -u 1000 -s /sbin/nologin -G _unbound _unbound && \
  apk --update --no-cache add \
    ca-certificates \
    libsodium \
    nghttp2 \
    expat
	
WORKDIR /usr/local/unbound

COPY root/usr/local/unbound/ \
  /usr/local/unbound/
  
COPY --from=unbound /usr/local/openssl/ \
  /usr/local/openssl/
  
COPY --from=unbound /usr/local/libevent/ \
  /usr/local/libevent/
  
COPY --from=unbound /usr/local/unbound/ \
  /usr/local/unbound/

COPY root/unbound.sh \
  /usr/local/sbin/
		  
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
    /usr/local/unbound/ && \
  chmod -R 770 \
    /usr/local/sbin/ && \
  rm -rf \
    /usr/share/man \
    /usr/share/docs \
    /tmp/* \
    /var/tmp/* \
    /var/log/* 
	
ENV PATH=/usr/local/unbound/unbound.d/sbin:"$PATH"
      
VOLUME [ \
  "/usr/local/unbound/iana.d/" \
  "/usr/local/unbound/conf.d/" \
  "/usr/local/unbound/certs.d/" \
  "/usr/local/unbound/zones.d/" \
  "/usr/local/unbound/log.d/" \
  ] 
      
EXPOSE 5335/tcp 5335/udp

CMD [ "/usr/local/sbin/unbound.sh" ]
