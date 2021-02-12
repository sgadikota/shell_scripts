#!/bin/bash

# This script is to create a user when we run this script.

# Make sure the script is being executed with superuser privileges.
if [[ ${UID} -eq 0 ]]
then
  echo "Root user is running the script"
else
  echo "Run with Sudo or root user"
  exit 1
fi

# Get the username (login).
read -p 'Please enter your username: ' USER_NAME

# Get the real name (contents for the description field).
read -p 'Enter Real Name: ' COMMENT

# Get the password.
read -p 'Enter the password: ' PASSWORD

# Create the user with the password.
useradd -c "${COMMENT}" -m ${USER_NAME} 

# Check to see if the useradd command succeeded.
if [[ "${?}" -eq 0 ]]
then
  echo "${USER_NAME} is created and Default password is set to it"
else 
  echo "${USER_NAME} is not created"
  exit 1
fi

# Set the password
echo "${PASSWORD}" | passwd --stdin ${USER_NAME}

# Check to see if the passwd command succeeded.
if [[ "${?}" -eq 0 ]]
then
  echo "Password is set succesfully"
else
  echo "Password is deleted successfully"
  exit 1
fi

# Force password change on first login.
passwd -e $USER_NAME

# Display the username, password, and the host where the user was created.
echo username: "${USER_NAME}"
echo password: "${PASSWORD}"
echo hostname: $(hostname)
exit 0 
