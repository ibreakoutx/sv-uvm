#!/bin/csh -f

vcs -sverilog -debug_all interface.sv test.sv top.v -l comp.log
