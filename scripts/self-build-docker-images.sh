#!/bin/bash
#
# This script is for those people who want to build the unbound image on their own hardware
# Download a copy of the repository, e.g. with the command
#
#   git clone --depth 1 https://github.com/madnuttah/unbound-docker
#
# and execute this script in the base directory of the repository by calling
#
#   scripts/self-build-docker-images.sh <architecture option>
#

if [ ! -e openssl/linux_arm.Dockerfile ]; then
	echo "I cannot find the Dockerfiles, you are not in the repsitory base directory"
	exit 1
fi

if [ -z "$1" ]; then
	echo "no architecture option parameter found."
	echo "add one of these possible options:"
	echo "   arm"
	echo "   64"
	echo "   x86"
	echo
	echo "exit."
	exit 1
fi
ARCH="$1"

# extract some variable assignments from 
# Grep versions | remove VERSIONS | remove quotes | assign to vars
# OpenSSL
OPENSSL_VERSION=$(cat .github/workflows/build-openssl-buildenv.yaml | grep 'VERSION:' | sed 's/VERSION: //' | tr -d '"')
# Libevent
LIBEVENT_VERSION=$(cat .github/workflows/build-libevent-buildenv.yaml | grep 'VERSION:' | sed 's/VERSION: //' | tr -d '"')
# Unbound
UNBOUND_VERSION=$(cat .github/workflows/build-unbound.yaml | grep 'VERSION:' | sed 's/VERSION: //' | tr -d '"')

# check if all necessary variables are set
if [ -n "$OPENSSL_VERSION" -a -n "$LIBEVENT_VERSION" -a -n "$UNBOUND_VERSION" ]; then
	echo "============================================================="
	echo "Build docker image with parameters:"
	echo
	echo "Architecture option = $ARCH"
	echo "OPENSSL_VERSION = $OPENSSL_VERSION"
	echo "LIBEVENT_VERSION = $LIBEVENT_VERSION"
	echo "UNBOUND_VERSION = $UNBOUND_VERSION"
	echo
	echo "============================================================="
else
	echo "error: at least one of these values missing: OPENSSL_VERSION LIBEVENT_VERSION UNBOUND_VERSION"
	echo "exit."
	exit 1
fi

# stop on first error
set -e

docker build -t madnuttah/unbound:openssl-buildenv-${OPENSSL_VERSION} -f openssl/linux_${ARCH}.Dockerfile .

docker build -t madnuttah/unbound:libevent-buildenv-${LIBEVENT_VERSION} -f libevent/Dockerfile .

docker build -t madnuttah/unbound:${UNBOUND_VERSION} -f unbound/Dockerfile .

echo
echo "Image build finished successfully."
