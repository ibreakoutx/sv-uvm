#!/bin/csh -f


simv -l run.log

# generate reports
if ( -e simv.vdb ) then
urg -dir simv.vdb -report text
endif



 
