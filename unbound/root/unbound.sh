#!/bin/sh
/usr/local/unbound/unbound.d/sbin/unbound-anchor -a /usr/local/unbound/iana.d/root.key
exec /usr/local/unbound/unbound.d/sbin/unbound -d -c /usr/local/unbound/unbound.conf
