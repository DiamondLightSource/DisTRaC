#!/usr/bin/env bash
echo "Start"
cd ../distrac/
time ./distrac.sh -i=ib0 -s=60G -n=1 -t=gram -pn=example -f=test
# USER JOB
ceph -s 
# END OF USER JOB
time ./remove-distrac.sh -f=test -t=gram
cd ../examples
echo "Done"
