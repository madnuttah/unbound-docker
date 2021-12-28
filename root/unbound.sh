#!/bin/sh

cp -a /dev/random /dev/urandom /dev/null /etc/unbound/unbound.d/
/etc/unbound/unbound.d/sbin/unbound-anchor -a /etc/unbound/iana.d/root.key
exec /etc/unbound/unbound.d/sbin/unbound -d -c /etc/unbound/unbound.conf
