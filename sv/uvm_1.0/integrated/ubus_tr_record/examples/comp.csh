#!/bin/csh -f

vcs -lca -sverilog -cpp g++ -cc gcc -timescale=1ns/1ns +define+UVM_TR_RECORD -debug_all -ntb_opts uvm-1.0 +incdir+../sv ubus_tb_top.sv -l comp.log
