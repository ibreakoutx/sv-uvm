#!/bin/csh -f

vcs -sverilog -debug_all -ntb_opts dtm interface.sv top.v test.sv -l comp.log
