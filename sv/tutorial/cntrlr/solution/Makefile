all: clean comp run

clean:
	\rm -rf csrc simv* *.log 

comp:
	vcs -sverilog cntrlr.test_top.v ../rtl/cntrlr.v cntrlr_test.v  -debug -l comp.log

run:
	simv -l run.log

