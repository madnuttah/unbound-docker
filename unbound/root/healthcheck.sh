#!/bin/sh
netstat -ln | grep -c ":5335" &> /dev/null # Change ":5335" to the port you may use
STATUS=$?
if [[ ${STATUS} -eq 0 ]]
then
    exit 0
fi
