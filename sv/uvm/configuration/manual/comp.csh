#!/bin/csh -f

vcs -sverilog -timescale=1ns/1ns -ntb_opts uvm +incdir+. my_env_pkg.sv top.sv -l comp.log
