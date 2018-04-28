all: clean comp run

clean:
	rm -rf simv* csrc *.log ucli.key vc_hdrs.h

comp:
	vcs -sverilog -ntb_opts rvm test1.sv -l comp.log

run:
	simv -l run.log
