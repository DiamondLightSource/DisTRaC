#!/usr/bin/env bash
# Remove ZRAM block device

# Unload zram
sudo rmmod zram  
remove-zram-lvm.sh