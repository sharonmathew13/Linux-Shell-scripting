#!/bin/bash


usage(){
echo "Usage: ${0} [-vs] [-l LENGTH]"
echo "To Generate th epassword we need: "
echo "  -l LENGTH Specify th elength of the password"
echo "   -s Specify if special character to be added"
echo "   -v Increase the verbosity" 
}
log(){
local MESSAGE="${@}"
if [[ "${VERBOSE}" -eq 'true' ]]
 then
    echo "${MESSAGE}"
fi
}
LENGTH=48

while getopts vl:s OPTION
do
 case ${OPTION} in
   s)
   USE_SPECIAL_CHARC='true'
   ;;
   v)
   VERBOSE='true'
   echo "Verbose Mode ON"
   ;;
   l)
   LENGTH="${OPTARG}"
   ;;
   ?)
   usage
   ;;
esac
done

log "Generating password"

PASSWORD="$(date +%s%N | sha256sum | head -c${LENGTH})"
if [[ ${USE_SPECIAL_CHARC} -eq 'true' ]]
then
  CHARACTERS='!@#$%^&*()_+=-'
  SPECIAL_CHARC=$(echo "${CHARACTERS}" | fold -w1 | shuf | head -c1)
  PASSWORD="${PASSWORD}${SPECIAL_CHARC}"
fi
echo "${PASSWORD}"
