#!/bin/bash
#Function for backuping the files and logging them in syslog
 log(){
#This function sends a message to syslog and to standardoutput if verbose is true
if [[ "${VERBOSITY}" = 'true' ]]
then
 local MESSAGE="${@}"
 echo "${MESSAGE}"
fi
logger -t "${0}" "${MESSAGE}"
}
readonly VERBOSITY='true'

#Backup the files
backupFiles(){
FILE="${1}"
if [[ -f "${1}" ]]
then 
  backupFile="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
  log "the file: "${FILE}" is backedup at "${backupFile}" " 
  cp -p ${FILE} ${backupFile}
else
return 1
fi
}
log  "Hello People!"
backupFiles "/etc/passwd"
 
if [[ "${?}" = 0 ]]
then
log 'File backup successful'
else
log 'File backup failed'
fi

