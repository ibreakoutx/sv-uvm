#!/bin/csh -f

vcs -sverilog -timescale=1ns/1ns +incdir+. test.sv -ntb_opts uvm -l comp.log
