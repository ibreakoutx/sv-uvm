#!/bin/csh -f
ralgen -l sv -t DUT -a -b dut.ralf
vcs -sverilog -ntb_opts rvm  +define+VMM_RAL_DATA_WIDTH=256 +define+TOP_TOP_PATH=top ${VCS_HOME}/etc/rvm/vmm_ral.sv top.sv dut.v dut_if.sv test.sv 

