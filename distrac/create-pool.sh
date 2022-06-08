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
    mkdir $folder 2> /dev/null
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
currentPGs=$(ceph pg stat 2> /dev/null | awk '{print $1}')
if [ "$currentPGs" -eq "0" ];
then
    currentPGs=1
fi 

source calculate-pool-pg.sh
# Works out the PGs need for pool
CalculatePoolPG $percentage $amountOfHosts $amountOfOSDs
# Creates a pool with the name passed and amout of PGs
ceph osd pool create $poolname $result
echo "Creating PG's"
# Update the expected PGs active and clean to current plus new
result=$(expr $result + $currentPGs)
resultMinus1=$(expr $result - 1)
resultPlus1=$(expr $result + 1) 
# Check if all pgs are active and clean
pgstat=$(ceph pg stat 2> /dev/null | grep -c "$result active+clean")
while  [ $pgstat -le 0 ]
do
    echo "hi"
	pgstat=$(ceph pg stat 2> /dev/null | grep -c "$result active+clean")
    echo "bye"
    pgstat=$(ceph pg stat 2> /dev/null | grep -c "$resultPlus1 active+clean")
    echo "no"
done
