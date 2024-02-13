ARG OPENSSL_VERSION="3.2.1" 

FROM alpine:3.19.1 AS buildenv
LABEL maintainer="madnuttah"

ARG OPENSSL_VERSION

ENV OPENSSL_VERSION=${OPENSSL_VERSION} \
  OPENSSL_SHA256="83c7329fe52c850677d75e5d0b0ca245309b97e8ecbcfdc1dfdc4ab9fac35b39" \
  OPENSSL_DOWNLOAD_URL="https://www.openssl.org/source/openssl" \
  OPENSSL_PGP="EFC0A467D613CB83C7ED6D30D894E2CE8B3D79F5"

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
    curl -sSL "${OPENSSL_DOWNLOAD_URL}"-"${OPENSSL_VERSION}".tar.gz -o openssl.tar.gz && \
    echo "${OPENSSL_SHA256} ./openssl.tar.gz" | sha256sum -c - && \
    curl -L "${OPENSSL_DOWNLOAD_URL}"-"${OPENSSL_VERSION}".tar.gz.asc -o openssl.tar.gz.asc && \
    GNUPGHOME="$(mktemp -d)" && \
    export GNUPGHOME && \
    gpg --no-tty --keyserver hkps://keys.openpgp.org \
      --recv-keys "${OPENSSL_PGP}" && \
    gpg --batch --verify openssl.tar.gz.asc openssl.tar.gz && \
    tar xzf openssl.tar.gz && \
    cd openssl-"${OPENSSL_VERSION}" && \
	env CPPFLAGS='-arch i386' \
      LDFLAGS='-arch i386' && \
    ./Configure \
      linux-generic32 \
      -m32 \
      no-weak-ssl-ciphers \
      no-apps \
      no-docs \
      no-legacy \
      no-ssl3 \
      no-err \
      no-autoerrinit \          
      shared \
      386 \
      enable-tfo \
      enable-quic \
      enable-ktls \
      -fPIC \
      -DOPENSSL_NO_HEARTBEATS \
      -fstack-protector-strong \
      -fstack-clash-protection \
      --prefix=/openssl \
      --openssldir=/openssl \
      --libdir=/openssl/lib && \
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
      
