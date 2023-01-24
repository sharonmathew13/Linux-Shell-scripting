#!/bin/bash

if [[ ${UID} -ne 0 ]]
then
echo "Please run with sudo or as root"
exit 1
fi

NUMBER_OF_ARGUMENTS="${#}"
if [[ "${NUMBER_OF_ARGUMENTS}" -lt 1 ]]
then 
echo "Usage: "${0}" USER_NAME [COMMENT ...]"
echo "Create an account on the local system with the name of USER_NAME and a comments field as COMMENT."
exit 1
fi

#The first parameter is user_name
USER_NAME="${1}"
#Rest of the parameters are comments
shift
COMMENTS="${@}"
echo "${COMMENTS}"

#Create Password
PASSWORD=$(date +%s%N|sha256sum|head -c42)
#Create User
useradd -c "${COMMENTS}" -m "${USER_NAME}"
if [[ "${?}" -ne 0 ]]
then 
echo "Your user account is not created!"
exit 1
fi
#Check Password for the USER is set
echo "${PASSWORD}"|passwd --stdin ${USER_NAME}
if [[ "${?}" -ne 0 ]]
then 
echo "Your Password is not set to the user"
exit 1
fi

#force to change password on first login
passwd -e ${USER_NAME}

echo
echo "USER_NAME :"
echo "${USER_NAME}"
echo
echo
echo "PASSWORD"
echo "${PASSWORD}"
echo 
echo
echo "HOST NAME"
echo "${HOSTNAME}"

exit 0


