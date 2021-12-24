FROM alpine:latest AS unbound
LABEL maintainer="madnuttah"

ARG UNBOUND_VERSION=1.14.0
ARG UNBOUND_SHA256=6ef91cbf02d5299eab39328c0857393de7b4885a2fe7233ddfe3c124ff5a89c8

ENV NAME=unbound \
  UNBOUND_VERSION=${UNBOUND_VERSION} \
  UNBOUND_SHA256=${UNBOUND_SHA256} \ 
  UNBOUND_DOWNLOAD_URL=https://www.nlnetlabs.nl/downloads/unbound/unbound-${UNBOUND_VERSION}.tar.gz

WORKDIR /tmp/src

RUN set -xe; \
  apk --update --no-cache add \
  ca-certificates \
  dns-root-hints \
  dnssec-root \
  libsodium \
  libevent \
  openssl3 \
  nghttp2 \
  expat \
  curl \
  file \ 
  binutils && \
  apk --update --no-cache add --virtual .build-deps \
    build-base \
    libsodium-dev \
    libevent-dev \
    linux-headers \
    openssl3-dev \
    libssl3 \
    nghttp2-libs \
    expat-dev \
    apk-tools && \
  curl -sSL $UNBOUND_DOWNLOAD_URL -o unbound.tar.gz &&  \
  echo "${UNBOUND_SHA256} *unbound.tar.gz" | sha256sum -c - && \
  tar -xzf unbound.tar.gz && \
  rm unbound.tar.gz && \
  cd unbound-${UNBOUND_VERSION} && \
  addgroup -S _unbound -g 1000 && \
  adduser -S -D -H -h /etc/unbound -u 1000 -s /sbin/nologin -G _unbound _unbound && \
  ./configure \
    --prefix=/etc/unbound/unbound.d \
    --with-conf-file=/etc/unbound/unbound.conf \
    --sysconfdir=/etc/unbound/unbound.d \
    --libdir=/etc/unbound/unbound.d/lib \
    --mandir=/usr/share/man \
    --libexecdir=/etc/unbound/unbound.d/lib \
    --localstatedir=/etc/unbound/unbound.d \ 
    --with-chroot-dir=/etc/unbound \
    --with-pidfile=/etc/unbound/unbound.d/unbound.pid \ 
    --with-run-dir=/etc/unbound/unbound.d \ 
    --with-rootkey-file=/etc/unbound/iana.d/root.key \
    --with-username=_unbound \
    --with-pthreads \
    --without-pythonmodule \
    --without-pyunbound \
    --enable-event-api \
    --enable-dnscrypt \
    --enable-tfo-server \
    --enable-tfo-client \
    --enable-event-api \
    --with-deprecate-rsa-1024 \
    --with-libevent \
    --with-ssl \
    --enable-pie \
    --enable-fast-install \
    --enable-relro-now && \
  make && \
  make install && \
  apk del --no-cache .build-deps && \
  rm -rf \
    /etc/unbound/unbound.d/share \
    /etc/unbound/etc \
    /etc/unbound/unbound.d/lib/pkgconfig \
    /etc/unbound/unbound.d/include \
    /etc/unbound/unbound.d/lib/*.la \
    /usr/share/man \
    /usr/share/docs \
    /tmp/* \
    /var/tmp/* \
    /var/log/* && \
    find /etc/unbound/unbound.d/lib/lib* -type f | xargs strip --strip-all && \
    strip --strip-all /etc/unbound/unbound.d/sbin/unbound && \
    strip --strip-all /etc/unbound/unbound.d/sbin/unbound-anchor && \
    strip --strip-all /etc/unbound/unbound.d/sbin/unbound-checkconf  && \
    strip --strip-all /etc/unbound/unbound.d/sbin/unbound-control && \
    strip --strip-all /etc/unbound/unbound.d/sbin/unbound-host

FROM alpine:latest
LABEL maintainer="madnuttah"

ARG BUILD_DATE="2021-12-23"
ARG IMAGE_URL="https://github.com/madnuttah/unbound-docker" 
ARG IMAGE_BASE_NAME="https://hub.docker.com/r/madnuttah/unbound-docker:latest" 
ARG IMAGE_VEN="madnuttah"
ARG IMAGE_REV=1
ARG UNBOUND_VERSION=1.14.0

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
  apk add --no-cache \
    ca-certificates \
    libsodium \
    libevent \
    openssl3 \
    nghttp2 \
    expat
 	
WORKDIR /etc/unbound

COPY root/etc/unbound/ \
  /etc/unbound/
  
COPY --from=unbound /etc/unbound/unbound.d/ \
  /etc/unbound/unbound.d/

COPY root/unbound.sh \
  /usr/local/sbin/
	
RUN touch /etc/unbound/log.d/unbound.log && \
  chown -R _unbound:_unbound \
    /etc/unbound/ && \
  chmod -R 770 \
    /etc/unbound/ && \
  chmod -R +x \
    /etc/unbound/unbound.d/sbin/ && \
  chmod +x \
    /usr/local/sbin/unbound.sh && \
  rm -rf \
    /usr/share/man \
    /usr/share/docs \
    /tmp/* \
    /var/tmp/* \
    /var/log/*
	
ENV PATH=/etc/unbound/unbound.d/sbin:"$PATH"
      
EXPOSE 5335/tcp 5335/udp

CMD [ "/usr/local/sbin/unbound.sh" ]
