#!/bin/csh -f

ralgen -l sv -gen_c -t mysys test.ralf

vcs -sverilog -ntb_opts rvm +warn=noBCNACMBP +define+VMM_RAL_DATA_WIDTH=96+DEBUG=1 -cflags -g -debug_all test.sv test.c |& tee comp.log
