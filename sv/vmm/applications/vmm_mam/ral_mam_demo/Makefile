APB	= ./

VCS	= vcs -R +plusarg_save -sverilog -ntb_opts rvm \
              +incdir+$(APB) +vmm_log_default=normal -l log\

all: clean user_test

user_test:
		$(VCS) ./user_test.sv

clean:
	rm -rf log csrc simv* vc_hdrs.h ucli.key *.log
