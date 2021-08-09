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
    *)
          # unknown option
    ;;
esac
done
sudo modprobe zram num_devices=$amount &
wait
for num in $(seq 0 $[amount-1])
do
	sudo echo $size | sudo tee /sys/block/zram$num/disksize &
	wait
done
sudo pvcreate /dev/zram[0-$((amount-1))] &
wait

