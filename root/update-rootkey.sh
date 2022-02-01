#!/bin/sh
/usr/local/unbound/unbound.d/sbin/unbound-anchor -a /usr/local/unbound/iana.d/root.key
pkill -HUP -f /usr/local/unbound/unbound.d/sbin/unbound
