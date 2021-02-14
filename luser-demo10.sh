#!/bin/bash

log() {

  # This function sends a message to syslog and to standard output if VERBOSE is true.
  # local makes MESSAGE variable as local to this function instead of using globally.
  # ${@} by using this, all the arguments passed to script are wrapped and passed here where we are calling.

  local MESSAGE="${@}"
  if [[ "${VERBOSE}" = 'true' ]]
  then
    echo "${MESSAGE}"
  fi

  logger -t luser-demo10.sh "${MESSAGE}"
}

backup_file() {

  # This function creates a backup of a file. Returns non-zero status on error.

  local FILE="${1}"

  # Make sure the file exists.

  if [[ -f "${FILE}" ]]
  then
    local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"

  # typically files under /tmp are cleared on boot.
  # on centOS /tmp file will be deleted every 10 days and /var/tmp will be deleted every 30 days.

    log "Backing up ${FILE} to ${BACKUP_FILE}."

    # The exit status of the function will be the exit status of the cp command.
    # -p flag preserves the timestamp at destination as source.
    cp -p ${FILE} ${BACKUP_FILE}
  else
    # The file does not exist, so return a non-zero exit status.
    return 1
  fi
}


readonly VERBOSE='true'
log 'Hello!'  # calling log function with an argument
log 'This is fun!'

backup_file '/etc/passwd'   # calling backup_file function and passing path as argument

# Make a decision based on the exit status of the function.
if [[ "${?}" -eq '0' ]]
then
  log 'File backup succeded!'
else
  log 'File backup failed!'
  exit 1
fi



# logger will make entries in the system log, it provides a shell command interface to the syslog(3) system log module. -t --tag usage: every line will be logged with the specified tag.
# syslog path is /var/log/messages
# syslog can be configured to send messages off the server into a centralized syslog location.
# if someone got root access to a system, they can manually edit syslogs, but storing logs in centralized location, we can track every log securely.
# readonly keyword is used to make a variable immutable by a function.
# inside a function its super important to use return command instead of exit.
# if exit command is executed it exits the entire script.
# so exit command is for entire script, return is for just function.
