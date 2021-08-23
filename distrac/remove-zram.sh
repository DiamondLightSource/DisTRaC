#!/usr/bin/env bash
# Remove ZRAM block device

# Get amount of zram's 
amount=` find /dev/ -name "zram*" | wc -l`
# Remove PV's
sudo pvremove /dev/zram[0-$((amount-1))] &
wait
# Unload zram
sudo rmmod zram  
./remove-zram-lvm.sh