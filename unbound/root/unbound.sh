#!/bin/sh

unbound_root=/usr/local/unbound

bi_white='\033[1;97m'
bi_blue='\033[1;94m'
bi_red='\033[1;91m'
bi_green='\033[1;92m'
bi_yellow='\033[1;93m' 
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

disable_set_perms=${1:-false}
if $disable_set_perms; then
  user_color=$bi_green
  group_color=$bi_green
  if [ $(id -u) -eq 0 ]; then
    user_color=$bi_red
  fi
  if [ $(id -g) -eq 0 ]; then
    group_color=$bi_red
  fi
  echo -e "User: $user_color$(id -un)${color_default}
Group: $group_color$(id -gn)${color_default}
"
else
  echo -e "UNBOUND_UID: ${bi_blue}$(id -u _unbound)${color_default}
UNBOUND_GID: ${bi_blue}$(id -g _unbound)${color_default}
"
fi

echo -e "DISABLE_SET_PERMS: ${bi_yellow}$disable_set_perms${color_default}
"

$unbound_root/unbound.d/sbin/unbound-anchor -a $unbound_root/iana.d/root.key
exec $unbound_root/unbound.d/sbin/unbound -d -c $unbound_root/unbound.conf
