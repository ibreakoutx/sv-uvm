#!/bin/csh -f

vcs -sverilog -timescale=1ns/1ns +incdir+. -ntb_opts uvm ports_and_exports.sv  -l comp.log
