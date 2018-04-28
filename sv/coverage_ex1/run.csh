#!/bin/csh -f


simv -l run.log 

if ( -e simv.vdb ) then
urg -dir simv.vdb -report text
endif
