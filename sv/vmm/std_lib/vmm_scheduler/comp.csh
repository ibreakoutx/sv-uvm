#!/bin/csh -f
vcs -sverilog -ntb_opts rvm test_00.sv top.v mem.v +define+def  -debug_all -l comp.log

