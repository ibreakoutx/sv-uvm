#!/bin/csh -f

vcs +define+VMM_HW_ARCH_NULL -l comp.log test.sv -sverilog -ntb_opts rvm +incdir+. tb_env.sv
