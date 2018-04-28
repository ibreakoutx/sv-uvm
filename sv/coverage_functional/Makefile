all:	clean comp run

clean:
	\rm -rf simv* csrc* *.log urgReport  text
comp:
	vcs  -sverilog   test.sv  -l comp.log 

run:
	simv -l run.log
	if [ -d simv.vdb ] ; then \
	(urg -dir simv.vdb -report text ; ) \
	fi


