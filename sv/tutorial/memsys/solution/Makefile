all: clean memsys0 memsys1  

clean:
	\rm -rf simv csrc simv* *.log urgReport/ text


memsys0:	memsys0_comp memsys0_run 

memsys1:	memsys1_comp memsys1_run 

memsys0_comp:
	vcs -sverilog -f memsys.f memsys.test_top.v  memsys0.v  -l memsys0_comp.log
memsys0_run:
	simv -l memsys0_run.log
	urg -dir simv.vdb -report text

memsys1_comp:
	vcs -sverilog -f memsys.f memsys.test_top.v  memsys1.v  -l memsys1_comp.log
memsys1_run:
	simv -l memsys1_run.log
	urg -dir simv.vdb -report text

