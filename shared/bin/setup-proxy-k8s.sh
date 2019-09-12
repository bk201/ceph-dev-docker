#!/bin/bash

set -e

USER=root
ADMIN_HOST=172.16.100.30

PORT=$(ssh ${USER}@${ADMIN_HOST} kubectl -n rook-ceph get service rook-ceph-mgr-dashboard-external-https -o json | jq '.spec.ports[0].nodePort')
URL='"'https://${ADMIN_HOST}:${PORT}'"'


cd /ceph/src/pybind/mgr/dashboard/frontend
jq '.["/api/"].target'=$URL proxy.conf.json.sample | jq '.["/ui-api/"].target'=$URL  > proxy.conf.json
