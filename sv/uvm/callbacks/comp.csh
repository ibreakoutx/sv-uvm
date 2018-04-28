#!/bin/csh -f

vcs -sverilog -timescale=1ns/1ns -ntb_opts uvm +incdir+. top.sv -l comp.log
