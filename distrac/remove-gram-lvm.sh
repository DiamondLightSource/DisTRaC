#!/usr/bin/env bash
# Find types = [ "gram", 100 ]  in /etc/lvm/lvm.conf and remove it
sudo sed -i '/\s*types\s*\=\s*\[\s*\"gram\"\,\s*\d*\s*/d' /etc/lvm/lvm.conf
