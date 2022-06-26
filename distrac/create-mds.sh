#!/usr/bin/env bash
folder="."
for i in "$@"
do
case $i in
    -f=*|--folder=*)
    folder="${i#*=}"
    mkdir $folder 2> /dev/null
    shift # past argument=value
    ;;
    *)
          # unknown option
    ;;
esac
done
sudo mkdir /var/lib/ceph/mds/ceph-$HOSTNAME
ceph auth get-or-create mds.$HOSTNAME osd "allow rwx" mds "allow" mon "allow profile mds" > $folder/ceph.mds.keyring
chmod 644 $folder/ceph.mds.keyring
sudo cp $folder/ceph.mds.keyring /var/lib/ceph/mds/ceph-$HOSTNAME/keyring
sudo chown -R ceph:ceph  /var/lib/ceph/mds/ceph-$HOSTNAME/
sudo systemctl start ceph-mds@$HOSTNAME
create-pool.sh -pn=cephfs_data -per=0.90 -f=$folder &
wait
create-pool.sh -pn=cephfs_metadata -per=0.10 -f=$folder &
wait 
ceph fs new cephfs cephfs_metadata cephfs_data &
wait 
state=0
while  [ $state -le 0 ]
do
       state=$(ceph fs status | grep -c "active")
done
