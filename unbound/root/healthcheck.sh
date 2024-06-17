#!/bin/sh

### Environment variables

HEALTHCHECK_PORT=${HEALTHCHECK_PORT:-5335}
EXTENDED_HEALTHCHECK=${EXTENDED_HEALTHCHECK:-false}
EXTENDED_HEALTHCHECK_DOMAIN=${EXTENDED_HEALTHCHECK_DOMAIN:-nlnetlabs.nl}
ENABLE_STATS=${ENABLE_STATS:-false}

## Unbound Statistics

enable_stats=$ENABLE_STATS
if $enable_stats; then

  unbound_root=/usr/local/unbound

  rawfile="$unbound_root/log.d/unbound_stats"
  tmpfile="$unbound_root/log.d/unbound_stats.tmp"
  logfile="$unbound_root/log.d/unbound-stats.log"

  # Run unbound-control and create file with statistics
  $unbound_root/unbound.d/sbin/unbound-control stats_noreset > ${rawfile}

  # Remove unnecessary lines
  sed -r '/.*(histogram|thread).*/d' ${rawfile} > ${tmpfile}

  # Multiline to single line, separated with commas
  awk -vRS="" -vOFS=',' '$1=$1' ${tmpfile} > ${logfile}
fi

## Healthcheck

  # Check for opened tcp/udp port(s) with netstat, grep port count and save
  # the result into a variable
  check_port="$(netstat -ln | grep -c ":$HEALTHCHECK_PORT")" &> /dev/null

  # If opened port count is equal 0 exit ungracefully
  if [ $check_port -eq 0 ]; then
    echo "⚠️ Port $HEALTHCHECK_PORT not open"
    exit 1
  else
    echo "✅ Port $HEALTHCHECK_PORT open"
  # If extended check disabled exit gracefully
    extended_healthcheck=$EXTENDED_HEALTHCHECK
    if ! $extended_healthcheck; then
      exit 0
    fi
  # Otherwise continue, we don't exit here
  fi

## Extended healthcheck

# Use NLnet Labs drill to query localhost for a domain/host and save the result
# into a variable
ip="$(drill -Q -p $HEALTHCHECK_PORT $EXTENDED_HEALTHCHECK_DOMAIN @127.0.0.1)" &> /dev/null

# Check the errorlevel of the last command, if not equal 0 exit ungracefully
if [ $? -ne 0 ]; then
  echo "⚠️ Domain '$EXTENDED_HEALTHCHECK_DOMAIN' not resolved"
  exit 1 
else
  echo "✅️ Domain '$EXTENDED_HEALTHCHECK_DOMAIN' resolved to '$ip'"
  exit 0
fi
