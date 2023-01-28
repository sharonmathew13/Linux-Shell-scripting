#!/bin/bash

usage()
{
echo "Usage: ${0} [-nsv] [-f FILE] COMMAND"
echo "Executes COMMAND as a single command on every server."
echo "-f FILE Use FILE for the list of servers. Default: /vagrant/servers."
echo "-n Dry run mode. Display the COMMAND that would have been executed and exit."
echo "-s Execute the COMMAND using sudo on the remote server."
echo "-v Verbose mode. Displays the server name before executing COMMAND."
exit 1
}
FILE_NAME='/vagrant/server'

if [[ ${UID} -eq 0 ]]
then
echo "Do not acccess as root or sudo user"
exit 1
fi


while getopts nsvf: OPTION
do
 case ${OPTION} in
  f)
    FILE_NAME="${OPTARG}"
    ;;
  n)
    DRY_RUN='true'
    ;;
  s)
    SUDO='true'
    ;;
  v)
   echo "Verbose mode ON"
   VERBOSE='true'
   ;;
   ?)
    usage
    ;;
  esac
done

shift "$(( OPTIND - 1 ))"


if [[ "${#}" -eq 0 ]]
then
 usage
 exit 1
fi
 

COMMAND="${@}"
echo "${COMMAND}"
if [[ ! -e "${FILE_NAME}" ]]
then
  echo "Cannot open "${FILE_NAME}""
  exit 1
fi

for SERVER in $(cat ${FILE_NAME})
do
   if [[ "${VERBOSE}" = 'true' ]]
   then
       echo "${SERVER}"
  
       if [[ "${SUDO}" = 'true' ]]
       then
           ssh ${SERVER} sudo ${COMMAND} 
       else
       ssh ${SERVER} ${COMMAND}
       fi 
   elif [[ "${SUDO}" = 'true' ]]
   then
      if [[ "${DRY_RUN}" = 'true' ]]
      then
          echo "DRYRUN: ssh -o ConnectedTimeout=2 ${SERVER} sudo ${COMMAND}"
      else
      ssh ${SERVER} sudo ${COMMAND}
      fi
    elif [[ "${DRY_RUN}" = 'true' ]]
    then 
     echo "DRYRUN: ssh -0 ConnectedTimeout=2 ${SERVER} ${COMMAND}"
    else 
        ssh ${SERVER} ${COMMAND}
   fi
done

