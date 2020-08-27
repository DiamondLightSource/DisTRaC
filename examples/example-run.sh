#!/usr/bin/env bash
echo "Start"
cd ../distrac/
time ./distrac.sh -i=ib0 -s=60G -n=1 -pn=example
# USER JOB
ceph -s 
# END OF USER JOB
time ./remove-distrac.sh
cd ../examples
echo "Done"
