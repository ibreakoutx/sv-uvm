#!/bin/csh -f
vcs +plusarg_save -sverilog -ntb_opts rvm +vmm_log_default=trace test_simple.sv tb_top.sv -l comp.log 
