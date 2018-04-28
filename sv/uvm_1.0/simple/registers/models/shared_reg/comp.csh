#!/bin/csh -f
ralgen -uvm -t B shared.ralf
vcs -cpp g++ -cc gcc -sverilog -timescale=1ns/1ns +incdir+../../common -ntb_opts uvm-1.0 blk_run.sv -l comp.log +define+RALGEN
