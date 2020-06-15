#!/bin/bash -ex

cd /ceph/build
bin/ceph mgr module enable test_orchestrator
bin/ceph orch set backend test_orchestrator
bin/ceph test_orchestrator load_data -i /ceph/src/pybind/mgr/test_orchestrator/dummy_data.json
