#!/bin/csh -f
vcs -sverilog -l comp.log +verilog1995ext+.v -ntb_opts rvm  +warn=noBCNACMBP test.sv
