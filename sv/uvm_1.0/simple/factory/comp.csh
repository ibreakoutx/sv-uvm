#!/bin/csh -f

vcs -sverilog -cpp g++ -cc gcc -timescale=1ns/1ns +incdir+. packet_pkg.sv gen_pkg.sv env_pkg.sv test.sv -ntb_opts uvm-1.0 -l comp.log
