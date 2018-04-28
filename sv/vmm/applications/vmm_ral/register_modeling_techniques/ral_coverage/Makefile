all:  clean ral_DUT.sv comp run urg

clean:
	rm -rf simv* csrc urgReport *.dump *.h *.log ral_DUT.sv *.hvp ucli.key

comp: ral_DUT.sv
	vcs -lca -sverilog -ntb_opts rvm +define+DUT_TOP_PATH=top ${VCS_HOME}/etc/rvm/vmm_ral.sv top.sv dut.v dut_block.v dut_if.sv test.sv -l comp.log


run:
	simv -l run.log

urg:
	urg -dir simv.vdb -format both

ral_DUT.sv:
	ralgen -c a -c b -c f -t DUT -l sv dut.ralf
	
