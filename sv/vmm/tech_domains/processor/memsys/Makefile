all: clean comp run

clean:
	rm -rf simv* csrc *.log vc_hdrs.h ucli.key *.vpd

comp:
	vcs -sverilog -ntb_opts rvm -debug_all memsys.test_top.sv test.sv -f memsys.f -l comp.log

run:
	simv -l run.log
