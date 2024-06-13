#!/bin/sh

DISABLE_SET_PERMS=${DISABLE_SET_PERMS:-false}

bi_white='\033[1;97m'
bi_blue='\033[1;94m'
bi_red='\033[1;91m'
bi_green='\033[1;92m'
color_default='\033[0m'

echo -e "╔═════════════════════════════════════════════════════╗
║                                                     ║
║                  ${bi_white}MΛDИVTTΛH Unbound${color_default}                  ║
║                                                     ║
║     https://github.com/madnuttah/unbound-docker     ║
║     https://hub.docker.com/r/madnuttah/unbound      ║
║                                                     ║
╚═════════════════════════════════════════════════════╝
"

bool=$DISABLE_SET_PERMS
if $bool; then
  color_user=$bi_green
  color_group=$bi_green
  if [ $(id -u) -eq 0 ]; then
    color_user=$bi_red
  fi
  if [ $(id -g) -eq 0 ]; then
    color_group=$bi_red
  fi
  echo -e "User: $color_user$(id -un)${color_default}
Group: $color_group$(id -gn)${color_default}
"
else
  echo -e "UNBOUND_UID: ${bi_blue}$(id -u _unbound)${color_default}
UNBOUND_GID: ${bi_blue}$(id -g _unbound)${color_default}
"
fi

/usr/local/unbound/unbound.d/sbin/unbound-anchor -a /usr/local/unbound/iana.d/root.key
exec /usr/local/unbound/unbound.d/sbin/unbound -d -c /usr/local/unbound/unbound.conf
