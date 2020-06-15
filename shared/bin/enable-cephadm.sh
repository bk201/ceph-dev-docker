#!/bin/bash -ex

cd /ceph/build

release=$(sed -n 2p /ceph/src/ceph_release)
case ${release} in
    pacific)
        branch="master"
        ;;
    *)
        branch=${release}
        ;;
esac

#IMAGE="quay.io/ceph-ci/ceph:${branch}"
IMAGE="docker.io/ceph/daemon-base:${branch}"
bin/ceph config set global container_image $IMAGE
#bin/ceph config set mds container_image $IMAGE
#bin/ceph config set mgr container_image $IMAGE
#bin/ceph config set osd container_image $IMAGE

bin/ceph mgr module enable cephadm
bin/ceph orch set backend cephadm
 
# Add ssh config file of VMs
ceph cephadm set-priv-key -i /root/.ssh/id_rsa
ceph cephadm set-pub-key -i /root/.ssh/id_rsa.pub

bin/ceph cephadm set-ssh-config -i /ceph/src/pybind/mgr/cephadm/ssh-config
 
 
# Add VMs
#bin/ceph orch host add mon0
bin/ceph orch host add mgr0
bin/ceph orch host add osd0
 
# List hosts
bin/ceph orch host ls
 
# List devices
# NOTE: you'll notice the CLI blocks, the cephadm orchestrator is asking each VMs to:
# - pull ceph/daemon-base:latest-master-devel image.
# - run ceph-volume to report disks.
# The operation time depends on the network speed.
# Eventually we need to cache the image in a local registry and pull from it to speedup.
bin/ceph orch device ls --refresh
#echo '{"testing_dg_admin": {"host_pattern": "osd*", "data_devices": {"all": true}}}' | bin/ceph orch osd create -i -


bin/ceph osd pool create rbd 8 8
bin/ceph osd pool application enable rbd rbd 



exit 0
# monitoring
bin/ceph mgr module enable prometheus
bin/ceph orch apply node-exporter '*'
bin/ceph orch apply alertmanager 1
bin/ceph orch apply prometheus 1
bin/ceph orch apply grafana 1
