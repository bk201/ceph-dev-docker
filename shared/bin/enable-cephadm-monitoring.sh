#!/bin/bash

cd /ceph/build
bin/ceph mgr module enable prometheus
bin/ceph orch apply node-exporter '*'
bin/ceph orch apply alertmanager 1
bin/ceph orch apply prometheus 1
bin/ceph orch apply grafana 1
