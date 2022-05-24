ARG LIBEVENT_VERSION="2.1.12" 

FROM madnuttah/unbound:openssl-buildenv-latest AS buildenv
LABEL maintainer="madnuttah"

ARG LIBEVENT_VERSION

ENV LIBEVENT_VERSION=${LIBEVENT_VERSION} \
  LIBEVENT_DOWNLOAD_URL="https://github.com/libevent/libevent/releases/download/release" \
  LIBEVENT_PGP="9E3AC83A27974B84D1B3401DB86086848EF8686D"
  
RUN set -xe; \
  apk --update --no-cache add \
  ca-certificates \
  gnupg \
  curl \
  file && \
  apk --update --no-cache add --virtual .build-deps \
    build-base \
    python3 \
    zlib-dev \
    linux-headers \
    apk-tools && \
    curl -sSL "${LIBEVENT_DOWNLOAD_URL}"-"${LIBEVENT_VERSION}"-stable/libevent-"${LIBEVENT_VERSION}"-stable.tar.gz -o libevent.tar.gz && \
    curl -sSL "${LIBEVENT_DOWNLOAD_URL}"-"${LIBEVENT_VERSION}"-stable/libevent-"${LIBEVENT_VERSION}"-stable.tar.gz.asc -o libevent.tar.gz.asc && \
    GNUPGHOME="$(mktemp -d)" && \
    export GNUPGHOME && \
    gpg --no-tty --keyserver hkps://pgp.mit.edu --recv-keys "${LIBEVENT_PGP}" || \
    gpg --no-tty --keyserver hkps://keyserver.ubuntu.com --recv-keys "${LIBEVENT_PGP}" && \
    gpg --batch --verify libevent.tar.gz.asc libevent.tar.gz && \
    tar xzf libevent.tar.gz && \
    rm libevent.tar.gz && \
    cd libevent-"${LIBEVENT_VERSION}"-stable && \
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
