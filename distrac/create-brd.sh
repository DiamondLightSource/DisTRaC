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
    mkdir $folder 2> /dev/null
    shift # past argument=value
    ;;
    *)
          # unknown option
    ;;
esac
done
# Load brd ram block module
sudo modprobe brd rd_size=`echo $(( $(numfmt $size --from iec) / 1024 )) ` max_part=1 rd_nr=$amount

