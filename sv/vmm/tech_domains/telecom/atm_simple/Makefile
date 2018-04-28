all: clean comp run

clean:
	rm -rf simv* csrc *.log vc_hdrs.h ucli.key

comp: atm.sv atm_cover.sv atm_cell.sv
	vcs -sverilog -ntb_opts rvm $(VCSFLAGS) atm.sv -l comp.log

run:
	simv +ntb_random_seed_automatic -l run.log
