#!/bin/csh -f

vcs -sverilog -timescale=1ns/1ns +incdir+. -ntb_opts uvm interface.sv  -l comp.log
