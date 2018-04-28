#!/bin/csh -f
mkdir work
ralgen -b -l sv -t oc_ethernet oc_ethernet.ralf
vcs -sverilog +verilog1995ext+.v -extinclude +warn=noBCNACMBP  timescale.v $VCS_HOME/etc/vmm/sv/RAL/tests/bit_bash.sv tb_top.sv -ntb_opts rvm +incdir+./wishbone+./ethernet -F ./oc_ethernet/rtl_file_list.lst +incdir+./oc_ethernet \
               +define+OC_ETHERNET_TOP_PATH=tb_top.dut \
               +define+VMM_RAL_TEST_PRE_INCLUDE=ral_env.svh \
               +define+VMM_RAL_TEST_POST_INCLUDE=ral_pgm.svh \
               +define+SINGLE_RAM_VARIABLE
