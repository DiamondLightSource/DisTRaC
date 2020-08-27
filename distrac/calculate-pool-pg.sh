#!/usr/bin/bash

#This function calculates the amount of PGs using the amount
#of host and OSDs and multipling it by the percentage that
#pool will use then loging it to find the nearest power of two
#recommoned by https://ceph.io/pgcalc/
#$1 is the percentage value given by a user range from 0-1.

CalculatePoolPG() { result=$(echo "x=l($1*$2*$3*100)/l(2); scale=0; 2^((x+0.5)/1)" | bc -l); }
