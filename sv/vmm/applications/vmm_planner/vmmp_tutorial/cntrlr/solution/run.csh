#!/bin/csh -f

\rm -rf simv csrc simv* comp.log sim.log


vcs -sverilog cntrlr.test_top.v ../rtl/cntrlr.v cntrlr_test.v  -debug


./simv  -l run.log

