#!/bin/csh -f

vcs -sverilog -timescale=1ns/1ns -ntb_opts uvm +incdir+. simple.sv -l comp.log
