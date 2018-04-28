CMP_OPTS = -sverilog -debug_all

NTB_OPTS = -ntb_opts rvm

GEN_FILE = ../atm_cell.sv

all: clean comp run
	
comp:
	vcs $(CMP_OPTS) $(NTB_OPTS) $(GEN_FILE) test_scenario_gen.sv -l comp.log

run:
	./simv -l run.log

clean:
	rm -rf simv simv.* vc_hdrs.h csrc* *.log ucli.key
