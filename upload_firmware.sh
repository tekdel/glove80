#!/bin/env bash

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

device=""
firmware=''

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --device=*)
            device="${1#*=}"
            ;;
        --firmware=*)
           firmware="${1#*=}"
            ;;
        *)
            echo "Unknown parameter passed: $1"
            exit 1
            ;;
    esac
    shift
done

# Check if required arguments are provided
if [ -z "$device" ] || [ -z "$firmware" ]; then
    echo "Usage: ./upload_firmware.sh --device=/dev/sda --firmware=~/Downloads/glove80.uf2"
    exit 1
fi


mkdir -p /tmp/glove80

while [ ! -e "$device" ]; do
    sleep 1
    printf 'Waiting for the right side to be connected...\r'
done

mount $device /tmp/glove80
cp $firmware /tmp/glove80
umount /tmp/glove80

printf "Right side has been updated\n\n"

for (( i=10; i>=1; i-- )); do
    echo -ne " $i second(s) \r"
    sleep 1
done

while [ ! -e "$device" ]; do
    sleep 1
    printf 'Waiting for the left side to be connected...\r'
done

mount $device /tmp/glove80
cp $firmware /tmp/glove80
umount /tmp/glove80

printf "Left side has been updated\n\n"

sleep 1

printf "Done! Restart the keyboard\n"
