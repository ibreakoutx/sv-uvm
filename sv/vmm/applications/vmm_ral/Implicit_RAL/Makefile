
all: clean comp run

clean:
	rm -rf simv* csrc core *.log urg* vc* ucli*

comp: dut.ralf top.sv dut.v dut_if.sv test.sv
	ralgen -l sv -t DUT dut.ralf
	vcs -sverilog -ntb_opts rvm  +define+TOP_TOP_PATH=top top.sv dut.v dut_if.sv test.sv 

run: 
	simv -l run.log
