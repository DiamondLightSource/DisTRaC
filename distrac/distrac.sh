#!/usr/bin/env bash
rgw=false
folder="."
source ./helpmsg.sh

if [ -z "$@" ] 
then 
	helpmsg
	exit 0 
fi

for i in "$@"
do
case $i in
    -f=*|--folder=*)
    folder="${i#*=}"
    mkdir $folder
    shift # past argument=value
    ;;
    -i=*|--interface=*)
    interface="${i#*=}"
    shift # past argument=value
    ;;
    -t=*|--type=*)
    type="${i#*=}"
    shift
    ;;
    -s=*|--size=*)
    size="${i#*=}"
    shift # past argument=value
    ;;
    -n=*|--number=*)
    amount="${i#*=}"
    shift # past argument=value
    ;;
    -pn=*|--poolname=*)
    poolname="${i#*=}"
    shift # past argument=value
    ;;
    -rgw|--rgw)
    rgw=true
    shift
    ;;
    -uid=*|--uid=*)
    id="${i#*=}"
    shift # past argument=value
    ;;
    -sk=*|--secretkey=*)
    secret="${i#*=}"
    shift # past argument=value
    ;;
    -hf=*|--hostfile=*)
    hostfile="${i#*=}"
    shift # past argument=value
    ;;
    -h| --help)
    helpmsg
    exit 0 
    shift
    ;;
    *) 
    helpmsg
    exit 0
    ;;
esac
done
echo $amount> $folder/amountOfOSDs.num
if [ ! -z "$hostfile" ]
then
	source ./process-hostfile.sh -f=$folder -hf=$hostfile
else
	source ./uge-hostfile.sh -f=$folder
fi

./create-mon.sh -i=$interface -f=$folder
./create-mgr.sh -f=$folder
echo HOSTS:
cat $folder/hostfile
module load openmpi
amountOfHosts=`cat $folder/amountOfHosts.num`
mpirun -np $amountOfHosts --map-by ppr:1:node --hostfile $folder/hostfile  ./create-osd.sh -s=$size -n=$amount -f=$folder -t=$type
if ([ ! -z "$poolname" ] && [ "$rgw" = "false" ])
then
   ./create-pool.sh -pn=$poolname -per=1 -f=$folder
fi

module unload openmpi

if ([ "$rgw" = "true" ] && [ -z "$poolname" ])
	 then
	./create-rgw.sh -f=$folder
	if ([ -z "$id" ] && [ -z "$secret" ])
	then
		echo "No user will be create"
	else
		./create-s3-user.sh --uid=$id -sk=$secret
	fi
fi
