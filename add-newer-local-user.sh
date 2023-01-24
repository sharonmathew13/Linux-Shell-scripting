#!/bin/bash
if [[ "${UID}" -ne 0 ]]
then 
echo "Please login as root or sudo user" >&2
exit 1 
fi
if [[ "${#}" -lt 1 ]]
then
echo "Usage: ${0} USER_NAME []COMMENT ...]" >&2
echo "Create an account on the local system with the name of the USER_NAME and a comments field of COMMENT". >&2
exit 1 
fi
USER_NAME="${1}"
echo "${USER_NAME}"
shift
COMMENT="${@}"
PASSWORD=$(date +%s%N | sha256sum |head -c43)
useradd -c "${COMMENT}" -m "${USER_NAME}" &> /dev/null
if [[ "${?}" -ne 0 ]]
then
echo "Your account was not created" >&2
exit 1
fi
echo "${PASSWORD}" | passwd --stdin "${USER_NAME}" &> /dev/null
if [[ "${?}" -ne 0 ]]
then
echo "Your password is not set" >&2
exit 1
fi
passwd -e ${USER_NAME} &> /dev/null
echo
echo
echo "USER NAME"
echo "${USER_NAME}"
echo
echo "PASSWORD"
echo "${PASSWORD}"
echo
echo "HOST NAME"
echo "${HOSTNAME}"
