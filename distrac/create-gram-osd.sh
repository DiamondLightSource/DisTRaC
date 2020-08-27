#!/usr/bin/env bash
size=""
amount=0
folder="."
for i in "$@"
do
case $i in
    -f=*|--folder=*)
    folder="${i#*=}"
    mkdir $folder
    shift # past argument=value
    ;;
    -n=*|--number=*)
    amount="${i#*=}"
    shift # past argument=value
    ;;
    *)
          # unknown option
    ;;
esac
done
# Copying keys to system
sudo cp $folder/ceph.client.admin.keyring /etc/ceph/
sudo cp $folder/ceph.conf /etc/ceph/
sudo cp $folder/ceph.bootstrap-osd.keyring  /var/lib/ceph/bootstrap-osd/ceph.keyring
# Creating OSDs using ceph-volume
for num in $(seq 0 $[amount-1])
do
	sudo ceph-volume lvm create --data /dev/gram$num &
	wait
done
wait
