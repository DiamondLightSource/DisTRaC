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
	-hf=*|--hostfile=*)
    hostfile="${i#*=}"
    shift # past argument=value
    ;;
    *)
          # unknown option
    ;;
esac
done
# Convert the hostfile to a column of hosts and store in $folder/hostlist
tr , '\n' <  $hostfile >  $folder/hostfile
# Make sure the first host in hostfile is the headnode
sed -i "/\b\("$HOSTNAME"\)\b/d" $folder/hostfile
echo  "$(printf "$HOSTNAME \n"; cat $folder/hostfile)" > $folder/hostfile
# Read hostfile and put the amount of hosts in amountOfHosts.num
cat $folder/hostfile | wc -l > $folder/amountOfHosts.num
