#!/bin/csh -f

vcs -sverilog -timescale=1ns/1ns -ntb_opts uvm +incdir+../sv xbus_tb_top.sv -l comp.log
