#!/bin/csh -f

ralgen -l sv -t DUT dut.ralf
vcs -sverilog -ntb_opts rvm +define+TOP_TOP_PATH=top top.sv dut.v dut_if.sv test.sv 

