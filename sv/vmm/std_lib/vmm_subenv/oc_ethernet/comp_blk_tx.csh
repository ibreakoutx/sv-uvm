#!/bin/csh -f
ralgen -l sv -t oc_ethernet oc_ethernet.ralf
vcs +plusarg_save -sverilog -ntb_opts rvm  +verilog1995ext+.v  +warn=noBCNACMBP +incdir+ethernet+wishbone+rtl +define+SOLVER_WEIRDNESS -F rtl//rtl_file_list.lst blk_trivial_test.sv -l comp_blk_tx.log
