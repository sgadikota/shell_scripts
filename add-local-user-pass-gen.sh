#!/bin/bash

# This script is to create a user when we run this script.

# Make sure the script is being executed with superuser privileges. else it will return exit status 1
if [[ ${UID} -eq 0 ]]
then
  echo "Root user is running the script"
else
  echo "Run with Sudo or root user"
  exit 1
fi

# Make sure provide account name as argument

if [[ "${#}" -lt 1 ]]
then
  echo "U have not passed account name, please see the usage below"
  echo "Usage: ${0} ACCOUNT_NAME [ACCOUNT_NAME]..."
  exit 1
fi

ACCOUNT_NAME=${*}

# getting username as first word from account name entered
USER_NAME="$(echo ${ACCOUNT_NAME} | head -n1 | awk '{print $1;}')"
echo "username going to be created is: ${USER_NAME}"

# except first word everything is taken as comment
COMMENT="$(echo ${ACCOUNT_NAME} | sed "s/^[^ ]* //")"
echo "comment to be updated is: ${COMMENT}"

# creating an user, man useradd --> -c for comment ; -m for creating home directory if it doen't exist.
useradd -c "${COMMENT}" -m ${USER_NAME}

# Use the current date/time as the basis for the password.
PASSWORD=$(date +%s)
echo "Password generated: ${PASSWORD}"

# Set the password for the user.
echo ${PASSWORD} | passwd --stdin ${USER_NAME}


# check if the user is created using the id command; id -u name
# type -a id; man id;

ID="$(id -u ${USER_NAME})"

if [[ ${ID} -eq 1000 ]]
then
  echo "User account is not created somehow"
  exit 1
else
  echo "User account is created"
fi

# Force password change on first login
passwd -e ${USER_NAME}

# Display the username, password, and the host where the user was created.
echo username: "${USER_NAME}"
echo password: "${PASSWORD}"
echo hostname: $(hostname)
exit 0
