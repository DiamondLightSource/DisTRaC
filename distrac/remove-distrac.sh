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

module load openmpi/1.4.3
echo "Removing Ceph"
mpirun -H $mpiHosts ./remove-ceph.sh
echo "Removing OSDs"
mpirun -H $mpiHosts ./remove-osd.sh
echo "Removing GRAM"
mpirun -H $mpiHosts ./remove-gram.sh
echo "Removing Temp Files"
./remove-temp-files.sh -f=$folder
echo "Done"
