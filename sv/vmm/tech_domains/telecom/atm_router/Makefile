all: comp run

comp:
	vcs -ntb_opts rvm -sverilog -f files -debug_pp -timescale="1ns/1ps"

clean:
	rm -rf vcdplus.vpd  simv* csrc vc_hdrs.h *.log ucli.key

run:
	./simv
record:
	./simv +vmm_log_default=NORMAL -l bad_log +vmm_opts+record=1

