#!/bin/csh -f
ralgen -uvm -t S sys.ralf
vcs -cpp g++ -cc gcc -sverilog -ntb_opts uvm-1.0 -timescale=1ns/1ns +incdir+../common/apb  -debug sys_run.sv -l sys_comp.log
