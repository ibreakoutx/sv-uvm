#!/bin/csh -f

\rm -rf simv csrc simv* comp.log sim.log

vcs -sverilog arb.test_top.v ../rtl/arb.v arb_test.v -debug

./simv -l sim.log

