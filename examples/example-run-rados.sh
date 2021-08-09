#!/usr/bin/env bash
echo "Start"
cd ../distrac/
time ./distrac.sh -i=ib0 -s=90G -n=1 -t=gram -pn=example 
# USER JOB
cd ../examples
rados bench -p example  20  write  --no-cleanup > radosWrite.log
rados bench -p example 20 rand > radosRand.log
# END OF USER JOB
cd ../distrac/
time ./remove-distrac.sh -t=gram
cd ../examples
echo "Done"
