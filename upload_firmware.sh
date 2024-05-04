#!/bin/env bash

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

while [ ! -f /dev/sda ] ; do sleep 1; printf 'Waiting for the right side to be connected...\r'; done

printf "Right side has been updated\n"

while [ ! -f /dev/sda ] ; do sleep 1; printf 'Waiting for the left side to be connected...\r'; done

printf "Done! Restart the keyboard\n"
