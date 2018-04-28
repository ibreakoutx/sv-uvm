#!/bin/csh -f

vcs -sverilog -debug_all top.v interface.sv test.sv -l comp.log 
