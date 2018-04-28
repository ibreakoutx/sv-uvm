#!/bin/csh -f

vcs -sverilog -cpp g++ -cc gcc -timescale=1ns/1ns -ntb_opts uvm-1.0 +incdir+. bidir.sv -l comp.log
