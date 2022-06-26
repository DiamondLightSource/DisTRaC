#!/usr/bin/env bash
folder="."
for i in "$@"
do
case $i in
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
rm $folder/ceph.*
rm $folder/hostfile 
rm $folder/*.num
rmdir $folder
