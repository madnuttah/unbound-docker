#! /bin/sh

SOCKET=/usr/local/unbound/cachedb.d/redis.sock
if [[ ! -S "$SOCKET" ]];
then
    exit 1    
fi
