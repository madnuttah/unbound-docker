#!/bin/sh

## Healthcheck

PORT="5335" # Change to the port Unbound is listening on 127.0.0.1 (localhost)
DOMAIN="unbound.net" # The domain/host to query in the extended check
EXTENDED="0" # Change this to "1" if you would like to verify name resolution using drill

CHECK_PORT="$(netstat -ln | grep -c ":$PORT")" &> /dev/null

if [[ "$CHECK_PORT" -eq 0 ]]; then
  echo "⚠️ Port $PORT not open"
  exit 1
else
  echo "ℹ️ Port $PORT open"
  if [[ "$EXTENDED" = "0" ]]; then
    exit 0
  fi
fi

## Extended healthcheck

IP="$(drill -Q -p $PORT $DOMAIN @127.0.0.1)" &> /dev/null

if [[ $? -ne 0 ]]; then
  echo "⚠️ Domain '$DOMAIN' not resolved"
  exit 1 
else
  echo "ℹ️ Domain '$DOMAIN' resolved to '$IP'"
  exit 0
fi
