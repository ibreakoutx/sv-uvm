all:	clean comp run

clean:
	\rm -rf simv* csrc* comp.log run.log .vcsmx_rebuild urgReport 
comp:
	vcs  -sverilog   test.sv  -l comp.log 

run:
	simv -l run.log
	if [ -d simv.vdb ] ; then \
	(urg -dir simv.vdb -format both ; ) \
	fi


