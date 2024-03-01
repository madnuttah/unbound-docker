#!/bin/sh

SOCKET=/usr/local/unbound/cachedb.d/redis.sock
if [[ ! -S "$SOCKET" ]]; then
  echo "⚠️ Unix Socket not found"
  exit 1    
else 
  echo "✅ Unix Socket found"
  exit 0
fi
