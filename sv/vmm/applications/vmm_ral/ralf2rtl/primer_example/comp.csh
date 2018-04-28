#!/bin/csh -f

##### Generate RTL #####
ralgen  -t slave -R rtl slave.ralf

##### Generate RAL Model #####
ralgen  -t slave -b -l sv slave.ralf

##### Compile generated RTL,RAL model & user testcase #####
vcs  -sverilog -o "simv1" -ntb_opts rvm +incdir+primer_example+apb+user_RTL+$VCS_HOME/etc/rvm/sv/RAL/RTL+rtl +define+SLAVE_TOP_PATH=tb_top.dut tb_top.sv user_test.sv 


##### Compile generated RTL,RAL model & RAL built-in testcase #####
vcs  -sverilog -o "simv2" -ntb_opts rvm +incdir+primer_example+apb+user_RTL+$VCS_HOME/etc/rvm/sv/RAL/RTL+rtl +define+SLAVE_TOP_PATH=tb_top.dut tb_top.sv $VCS_HOME/etc/vmm/sv/RAL/tests/reg_access.sv


