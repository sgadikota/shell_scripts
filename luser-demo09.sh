#!/bin/bash

# This script demonstrates the case statement.

: '
case "${1}" in
  start)
    echo 'Starting.'
    ;;
  stop)
    echo 'Stopping.'
    ;;
  status)
    echo 'Status: '
    ;;
  *)
    echo 'Supply a valid option.' >&2
    exit 1
    ;;
esac
'

# pattern matching inline

case "${1}" in
  start) echo 'Starting.' ;;
  stop) echo 'Stopping.' ;;
  status) echo 'Status.' ;;
  *)
    echo 'Supply a valid option.' >&2
    exit 1
    ;;
esac
