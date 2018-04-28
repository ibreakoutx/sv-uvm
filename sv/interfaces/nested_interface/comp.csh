#!/bin/csh -f

vcs -sverilog -debug_all interface.sv top.v test.sv -l comp.log
