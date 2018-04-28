
all : clean comp run

clean:
	\rm -rf simv csrc simv* comp.log sim.log ucli.key

comp:
	vcs -sverilog arb.test_top.v ../rtl/arb.v arb_test.v -debug

run:
	simv -l sim.log
