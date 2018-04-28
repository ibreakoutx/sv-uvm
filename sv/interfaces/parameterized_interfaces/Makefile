all: clean comp run

comp:
	vcs -sverilog -debug_all interface.sv test.sv top.v -l comp.log

run:
	simv -l run.log

clean:
	rm -rf simv simv.daidir csrc *.log *.swp vc_hdrs.h DVEfiles inter.vpd ucli.key
