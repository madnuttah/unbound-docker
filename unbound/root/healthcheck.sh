#! /bin/sh
netstat -ln | grep -c ":5335" &> /dev/null # Change ":5335" to the port you may use
STATUS=$?
#STATUS=0
if [[ ${STATUS} -ge 1 ]]
then
    exit 0
fi
