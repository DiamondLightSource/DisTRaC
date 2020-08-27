#!/usr/bin/env bash
echo "Start"
cd ../distrac/
time ./distrac.sh -i=ib0 -s=10G -n=6 -pn=example 
# USER JOB
ceph -s 
# END OF USER JOB
time ./remove-distrac.sh
cd ../examples
echo "Done"
