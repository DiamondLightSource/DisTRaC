#!/usr/bin/env bash
echo "Start"
hosts=$PWD/example-hosts
cd ../distrac/
time ./distrac.sh -i=ib0 -s=60G -n=1 -pn=example -hf=$hosts
# USER JOB
ceph -s 
# END OF USER JOB
time ./remove-distrac.sh -hf=$hosts
cd ../examples
echo "Done"
