#!/bin/sh

cp -a /dev/random /dev/urandom /dev/null /etc/unbound/dev.d/

/usr/sbin/unbound-anchor -a /etc/unbound/iana.d/root.key

exec /usr/sbin/unbound -d -c /etc/unbound/unbound.conf
