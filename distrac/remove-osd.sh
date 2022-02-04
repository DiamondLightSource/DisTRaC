#!/usr/bin/env bash
# On each host this is run
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
    sudo vgremove $remove -y &
	wait 
done
wait
while read Line1 filelocation  rest;
	do
		  sudo umount $filelocation &
		  wait
done  < <(cat /proc/mounts | grep "ceph/osd")

sudo systemctl reset-failed 
sudo find "/var/lib/ceph/osd/" -mindepth 1 -delete

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