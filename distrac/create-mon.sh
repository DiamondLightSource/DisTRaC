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
    -i=*|--interface=*)
    interface="${i#*=}"
    shift # past argument=value
    ;;
    *)
          # unknown option
    ;;
esac
done

fsid=$(uuidgen)
# Gets ipaddr from the interface
ipaddr=$(ip addr show $interface | grep -Po 'inet \K[\d.]+') 
# Gets the ip and netmask from ip address
ipnetmask=$(ip route | grep $ipaddr | grep -v -e "default" | grep "/" |awk '{print $1;}')
#This creates a ceph config,
#that sets the default pool size to 1,

echo "[global]
fsid = $fsid
mon initial members = $HOSTNAME
mon host = $ipaddr
public network = $ipnetmask
cluster network = $ipnetmask
ms bind msgr2 = true
auth cluster required = cephx
auth service required = cephx
auth client required = cephx
osd pool default size = 1
mon pg warn min per osd = 30
mon pg warn max per osd = 166496
mon max pg per osd = 166496
osd pool default pg autoscale mode = off
" > $folder/ceph.conf
cat log.conf >> ceph.conf
# Copy ceph.conf to system
sudo cp $folder/ceph.conf /etc/ceph/
# Create Keyrings
ceph-authtool --create-keyring $folder/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *'
ceph-authtool --create-keyring $folder/ceph.client.admin.keyring --gen-key -n client.admin --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow *' --cap mgr 'allow *'
ceph-authtool --create-keyring $folder/ceph.bootstrap-osd.keyring  --gen-key -n client.bootstrap-osd --cap mon 'profile bootstrap-osd' --cap mgr 'allow r'
ceph-authtool $folder/ceph.mon.keyring --import-keyring $folder/ceph.client.admin.keyring
ceph-authtool $folder/ceph.mon.keyring --import-keyring $folder/ceph.bootstrap-osd.keyring

# Create monmap 
monmaptool --create --add $HOSTNAME   $ipaddr  --fsid $fsid $folder/ceph.monmap
# Creating mon folder
sudo mkdir /var/lib/ceph/mon/ceph-$HOSTNAME
# Changing permission on keys to allow for copying to system
chmod 644 $folder/ceph.*
# Creating Mon
sudo ceph-mon --cluster ceph --mkfs -i $HOSTNAME --monmap $folder/ceph.monmap --keyring $folder/ceph.mon.keyring
# Setting folder permission to ceph user
sudo chown -R ceph:ceph  /var/lib/ceph/mon/ceph-$HOSTNAME
# Copying admin keyring to system
sudo cp $folder/ceph.client.admin.keyring /etc/ceph/
# Starting Mon daemon
sudo systemctl start ceph-mon@$HOSTNAME
ceph mon enable-msgr2
