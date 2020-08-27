#!/usr/bin/env bash
# On each host this is run
(sudo vgdisplay | grep -o "ceph.*" ) | while read -r remove; 
do 
    yes | sudo vgremove $remove &
	wait 
done
wait
while read Line1 filelocation  rest;
	do
		  sudo umount $filelocation &
		  wait
done  < <(cat /proc/mounts | grep "ceph/osd")

sudo systemctl reset-failed 
sudo rm -r /var/lib/ceph/osd/
sudo mkdir /var/lib/ceph/osd/
