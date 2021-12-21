FROM alpine:latest AS unbound

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
  libssl3-dev \
  nghttp2-libs \
  expat-dev \
  build-base \
  curl \
  file \ 
  && curl -sSL $UNBOUND_DOWNLOAD_URL -o unbound.tar.gz \
  && echo "${UNBOUND_SHA256} *unbound.tar.gz" | sha256sum -c - \
  && tar -xzf unbound.tar.gz \
  && rm unbound.tar.gz \
  && cd unbound-${UNBOUND_VERSION} \
  && addgroup -S _unbound -g 1000 \
  && adduser -S -D -H -h /etc -u 1000 -s /dev/null -G _unbound _unbound \
  && ./configure \
  --prefix=/usr/bin/unbound \
  --sysconfdir=/etc/unbound \
  --with-pthreads \
  --disable-rpath \
  --without-pythonmodule \
  --without-pyunbound \
  --enable-dnscrypt \
  --enable-event-api \
  --enable-tfo-server \
  --enable-tfo-client \
  --enable-event-api \
  --with-deprecate-rsa-1024 \
  --with-username=_unbound \
  --with-libevent \
  --with-ssl \
  && make \
  && make install \
  && apk del --no-cache .build-deps \
  && rm -rf \
    /usr/share/man/* \
    /tmp/* \
    /var/tmp/*
	
FROM alpine:latest

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
  addgroup -S _unbound -g 1000 \
  && adduser -S -D -H -h "${UNBOUND_HOME}" -u 1000 -s /dev/null -G _unbound _unbound \
  && apk add --no-cache \
  libsodium \
  libevent \
  libcap \
  libssl3 \
  nghttp2-libs \
  expat \
  && setcap 'cap_net_bind_service=+ep' _unbound
 	
WORKDIR ${UNBOUND_HOME}

ENV PATH ${UNBOUND_HOME}/bin.d:"$PATH"

COPY root/etc/unbound/ \
  ${UNBOUND_HOME}/

COPY root/unbound.sh \
  ${UNBOUND_HOME}/sbin.d

RUN touch ${UNBOUND_HOME}/log.d/unbound.log \
  && chown -R _unbound:_unbound \
  ${UNBOUND_HOME}/ \
  && chmod -R 0664 \
  ${UNBOUND_HOME}/ \
  && chmod 0774 \
  ${UNBOUND_HOME}/sbin.d/unbound.sh \
  && rm -rf \
	/usr/share/man/* \
	/tmp/* \
	/var/tmp/*
	
COPY --from=unbound /etc/ssl/certs/ \
  ${UNBOUND_HOME}/certs.d/
  
COPY --from=unbound /usr/bin/unbound/ \
  ${UNBOUND_HOME}/