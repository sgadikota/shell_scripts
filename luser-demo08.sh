#!/bin/bash

# This script demonstrates I/O redirection

# Redirect STDOUT to a file
FILE="/tmp/data"
head -n1 /etc/passwd > ${FILE}

# Redirect STDIN to a program
read LINE < ${FILE}
echo "LINE contains: ${LINE}"

# Redirect STDOUT to a file, overwriting a file.
head -n3 /etc/pass > ${FILE}
echo
echo "Contents of ${FILE}: "
cat ${FILE}

# Redirect STDOUT to a file, appending to a filename
# >>
echo "${RANDOM} ${RANDOM}" >> ${FILE}
echo "${RANDOM} ${RANDOM}" >> ${FILE}
echo
echo "contents of ${FILE}: "
cat ${FILE}

# File descriptors   - file reference by number
# FD 0 - STDIN
# FD 1 - STDOUT
# FD 2 - STDERR  - - doesn't flow through pipe

# if we use filedescriptor instead of file name, use & like


# Redirect STDIN to a program, using FD 0.
read LINE 0< ${FILE}
echo
echo "LINE contains: ${LINE}"

# Redirect STDOUT to a file FD 1, overwriting to a file.
head -n3 /etc/passwd 1> ${FILE}
echo
echo "Contents of ${FILE}"
cat ${FILE}

# Redirect STDERR to a file using FD 2.
ERROR_FILE="/tmp/data.err"
head -n3 /etc/passwd 2> ${ERROR_FILE}

# Redirect STDOUT and STERR to a file.
head -n3 /etc/passwd /fakefile &> ${FILE}
echo
echo "Content of ${FILE}:"
cat ${FILE}

# Redirect STDOUT and STDERR through a pipe.
echo
head -n3 /etc/passwd /fakefile &| cat -n # we appended stderr to stdout

# we do opposite like stdout to stderr
# if we want to use file descriptor instead of file name, we use &
# >&2 and 1>&2 are both same, we are appending stdout (1>) to stderr (&2)

# Send output to stderr
echo "This is STDERR!" >$2

# Discard stdout
echo
echo "Discard STDOUT:"
head -n3 /etd/passwd /fakefile > /dev/null

# Discard stderr
echo
echo "Discarding STDERR:"
head -n3 /etc/passwd /fakefile 2> /dev/null

# Discard both stderr and stdout
echo
echo "Discarding STDOUT and STDERR:"
head -ne /etc/passwd /fakefile &> /dev/null

# Clean up
rm ${FILE} ${ERR_FILE} &> /dev/null
