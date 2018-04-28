all: clean comp run

comp:
	vcs -sverilog -debug_all interface.sv top.v test.sv -l comp.log

run:
	simv -l log -l run.log

clean:
	rm -rf simv csrc *.swp simv.daidir *.log ucli.key vc_hdrs.h inter.vpd DVEfiles
