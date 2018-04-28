#!/bin/csh -f
ralgen -l sv -t dual_eth dual_eth.ralf
vcs +plusarg_save -sverilog -ntb_opts rvm +verilog1995ext+.v  +warn=noBCNACMBP +incdir+ethernet+wishbone+rtl +define+SOLVER_WEIRDNESS -F rtl//rtl_file_list.lst dual_eth.v sys_trivial_test.sv -l comp_sys_tx.log
