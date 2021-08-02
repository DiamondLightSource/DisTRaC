#!/usr/bin/env bash
# Remove BRD block device

# Get amount of ram's 
amount=` find /dev/ -name "ram*" | wc -l`
# Remove PV's
sudo pvremove /dev/ram[0-$((amount-1))] &
wait
# Unload brd
sudo rmmod brd
