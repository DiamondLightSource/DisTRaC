#!/usr/bin/env bash
# On each host this is run
type=gram
for i in "$@"
do
case $i in
    -t=*|--type=*)
    type="${i#*=}"
    shift
	;;
    *)
          # unknown option
    ;;
esac
done

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

if [ $type == gram ] 
    then 
    ./remove-gram.sh
elif [ $type == ram ]
    then
    ./remove-brd.sh 
elif [ $type == zram ]
    then
    ./remove-zram.sh
fi