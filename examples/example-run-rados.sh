#!/usr/bin/env bash
echo "Start"
cd ../distrac/
time ./distrac.sh -i=ib0 -s=90G -n=1 -pn=example 
# USER JOB
cd ../examples
rados bench -p example  20  write  --no-cleanup > radosWrite.log
rados bench -p example 20 rand > radosRand.log
# END OF USER JOB
cd ../distrac/
time ./remove-distrac.sh
cd ../examples
echo "Done"
