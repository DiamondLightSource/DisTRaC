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
# Read UGE PE_HOSTFILE and extract hosts
awk '{print $1 }' ${PE_HOSTFILE} | uniq > $folder/hostfile
cat $folder/hostfile | wc -l > $folder/amountOfHosts.num
