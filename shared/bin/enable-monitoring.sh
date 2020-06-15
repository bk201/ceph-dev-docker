#!/bin/bash -e

cd /ceph/build

bin/ceph mgr module enable prometheus
bin/ceph dashboard set-grafana-api-url http://192.168.2.106:3000
bin/ceph dashboard set-grafana-api-ssl-verify False

