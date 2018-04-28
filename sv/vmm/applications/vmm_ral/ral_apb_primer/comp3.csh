#!/bin/csh -f

ralgen -c b -b -l sv -t slave slave.ralf
vcs +plusarg_save -sverilog -ntb_opts rvm +incdir+./apb_src +vmm_log_default=normal \
+define+SLAVE_TOP_PATH=tb_top.dut tb_top.sv ${VCS_HOME}/etc/vmm/sv/RAL/tests//mem_access.sv -l comp3.log
