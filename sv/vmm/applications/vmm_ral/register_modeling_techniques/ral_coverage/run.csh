#!/bin/csh -f

./simv -l run.log
urg -dir simv.vdb -format both
