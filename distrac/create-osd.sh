#!/usr/bin/env bash
size=""
amount=0
folder="."
for i in "$@"
do
case $i in
    -s=*|--size=*)
    size="${i#*=}"
    shift # past argument=value
    ;;
    -n=*|--number=*)
    amount="${i#*=}"
    shift # past argument=value
    ;;
    -f=*|--folder=*)
    folder="${i#*=}"
    mkdir $folder
    shift # past argument=value
    ;;
    -t=*|--type=*)
    type="${i#*=}"
    shift
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

if [ $type == gram ] 
    then 
    create-gram.sh -s=$size -n=$amount -f=$folder
elif [ $type == ram ]
    then
    create-brd.sh -s=$size -n=$amount -f=$folder
elif [ $type == zram ]
    then
    create-zram.sh -s=$size -n=$amount -f=$folder
fi

# Creating OSDs using ceph-volume
for num in $(seq 0 $[amount-1])
do
    sudo ceph-volume lvm create --data /dev/$type$num
done

