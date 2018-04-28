
all:clean comp run

clean:

	\rm -rf csrc simv* *.key  vc_hdrs.h  ral_mysys.h ral_mysys.sv *.log

comp:	
	ralgen -l sv -gen_c -t mysys test.ralf

	vcs -sverilog -ntb_opts rvm +warn=noBCNACMBP +define+VMM_RAL_DATA_WIDTH=96+DEBUG=1 -cflags -g -debug_all test.sv test.c 

run:
	simv 
