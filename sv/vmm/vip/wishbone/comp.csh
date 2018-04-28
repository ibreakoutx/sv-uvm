#!/bin/csh -f
vcs -sverilog +verilog1995ext+.v -ntb_opts rvm +warn=noBCNACMBP   test.sv 
