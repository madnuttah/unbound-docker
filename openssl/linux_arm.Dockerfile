ARG OPENSSL_VERSION="3.1.0" 

FROM alpine:3.17.3 AS buildenv
LABEL maintainer="madnuttah"

ARG OPENSSL_VERSION

ENV OPENSSL_VERSION=${OPENSSL_VERSION} \
  OPENSSL_SHA256="aaa925ad9828745c4cad9d9efeb273deca820f2cdcf2c3ac7d7c1212b7c497b4 " \
  OPENSSL_DOWNLOAD_URL="https://www.openssl.org/source/openssl"

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
      --recv-keys "7953AC1FBC3DC8B3B292393ED5E9E43F7DF9EE8C" \
        "8657ABB260F056B1E5190839D9C4D26D0E604491" \
        "B7C1C14360F353A36862E4D5231C84CDDCC69C45" \
        "A21FAB74B0088AA361152586B8EF1A6BA9DA2D5C" && \
    gpg --batch --verify openssl.tar.gz.asc openssl.tar.gz && \
    tar xzf openssl.tar.gz && \
    cd openssl-"${OPENSSL_VERSION}" && \
    ./Configure \
      no-weak-ssl-ciphers \
      no-ssl3 \
      no-err \
      no-autoerrinit \      
      no-tests \
      shared \
#      enable-tfo \
#      enable-quic \
      -fPIC \
      -DOPENSSL_NO_HEARTBEATS \
      -fstack-protector-strong \
      -fstack-clash-protection \
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
