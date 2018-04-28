#!/bin/csh -f

rm -rf simv* csrc urg* *.hvp *.dump *.h
ralgen -l sv -t DUT dut.ralf -c a -c b -c f
vcs -lca -sverilog -ntb_opts rvm +define+DUT_TOP_PATH=top ${VCS_HOME}/etc/rvm/vmm_ral.sv top.sv dut.v dut_block.v dut_if.sv test.sv 
