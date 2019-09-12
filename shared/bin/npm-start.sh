#!/bin/bash

set -e

if [ -n "$PROXY_K8S" ]; then
    setup-proxy-k8s.sh
else
    setup-proxy.sh
fi

cd /ceph/src/pybind/mgr/dashboard/frontend
source /ceph/build/src/pybind/mgr/dashboard/node-env/bin/activate
npm ci --unsafe-perm

npm start
