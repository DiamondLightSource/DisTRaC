#!/usr/bin/env bash
# Find types = [ "gram", 100 ]  in /etc/lvm/lvm.conf and remove it
sudo sed  -i /types=\\[\"zram\",1000]/d /etc/lvm/lvm.conf
