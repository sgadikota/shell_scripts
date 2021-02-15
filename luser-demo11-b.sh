#!/bin/bash

# how to pass options to script or command while running like ./shell_run.sh -l -s -v
# how to process command line options using getopts using while case.
# if we have an argument along with option, a trailing : is used with getopts like l: in vl:s
# $((1 + 2))
# let NUM='2 + 3'
# expr 2 + 3


# This script generates a random password.
# This user can set the password length with -l and add a special character with -s.
# Verbose mode can be enabled with -v.


usage() {
  echo "Usage: ${0} [-vs] [-l LENGTH]" >&2
  echo 'Generate a random password.'
  echo '  -l LENGTH  Specify the password length.'
  echo '  -s         Special character select'
  echo '  -v         More verbose'
  exit 1
}

log() {
  local MESSAGE="${@}"
  if [[ "${VERBOSE}" = 'true' ]]
  then
    echo "${MESSAGE}"
  fi
}

# Set a default password length.
LENGTH=48

while getopts vl:s OPTION
do
  case ${OPTION} in
    v)
      VERBOSE='true'
      log 'Verbose mode on.'
      ;;
    l)
      LENGTH="${OPTARG}"
      ;;
    s)
      USE_SPECIAL_CHARACTER="true"
      ;;
    ?)
      usage
      ;;
  esac
done

echo "Number of arguments: ${#}"
echo "All args: ${@}"
echo "First arg: ${1}"
echo "Second arg: ${2}"
echo "Third arg: ${3}"

# Inspect OPTIND
echo "OPTIND: ${OPTIND}"

shift "$(( OPTIND - 1))"

echo 'After the shift: '

echo "Number of arguments: ${#}"
echo "All args: ${@}"
echo "First arg: ${1}"
echo "Second arg: ${2}"
echo "Third arg: ${3}"

if [[ "${#}" -gt 0 ]]
then
  usage
  exit 1
fi

log 'Generating a password'

PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c${LENGTH})

# Append a special character if requested to do so.
if [[ "${USE_SPECIAL_CHARACTER}" = 'true' ]]
then
  log 'Selecting a random special character.'
  SPECIAL_CHARACTER=$(echo '!@#$%^&*()_+=' | fold -w1 | shuf | head -c1)
  PASSWORD="${PASSWORD}${SPECIAL_CHARACTER}"
fi

log 'Done'
log 'Here is the password: '

# Display the password
echo "${PASSWORD}"

exit 0
