#! /bin/sh
nslookup internic.net > /dev/null
STATUS=$?
if [[ ${STATUS} -ne 0 ]]
then
    exit 1
fi
