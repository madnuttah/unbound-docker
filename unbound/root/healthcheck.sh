#! /bin/sh
nslookup internic.net 127.0.0.1:53 > /dev/null
STATUS=$?
if [[ ${STATUS} -ne 0 ]]
then
    exit 1
fi
