#!/usr/bin/env bash

# Stop Daemons
sudo systemctl stop ceph.target
sudo systemctl stop ceph-mon.target
sudo systemctl stop ceph-mgr.target
sudo systemctl stop ceph-radosgw.target
sudo systemctl stop ceph-osd.target &
osd=$!
wait $osd
# Remove Ceph system
sudo rm -r /var/lib/ceph/bootstrap-mgr/
sudo rm -r /var/lib/ceph/bootstrap-osd/
sudo rm -r /var/lib/ceph/bootstrap-rbd/
sudo rm -r /var/lib/ceph/bootstrap-rgw/
sudo rm -r /var/lib/ceph/mgr/
sudo rm -r /var/lib/ceph/mon/
sudo rm -r /var/lib/ceph/radosgw/
sudo rm -r /var/lib/ceph/tmp/
sudo rm -r /etc/ceph/
# Create Ceph system
sudo mkdir /var/lib/ceph/bootstrap-mgr/
sudo mkdir /var/lib/ceph/bootstrap-osd/
sudo mkdir /var/lib/ceph/bootstrap-rbd/
sudo mkdir /var/lib/ceph/bootstrap-rgw/
sudo mkdir /var/lib/ceph/mgr/
sudo mkdir /var/lib/ceph/mon/
sudo mkdir /var/lib/ceph/radosgw/
sudo mkdir /var/lib/ceph/tmp/
sudo mkdir /etc/ceph
# Stop deamons
sudo systemctl stop system-ceph\\x2dmgr.slice 
sudo systemctl stop system-ceph\\x2dmon.slice 
sudo systemctl stop system-ceph\\x2dosd.slice 
sudo systemctl stop system-ceph\\x2dradosgw.slice
sudo systemctl stop system-ceph\\x2dvolume.slice
