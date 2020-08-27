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
while read name rest
	do 
		hosts+=($name)
done < <(cat $PE_HOSTFILE)
# Put the amount of hosts in amountOfHosts.num
echo "${#hosts[@]}"  > $folder/amountOfHosts.num
# Assign a string of hosts with commas to mpiHosts
mpiHosts=$(IFS=,; echo "${hosts[*]}")
