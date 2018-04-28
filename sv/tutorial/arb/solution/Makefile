all: clean comp run

clean:
	\rm -rf simv csrc simv* comp.log sim.log

comp:
	vcs -sverilog arb.test_top.v ../rtl/arb.v arb_test.v -debug -l comp.log

run:
	simv -l sim.log

