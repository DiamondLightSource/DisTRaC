#!/usr/bin/env bash
# Remove GRAM
sudo rmmod gram  
rm /tmp/gram.ko
remove-gram-lvm.sh
