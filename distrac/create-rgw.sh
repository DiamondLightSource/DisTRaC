#!/usr/bin/env bash
folder="."
for i in "$@"
do
case $i in
    -f=*|--folder=*)
    folder="${i#*=}"
    mkdir $folder
    shift # past argument=value
    ;;
    *)
          # unknown option
    ;;
esac
done


# Create RGW Key
ceph auth get-or-create client.radosgw.$HOSTNAME  osd 'allow *' mon 'allow *' >  $folder/ceph.client.radosgw.keyring
# Creating rgw folder
sudo mkdir /var/lib/ceph/radosgw/ceph-radosgw.$HOSTNAME
# copy key to system
sudo cp $folder/ceph.client.radosgw.keyring /var/lib/ceph/radosgw/ceph-radosgw.$HOSTNAME/keyring
# Setting folder permission to ceph user
sudo chown -R ceph:ceph /var/lib/ceph/radosgw/ceph-radosgw.$HOSTNAME/keyring
# Creating RGW Pools
./create-pool.sh -pn=.rgw.root -per=0.05 -f=$folder &
wait
./create-pool.sh -pn=default.rgw.control -per=0.02 -f=$folder &
wait
./create-pool.sh -pn=default.rgw.meta -per=0.02 -f=$folder &
wait
./create-pool.sh -pn=default.rgw.log  -per=0.02 -f=$folder &
wait
./create-pool.sh -pn=default.rgw.buckets.index -per=0.05 -f=$folder &
wait
./create-pool.sh -pn=default.rgw.buckets.data -per=0.84 -f=$folder &
wait
# Start rados gateway
sudo systemctl start ceph-radosgw@radosgw.$HOSTNAME
