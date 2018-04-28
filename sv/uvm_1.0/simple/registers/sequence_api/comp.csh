#!/bin/csh -f
ralgen -uvm -t B blk.ralf
vcs -cpp g++ -cc gcc -sverilog -timescale=1ns/1ns -ntb_opts uvm-1.0 +incdir+../common/apb blk_run.sv -debug  -l comp.log +define+RALGEN
#take off +define+RALGEN from above command line to compile the shipped register model
