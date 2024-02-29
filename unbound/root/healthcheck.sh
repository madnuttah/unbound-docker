#!/bin/sh

## Healthcheck

# Change to the port Unbound is listening on 127.0.0.1 (localhost)
PORT="5335"

# Change this to "1" if you would like to verify name resolution using drill
# in the extended healthcheck
EXTENDED="0"

# The domain/host to query in the extended check
DOMAIN="unbound.net"

# Check for opened tcp/udp port(s) with netstat, grep port count and save
# the result into a variable
CHECK_PORT="$(netstat -ln | grep -c ":$PORT")" &> /dev/null

# Opened port count should be larger than 0, otherwise an error in the
# unbound.conf is likely
if [[ "$CHECK_PORT" -eq 0 ]]; then
  echo "⚠️ Port $PORT not open"
  exit 1
else
  echo "✅ Port $PORT open"
# Exit gracefully if EXTENDED=0
  if [[ "$EXTENDED" = "0" ]]; then
    exit 0
  fi
fi

## Extended healthcheck

# Use NLnet Labs drill to query localhost for a domain/host and save the result
# into a variable
IP="$(drill -Q -p $PORT $DOMAIN @127.0.0.1)" &> /dev/null

# Check the errorlevel of the last command, if larger than 0 something with the 
# internet connection doesn't seem right
if [[ $? -ne 0 ]]; then
  echo "⚠️ Domain '$DOMAIN' not resolved"
  exit 1 
else
  echo "✅️ Domain '$DOMAIN' resolved to '$IP'"
  exit 0
fi
