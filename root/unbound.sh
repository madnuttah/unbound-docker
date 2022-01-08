#!/bin/sh
cp -a /dev/random /dev/urandom /dev/null /usr/local/unbound/unbound.d/
/usr/local/unbound/unbound.d/sbin/unbound-anchor -a /usr/local/unbound/iana.d/root.key
exec /usr/local/unbound/unbound.d/sbin/unbound -d -c /usr/local/unbound/unbound.conf
