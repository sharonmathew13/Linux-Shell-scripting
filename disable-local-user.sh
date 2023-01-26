#!/bin/bash

usage(){
echo "Usage: "${0}" [-dra] USER [USERN]" >&2
echo "Diasble a local linux account."
echo "  -d Delete accounts instead of disabling them"
echo "  -r Removes the home directory associated with accounts(s)"
echo "  -a Creates an archive of the home directory associated with the accounts."
}
ARCHIVE_DIR='/archieve/'
#
if [[ "${UID}" -ne 0 ]]
then
  echo "Login as root pr sudo user" >&2
  exit 1
fi

while getopts dra OPTION
do
 case "${OPTION}" in
 a) archive='true' ;;
 d) delete_user='true' ;;
 r) REMOVE_OPTION='-r';;
?) usage ;;
esac
done
#
shift "$(( OPTIND - 1 ))"

#
if [[ "${#}" -lt 1 ]]
then
usage
exit 1
fi
#
for USERNAME in "${@}" 
do
 USERID="$(id -u ${USERNAME})"
 if [[ ${USERID} -lt 1000 ]]
 then
    echo "Refuse to remove the ${USERNAME}"
    exit 1
 fi

 if [[ "${archive}" -eq 'true' ]]
 then
 if [[ ! -d "${ARCHIVE_DIR}" ]]
 then
  echo "Creating Archive directory: ${ARCHIVE_DIR}"
  mkdir -p "${ARCHIVE_DIR}"
  if [[ "${?}" -ne 0 ]]
  then
     echo "Archieve directory not created!!"
     exit 1
  fi
 fi
 HOME_DIR="/home/${USERNAME}"
 ARCHIVE_FILE="${ARCHIVE_DIR}/${USERNAME}.tgz"
 if [[ -d ${HOME_DIR} ]]
 then 
 echo "Archiving home directory: ${HOME_DIR} to ${ARCHIVE_FILE}"
 tar -zcf "${ARCHIVE_FILE}" "${HOME_DIR}"
 if [[ "${?}" -ne 0 ]]
 then
   echo "Archive file not created!"
   exit 1
 fi
 else
   echo "The home directory "${HOME_DIR}" is dont exist!"
   exit 1
 fi
 fi

 if [[ "${delete_user}" = 'true' ]]
 then
  userdel ${REMOVE_OPTION} ${USERNAME}
  if [[ "${?}" -ne 0 ]]
    then
    echo "Your account : ${USERNAME} is not deleted"
    exit 1
  fi
  echo "Your account "${USERNAME}" is deleted"
  else
     chage -E 0 ${USERNAME}
     if [[ "${?}" -ne 0 ]]
     then
        echo "Your account was not disabled"
        exit 1
     fi
     echo "Your account is disabled"

 fi
done
exit 0

