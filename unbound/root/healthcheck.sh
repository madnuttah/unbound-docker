#!/bin/sh

set -eu

### Environment variables

HEALTHCHECK_PORT="${HEALTHCHECK_PORT:-5335}"
EXTENDED_HEALTHCHECK="${EXTENDED_HEALTHCHECK:-false}"
EXTENDED_HEALTHCHECK_DOMAIN="${EXTENDED_HEALTHCHECK_DOMAIN:-nlnetlabs.nl}"
ENABLE_STATS="${ENABLE_STATS:-false}"

### Unbound Statistics

if [ "$ENABLE_STATS" = "true" ]; then
    unbound_root="/usr/local/unbound"

    rawfile="$unbound_root/log.d/unbound_stats"
    tmpfile="$unbound_root/log.d/unbound_stats.tmp"
    logfile="$unbound_root/log.d/unbound-stats.log"

    # Run unbound-control and create file with statistics
    "$unbound_root/unbound.d/sbin/unbound-control" stats_noreset > "$rawfile" 2>/dev/null || true

    sed -E '/(histogram|thread)/d' "$rawfile" > "$tmpfile" || true

    # Convert multiline to single line, comma-separated
    awk -v RS="" -v OFS="," '{$1=$1}1' "$tmpfile" > "$logfile" || true
fi

### Healthcheck

if grep -q "$(printf ':%04X' "$HEALTHCHECK_PORT")" /proc/net/tcp /proc/net/udp 2>/dev/null; then
    printf "✅ Port %s open\n" "$HEALTHCHECK_PORT"
else
    if netstat -ln 2>/dev/null | grep -q ":$HEALTHCHECK_PORT"; then
        printf "✅ Port %s open\n" "$HEALTHCHECK_PORT"
    else
        printf "⚠️ Port %s not open\n" "$HEALTHCHECK_PORT"
        exit 1
    fi
fi

# Exit early if extended check disabled
if [ "$EXTENDED_HEALTHCHECK" != "true" ]; then
    exit 0
fi

### Extended healthcheck

ip=$(drill -Q -p "$HEALTHCHECK_PORT" "$EXTENDED_HEALTHCHECK_DOMAIN" @127.0.0.1 2>/dev/null) || ip=""

# Check exit code AND empty output
if [ -z "$ip" ]; then
    printf "⚠️ Domain '%s' not resolved\n" "$EXTENDED_HEALTHCHECK_DOMAIN"
    exit 1
else
    printf "✅ Domain '%s' resolved to '%s'\n" "$EXTENDED_HEALTHCHECK_DOMAIN" "$ip"
    exit 0
fi
