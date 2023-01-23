#!/bin/bash
#checking the user id
USER_ID=${UID}
if [[ "${USER_ID}" -ne "0" ]]
then 
echo "Its not a sudo or root user"
exit 1
fi
 
 #GET USER NAME
read -p "Enter the user name: " "USER_NAME"
#Get Real Name
read -p "Enter you real name: " "COMMENT"
#GetPassword
read -p "Enter your Paswword: " "PASSWORD"

#add user
useradd -c "${COMMENT}" -m ${USER_NAME}
if [[ "${?}" -ne "0" ]]
then 
echo "USER Account is not creted"
exit 1
fi

#PASSWORD SET fo user_name
echo "${PASSWORD}" | passwd --stdin ${USER_NAME}
if [[ "${?}" -ne "0" ]]
then 
echo "Password is not set for the user account!!"
exit 1 
fi

#Force password change in first login
passwd -e ${USER_NAME}


#Display Details
echo "User Name: "
echo "${USER_NAME}"
echo "Password"
echo "${PASSWORD}"
echo "Host Name"
echo "${HOSTNAME}"
exit 0
