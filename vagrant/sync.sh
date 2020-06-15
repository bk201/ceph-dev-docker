#!/bin/bash

./prepare-ssh.sh

rsync -avz --delete .vagrant /home/kiefer/codes/ceph/src/pybind/mgr/cephadm/
rsync -avz ssh-config /home/kiefer/codes/ceph/src/pybind/mgr/cephadm/

rsync -avz --delete .vagrant /home/kiefer/codes/ceph-octopus/src/pybind/mgr/cephadm/
rsync -avz ssh-config /home/kiefer/codes/ceph-octopus/src/pybind/mgr/cephadm/
