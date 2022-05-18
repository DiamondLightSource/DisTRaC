#!/usr/bin/env bash
# Get amount of Grams 
amount=` find /dev/ -name "gram*" | wc -l`
sudo pvremove /dev/gram[0-$((amount-1))] &
wait
sudo rmmod gram  
rm /tmp/gram.ko
remove-gram-lvm.sh
