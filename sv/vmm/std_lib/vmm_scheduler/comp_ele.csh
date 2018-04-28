#!/bin/csh -f

vcs -sverilog -debug_all -ntb_opts rvm   test_00.sv top.v  mem.v  +define+def +define+elect
./simv 
