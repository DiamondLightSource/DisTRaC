#!/usr/bin/env bash
# This adds types = ["gram", 100] to /etc/lvm/lvm.conf after the line types = [ "fd", 16]
sudo sed -i '/\s*\#\s*types\s*\=\s*\[\s*\"fd\"\s*\,\s*\d*\s*/a \\t types = [ "gram", 100 ]' /etc/lvm/lvm.conf 
