#!/bin/csh -f


vcs -sverilog -ntb_opts rvm  dut.v test.sv dut_test_top.v +incdir+$VCS_HOME/packages/sva -y $VCS_HOME/packages/sva +libext+.sv +incdir+./ +define+ASSERT_ON +define+SVA_VMM_LOG_ON -l comp_unq.log
