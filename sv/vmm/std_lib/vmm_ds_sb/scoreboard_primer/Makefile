
all: clean simple

simple test_simple:
	vcs -R +plusarg_save -sverilog \
             -ntb_opts rvm +vmm_log_default=trace \
	    test_simple.sv tb_top.sv

clean:
	rm -rf csrc simv* vc_hdrs.h  *.log ucli.key
