#!/bin/csh -f
ralgen -uvm -t slave slave.ralf
vcs -cpp g++ -cc gcc -sverilog +define+RALGEN -timescale=1ns/1ns -ntb_opts uvm-1.0 +incdir+../common/apb tb_top.sv test.sv -l comp.log
