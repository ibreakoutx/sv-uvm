#!/bin/csh -f
vcs +plusarg_save -sverilog  -ntb_opts rvm +define+RANDOM_RESPONSE test_simple.sv tb_top.sv -l comp_random.log
