
all : clean comp run

clean:
	\rm -rf simv csrc simv* comp.log sim.log ucli.key

comp:
	vcs -sverilog cntrlr.test_top.v ../rtl/cntrlr.v cntrlr_test.v  -debug

run:
	simv
