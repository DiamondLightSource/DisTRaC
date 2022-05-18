#!/usr/bin/env bash

# Stop Daemons
sudo systemctl stop ceph.target
sudo systemctl stop ceph-mon.target
sudo systemctl stop ceph-mgr.target
sudo systemctl stop ceph-mds.target
sudo systemctl stop ceph-radosgw.target
sudo systemctl stop ceph-crash.service
sudo systemctl stop ceph-osd.target &
osd=$!
wait $osd

# Remove Ceph system
sudo find "/var/lib/ceph/bootstrap-mgr/" -mindepth 1 -delete
sudo find "/var/lib/ceph/bootstrap-osd/" -mindepth 1 -delete
sudo find "/var/lib/ceph/bootstrap-rbd/" -mindepth 1 -delete
sudo find "/var/lib/ceph/bootstrap-rgw/" -mindepth 1 -delete
sudo find "/var/lib/ceph/bootstrap-mds/" -mindepth 1 -delete
sudo find "/var/lib/ceph/mgr/" -mindepth 1 -delete
sudo find "/var/lib/ceph/mon/" -mindepth 1 -delete
sudo find "/var/lib/ceph/radosgw/" -mindepth 1 -delete
sudo find "/var/lib/ceph/mds/" -mindepth 1 -delete
sudo find "/var/lib/ceph/tmp/" -mindepth 1 -delete
sudo find "/var/log/ceph/" -mindepth 1 -delete
sudo find "/var/lib/ceph/crash/" -mindepth 1 -delete
# Stop deamons
sudo systemctl stop system-ceph\\x2dmgr.slice 
sudo systemctl stop system-ceph\\x2dmon.slice 
sudo systemctl stop system-ceph\\x2dmds.slice
sudo systemctl stop system-ceph\\x2dosd.slice 
sudo systemctl stop system-ceph\\x2dradosgw.slice
sudo systemctl stop system-ceph\\x2dvolume.slice
