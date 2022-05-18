#!/usr/bin/env bash

filesystem=""
for i in "$@"
do
case $i in
    -fs=*|--filesystem=*)
    filesystem="${i#*=}"
    mkdir $filesystem 2> /dev/null
    shift # past argument=value
    ;;
    *)
          # unknown option
    ;;
esac
done

sudo mount -t ceph :/ $filesystem -o name=admin,secret=`ceph auth print-key client.admin`
sudo chown $USER:$USER $filesystem
sudo chmod 777 $filesystem
