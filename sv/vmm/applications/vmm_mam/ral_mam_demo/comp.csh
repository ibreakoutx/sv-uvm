#!/bin/csh -f

vcs +plusarg_save -sverilog -ntb_opts rvm +incdir+./ +vmm_log_default=normal -l comp.log  ./user_test.sv
