#! /bin/sh
nslookup internic.net 127.0.0.1:53 > /dev/null
STATUS=$?
if [[ ${STATUS} -ne 0 ]]
then
    echo "DNS lookup failed"
    exit 1
fi
