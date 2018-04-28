#!/bin/csh -f

vcs -sverilog -timescale=1ns/1ns -ntb_opts uvm +incdir+. hello_world.sv -l comp.log
