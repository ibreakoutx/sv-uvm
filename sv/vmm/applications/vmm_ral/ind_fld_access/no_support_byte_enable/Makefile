
all: clean comp run

clean:
	rm -rf simv* csrc *.log urg* vc* ucli* ral_DUT.sv

comp: dut.ralf top.sv dut.v dut_if.sv test.sv
	ralgen -l sv -t DUT -b dut.ralf
	vcs -sverilog -ntb_opts rvm  +define+VMM_RAL_DATA_WIDTH=128 +define+TOP_TOP_PATH=top ${VCS_HOME}/etc/rvm/vmm_ral.sv top.sv dut.v dut_if.sv test.sv 

run: 
	simv -l run.log
