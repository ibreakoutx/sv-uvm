all: clean comp run  aspect_comp aspect_run


comp:
	vcs -l comp.log -sverilog test.sv

run:
	simv  -l run.log

aspect_comp:
	vcs -l aspct_comp.log -sverilog test.sv aspect.sv

aspect_run:
	simv  -l aspect_run.log



clean:
	\rm -rf *.tcl simv* csrc *.vro ucli.key vcdplus.vpd urgReport *.log .vcsmx_rebuild
