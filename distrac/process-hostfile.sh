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
# Read hostfile and put the amount of hosts in amountOfHosts.num
echo `awk -F '[,]' ' {print NF}' $hostfile` > $folder/amountOfHosts.num
# Convert the hostfile to a column of hosts and store in $folder/hostlist
tr , '\n' <  $hostfile >  $folder/hostfile
