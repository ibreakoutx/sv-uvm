#!/bin/csh -f

vcs -sverilog -cpp g++ -cc gcc -timescale=1ns/1ns +incdir+. -ntb_opts uvm-1.0 component.sv  -l comp.log
