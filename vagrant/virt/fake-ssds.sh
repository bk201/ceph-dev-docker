#!/bin/bash -ex

for LINK in $(ls /dev/disk/by-id/*-ssd); do
    DEV=$(basename $(readlink $LINK))
    echo "set 0 to /sys/class/block/${DEV}/queue/rotational"
    echo 0 > /sys/class/block/${DEV}/queue/rotational
done
