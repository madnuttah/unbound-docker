ARG OPENSSL_VERSION="3.0.5" 

FROM alpine:latest AS buildenv
LABEL maintainer="madnuttah"

ARG OPENSSL_VERSION

ENV OPENSSL_VERSION=${OPENSSL_VERSION} \
  OPENSSL_SHA256="aa7d8d9bef71ad6525c55ba11e5f4397889ce49c2c9349dcea6d3e4f0b024a7a " \
  OPENSSL_DOWNLOAD_URL="https://www.openssl.org/source/openssl" \
  OPENSSL_LEVITTE_RSA="7953AC1FBC3DC8B3B292393ED5E9E43F7DF9EE8C" \
  OPENSSL_PGP="8657ABB260F056B1E5190839D9C4D26D0E604491"

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
    gpg --no-tty --keyserver hkps://keys.openpgp.org --recv-keys "${OPENSSL_PGP}" && \
    gpg --recv-keys "${OPENSSL_LEVITTE_RSA}" && \
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
      no-tests \
      shared \
# enable-quic \
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
