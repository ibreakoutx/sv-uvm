#!/bin/csh -f

vcs -sverilog -ntb_opts rvm -debug_all memsys.test_top.sv test.sv -f memsys.f -l comp.log

