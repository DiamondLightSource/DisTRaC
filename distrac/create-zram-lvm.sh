#!/usr/bin/env bash
# This adds types = ["zram", 1000] to /etc/lvm/lvm.conf after the line types = [ "fd", 16]
sudo sed -i /\#\\s*types\\s*\=\\s*\\[\\s*\"fd\",\\s*16\\s*]/atypes=\\[\"zram\",1000] /etc/lvm/lvm.conf