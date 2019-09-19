#!/bin/bash

USER=admin
MOUNT_POINT=mnt


cd /ceph/build

if [ ! -e keyring ]; then
    echo "Can't find keyring file!"
    exit 1
fi

SECRET=$(bin/ceph auth get client.${USER} --format json 2>/dev/null | jq -r '.[0].key')
MON_ADDR=$(bin/ceph mon dump --format json 2>/dev/null | jq -r '.mons[0].public_addrs.addrvec[1].addr')
echo "mount -t ceph ${MON_ADDR}:/ -o name=${USER},secret=${SECRET} $MOUNT_POINT"


