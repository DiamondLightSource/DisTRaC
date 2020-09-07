#!/usr/bin/env bash
source ./helpmsg.sh
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
	-h| --help)
	helpmsgremove
	exit 0 
	shift
	;;
    *)
	helpmsgremove
	exit 0
    ;;
esac
done

if [ ! -z "$hostfile" ]
then
    source ./process-hostfile.sh -f=$folder -hf=$hostfile
else
    source ./uge-hostfile.sh -f=$folder
fi

module load openmpi
amountOfHosts=`cat $folder/amountOfHosts.num`
echo "Removing Ceph"
mpirun -np $amountOfHosts --map-by ppr:1:node --hostfile $folder/hostfile ./remove-ceph.sh
echo "Removing OSDs"
mpirun -np $amountOfHosts --map-by ppr:1:node --hostfile $folder/hostfile ./remove-osd.sh
echo "Removing GRAM"
mpirun -np $amountOfHosts --map-by ppr:1:node --hostfile $folder/hostfile ./remove-gram.sh
echo "Removing Temp Files"
./remove-temp-files.sh -f=$folder
echo "Done"
