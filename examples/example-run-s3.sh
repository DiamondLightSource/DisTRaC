#!/usr/bin/env bash
echo "Start"
cd ../distrac
# USER JOB
time ./distrac.sh -i=ib0 -s=100G -n=1 -t=gram -rgw  -uid=admin -sk=admin
# USER JOB
ceph -s
# END OF USER JOB
time ./remove-distrac.sh -t=gram
cd ../examples
echo "Done"
