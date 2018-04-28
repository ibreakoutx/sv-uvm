#!/bin/csh -f

vcs -cpp g++ -cc gcc -sverilog -cpp g++ -cc gcc -timescale=1ns/1ns -debug_all +define+UVM_TR_RECORD -ntb_opts uvm-1.0 +incdir+../sv xbus_tb_top.sv -l comp.log -lca
