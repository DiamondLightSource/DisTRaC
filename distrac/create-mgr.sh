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

# Creating a ceph mgr key and keyring
ceph auth get-or-create mgr.$HOSTNAME mon 'allow profile mgr' osd 'allow *' mds 'allow *' > $folder/ceph.mgr.keyring
# Creating mgr folder
sudo mkdir /var/lib/ceph/mgr/ceph-$HOSTNAME
# Changing permisions so it can be copied to system
chmod 644 $folder/ceph.mgr.keyring
# Copying to key to system
sudo cp $folder/ceph.mgr.keyring /var/lib/ceph/mgr/ceph-$HOSTNAME/keyring
# Setting folder permission to ceph user
sudo chown -R ceph:ceph  /var/lib/ceph/mgr/ceph-$HOSTNAME/
# Stating MGR daemon
sudo systemctl start ceph-mgr@$HOSTNAME
# Starting Dashboard
ceph mgr module enable dashboard 
