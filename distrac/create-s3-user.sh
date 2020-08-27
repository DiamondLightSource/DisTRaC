#!/usr/bin/env bash

for i in "$@"
do
case $i in
    -uid=*|--uid=*)
    ID="${i#*=}"
    shift # past argument=value
    ;;
    -sk=*|--secretkey=*)
    SECRET="${i#*=}"
    shift # past argument=value
    ;;

    *)
          # unknown option
    ;;
esac
done
# Create a user with ID passed by user
radosgw-admin user create --uid=$ID --display-name=$ID
# Create a secret key and access key with $SECRET passed by user
radosgw-admin key create --uid=$ID --key-type=s3 --secret=$SECRET --access-key=$SECRET

