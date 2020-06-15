#!/bin/bash -e

vagrant ssh-config > ssh-config
sed -i "s,$(pwd),/ceph/src/pybind/mgr/cephadm," ssh-config
