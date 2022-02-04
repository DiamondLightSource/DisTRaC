#!/usr/bin/env bash
# This adds types = ["gram", 100] to /etc/lvm/lvm.conf after the line types = [ "fd", 16]
sudo sed -i /\#\\s*types\\s*\=\\s*\\[\\s*\"fd\",\\s*16\\s*]/atypes=\\[\"gram\",1000] /etc/lvm/lvm.conf
