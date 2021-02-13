#!/bin/bash

# Added STDERR STDOUT and STDIN

# to seperate stdout and stderr run this way
# sudo ./add-newer-local-user.sh 1>std.out 2>std.err
# ******* send the errors to stderr by using >&2 along with echo or where needed
# *** check this link when to use &> and 2>&1
# https://askubuntu.com/questions/635065/what-is-the-differences-between-and-21
# https://unix.stackexchange.com/questions/443823/what-is-the-difference-between-2-and-2
# This script is to create a user when we run this script.

# Make sure the script is being executed with superuser privileges. else it will return exit status 1
if [[ ${UID} -eq 0 ]]
then
  echo "Run with Sudo or root user" >&2
  exit 1
fi

# Make sure provide account name as argument

if [[ "${#}" -lt 1 ]]
then
  echo "U have not passed account name, please see the usage below" >&2
  echo "Usage: ${0} ACCOUNT_NAME [ACCOUNT_NAME]..." >&2
  exit 1
fi

ACCOUNT_NAME=${*}

# getting username as first word from account name entered
USER_NAME="$(echo ${ACCOUNT_NAME} | head -n1 | awk '{print $1;}')"
echo "username going to be created is: ${USER_NAME}" >&2


# except first word everything is taken as comment
# COMMENT="$(echo ${ACCOUNT_NAME} | sed "s/^[^ ]* //")"
# echo "comment to be updated is: ${COMMENT}" &> /dev/null
shift
COMMENT="${@}"


# creating an user, man useradd --> -c for comment ; -m for creating home directory if it doen't exist.
useradd -c "${COMMENT}" -m ${USER_NAME} &> /dev/null

# Use the current date/time as the basis for the password.
PASSWORD=$(date +%s)
echo "Password generated: ${PASSWORD}" >&2

# Set the password for the user.
echo ${PASSWORD} | passwd --stdin ${USER_NAME} >&2


# check if the user is created using the id command; id -u name
# type -a id; man id;

ID="$(id -u ${USER_NAME})"

if [[ ${ID} -eq 1000 ]]
then
  echo "User account is not created somehow" >&2
  exit 1
else
  echo "User account is created" >&2
fi

# Force password change on first login
passwd -e ${USER_NAME} &> /dev/null

# Display the username, password, and the host where the user was created.
echo
echo
echo username: "${USER_NAME}"
echo
echo
echo password: "${PASSWORD}"
echo
echo
echo hostname: $(hostname)
echo
echo
exit 0
