#!/bin/bash

# To determine the failed attempts hitting with their location
if [[ "${#}" -eq 0 ]]
then
   echo "Provide the details"
   exit 1
fi
echo 'Count , IP , Location'
#Loop through the list of failed attempts and corresponding ip address
awk -F ']: Failed password' '{print $2}' syslog-sample | awk -F 'from' '{print $2}' | awk -F 'port' '{print $1}' | sort | uniq -c | sort -n | while read COUNT IP
 do
   #when the number of attempts is grater than 10
  if [[ ${COUNT} -gt 10 ]]
     then 
     LOCATION=$(geoiplookup ${IP}| awk -F ',' '{print $2}')
     echo "${COUNT} ${IP} ${LOCATION}"
   fi
  done
exit 0

