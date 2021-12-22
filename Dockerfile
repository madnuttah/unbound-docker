FROM alpine:latest AS unbound
LABEL maintainer="Madnuttah"

ARG UNBOUND_VERSION=1.14.0
ARG UNBOUND_SHA256=6ef91cbf02d5299eab39328c0857393de7b4885a2fe7233ddfe3c124ff5a89c8

ENV NAME=unbound \
    UNBOUND_VERSION=${UNBOUND_VERSION} \
    UNBOUND_SHA256=${UNBOUND_SHA256} \ 
    UNBOUND_DOWNLOAD_URL=https://www.nlnetlabs.nl/downloads/unbound/unbound-${UNBOUND_VERSION}.tar.gz

WORKDIR /tmp/src

RUN set -xe; \
  apk add --no-cache --virtual .build-deps \
  ca-certificates \
  libsodium-dev \
  libevent-dev \
  linux-headers \
  openssl3-dev \
  nghttp2-libs \
  expat-dev \
  build-base \
  curl \
  file \ 
  && curl -sSL $UNBOUND_DOWNLOAD_URL -o unbound.tar.gz \
  && echo "${UNBOUND_SHA256} *unbound.tar.gz" | sha256sum -c - \
  && tar -xzf unbound.tar.gz --strip-components=1 \
  && rm unbound.tar.gz \
  && cd unbound-${UNBOUND_VERSION} \
  && addgroup -S _unbound -g 1000 2>/dev/null \
  && adduser -S -D -H -h /etc/unbound -u 1000 -s 2>/dev/null -G _unbound _unbound \
  && ./configure \
    --prefix=/etc/unbound/unbound.d \
    --with-conf-file=/etc/unbound/unbound.conf \
    --sysconfdir=/etc/unbound \
    --localstatedir=/etc/unbound/var.d \
    --with-chroot-dir=/etc/unbound \
    --with-pidfile=/etc/unbound/run.d/unbound.pid \
    --with-run-dir=/etc/unbound/run.d \
    --with-rootkey-file=/etc/unbound/iana.d/root.key
    --with-username=_unbound \
    --with-pthreads \
    --disable-rpath \
    #--disable-static \
    --enable-static=no \
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
  && make \
  && make install \
  && apk del --no-cache .build-deps \
  && rm -rf \
    /etc/unbound/share \
    /etc/unbound/etc \
    /etc/unbound/lib/pkgconfig \
    /etc/unbound/include \
    /etc/unbound/lib/*.la \
    /usr/share/man \
    /usr/share/docs \
    /tmp/* \
    /var/tmp/* \
    /var/log/* \
    && find /etc/unbound/unbound.d/lib/lib* -type f | xargs strip --strip-all \
    && strip --strip-all /etc/unbound/unbound.d/sbin/unbound \
    && strip --strip-all /etc/unbound/unbound.d/sbin/unbound-anchor \
    && strip --strip-all /etc/unbound/unbound.d/sbin/unbound-checkconf  \
    && strip --strip-all /etc/unbound/unbound.d/sbin/unbound-control \
    && strip --strip-all /etc/unbound/unbound.d/sbin/unbound-host

FROM alpine:latest
LABEL maintainer="Madnuttah"

ARG BUILD_DATE="2021-012-21T00:00:00Z"
ARG IMAGE_URL="https://github.com/madnuttah/unbound-docker" 
ARG IMAGE_BASE_NAME="https://hub.docker.com/r/madnuttah/unbound-docker:latest" 
ARG IMAGE_VEN="Madnuttah"
ARG UNBOUND_VERSION=1.14.0
ARG IMAGE_REV=1
ENV UNBOUND_VERSION=${UNBOUND_VERSION}
ENV IMAGE_BASE_NAME=${IMAGE_BASE_NAME}
ENV IMAGE_REV=${IMAGE_REV}
ENV UNBOUND_HOME=/etc/unbound

LABEL org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.base.name=$IMAGE_BASE_NAME \
    org.opencontainers.image.title="madnuttah/unbound" \
    org.opencontainers.image.description="Unbound is a validating, recursive, and caching DNS resolver." \
    org.opencontainers.image.summary="Unbound is a validating, recursive, and caching DNS resolver." \
    org.opencontainers.image.url=$IMAGE_URL \
    org.opencontainers.image.source=$IMAGE_URL \
    org.opencontainers.image.authors=$IMAGE_VEN \
    org.opencontainers.image.vendor=$IMAGE_VEN \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.version=$UNBOUND_VERSION \
    org.opencontainers.image.revision=$IMAGE_REV
	
RUN set -xe; \
  addgroup -S _unbound -g 1000 2>/dev/null \
  && adduser -S -D -H -h "${UNBOUND_HOME}" -u 1000 -s /sbin/nologin -G _unbound _unbound 2>/dev/null \
  && apk add --no-cache \
    #ca-certificates \
    #libsodium \
    #libevent \
    openssl3 \
    nghttp2 \
    expat \
    && mkdir -p \
        "${UNBOUND_HOME}/certs.d" \
        "${UNBOUND_HOME}/dev.d" \
        "${UNBOUND_HOME}/var.d" \
        "${UNBOUND_HOME}/run.d"
 	
WORKDIR ${UNBOUND_HOME}

COPY root/etc/unbound/ \
  ${UNBOUND_HOME}/
  
COPY --from=unbound /etc/unbound/unbound.d/ \
  ${UNBOUND_HOME}/unbound.d/
  
COPY --from=unbound /etc/ssl/certs/ \
  /etc/unbound/certs.d/ 

COPY root/unbound.sh \
  /usr/local/sbin/
	
RUN touch ${UNBOUND_HOME}/log.d/unbound.log \
  && chmod -R 0664 \
    ${UNBOUND_HOME}/ \
  && chmod 0755 \
    /usr/local/sbin/unbound.sh \
  && chmod -R 0755 \
    ${UNBOUND_HOME}/unbound.d/sbin/ \ 
  && rm -rf \
    /usr/share/man \
    /usr/share/docs \
    /tmp/* \
    /var/tmp/* \
    /var/log/*
	
ENV PATH="$PATH": \
  ${UNBOUND_HOME}/: \
  ${UNBOUND_HOME}/unbound.d/sbin: \
  ${UNBOUND_HOME}/unbound.d/lib \
      
VOLUME [ \
  "${UNBOUND_HOME}/iana.d", \
  "${UNBOUND_HOME}/conf.d", \
  "${UNBOUND_HOME}/zones.d", \
  "${UNBOUND_HOME}/log.d" \
  ] 

EXPOSE 5335/tcp 5335/udp
	
# # HEALTHCHECK --interval=1m --timeout=3s --start-period=10s \
# #  CMD ${UNBOUND_HOME}/bin/unbound-control -c ${UNBOUND_HOME}/unbound.conf status -s 127.0.0.1:5335 || exit 1

# CMD [ "${UNBOUND_HOME}/unbound.sh" ]
