#!/usr/bin/env bash
folder="."
for i in "$@"
do
case $i in
    -pn=*|--poolname=*)
    poolname="${i#*=}"
    shift # past argument=value
    ;;
	-per=*|--percentage=*)
    percentage="${i#*=}"
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


amountOfHosts=`cat $folder/amountOfHosts.num`
amountOfOSDs=`cat $folder/amountOfOSDs.num`


# Gets current PGS in ceph
currentPGs=$(ceph pg stat | awk '{print $1}')
source ./calculate-pool-pg.sh
# Works out the PGs need for pool
CalculatePoolPG $percentage $amountOfHosts $amountOfOSDs
# Creates a pool with the name passed and amout of PGs
ceph osd pool create $poolname $result &
wait
# Update the expected PGs active and clean to current plus new
result=$(expr $result + $currentPGs)
# Check if all pgs are active and clean
pgstat=$(ceph pg stat | grep -c "$result active+clean")
while  [ $pgstat -le 0 ]
do
	pgstat=$(ceph pg stat | grep -c "$result active+clean")
done
