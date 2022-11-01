ARG OPENSSL_VERSION="3.0.7" 

FROM alpine:latest AS buildenv
LABEL maintainer="madnuttah"

ARG OPENSSL_VERSION

ENV OPENSSL_VERSION=${OPENSSL_VERSION} \
  OPENSSL_SHA256="83049d042a260e696f62406ac5c08bf706fd84383f945cf21bd61e9ed95c396e " \
  OPENSSL_DOWNLOAD_URL="https://www.openssl.org/source/openssl" \
  OPENSSL_SIGNER_RSA="DC7032662AF885E2F47F243F527466A21CA79E6D" \
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
    gpg --recv-keys "${OPENSSL_SIGNER_RSA}" && \
    gpg --batch --verify openssl.tar.gz.asc openssl.tar.gz && \
    tar xzf openssl.tar.gz && \
    cd openssl-"${OPENSSL_VERSION}" && \
    ./Configure \
      no-weak-ssl-ciphers \
      no-ssl3 \
      no-err \
      no-tests \
      shared \
# enable-quic \
      enable-ec_nistp_64_gcc_128 \
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
