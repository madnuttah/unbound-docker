ARG OPENSSL_VERSION="3.1.2" 

FROM alpine:3.18.3 AS buildenv
LABEL maintainer="madnuttah"

ARG OPENSSL_VERSION

ENV OPENSSL_VERSION=${OPENSSL_VERSION} \
  OPENSSL_SHA256="a0ce69b8b97ea6a35b96875235aa453b966ba3cba8af2de23657d8b6767d6539 " \
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
        "A21FAB74B0088AA361152586B8EF1A6BA9DA2D5C" \
        "EFC0A467D613CB83C7ED6D30D894E2CE8B3D79F5" && \
    gpg --batch --verify openssl.tar.gz.asc openssl.tar.gz && \
    tar xzf openssl.tar.gz && \
    cd openssl-"${OPENSSL_VERSION}" && \
	env CPPFLAGS='-arch i386' \
      LDFLAGS='-arch i386' && \
    ./Configure \
      linux-generic32 \
      -m32 \
      no-weak-ssl-ciphers \
      no-ssl3 \
      no-err \
      no-autoerrinit \      
      no-tests \     
      shared \
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
      
