#!/bin/csh -f
vcs +plusarg_save -sverilog -ntb_opts rvm +incdir+../apb +vmm_log_default=normal +define+SLAVE_TOP_PATH=tb_top.dut tb_top.sv  user_test.sv -l comp.log
