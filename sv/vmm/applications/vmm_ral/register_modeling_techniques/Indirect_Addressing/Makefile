# VERSION INFORMATION: 
# Must use VCS 2006.06-SP1-18 or later

default: user_test

APB	= 
TESTS	= $(VCS_HOME)/etc/rvm/sv/RAL/tests

VCS	= vcs -R +plusarg_save -sverilog -ntb_opts rvm \
              +incdir+$(APB) +vmm_log_default=normal \
              +define+SLAVE_TOP_PATH=tb_top.dut tb_top.sv \

all: clean default

ralgen: slave.ralf
	ralgen -b -l sv -t slave slave.ralf

user_test: ralgen
	$(VCS) user_test.sv 


# RAL functional coverage:
ralgen_cov: slave.ralf
	ralgen -c b -b -l sv -t slave slave.ralf

user_test_cov: ralgen_cov
	$(VCS) user_test.sv  +define+RAL_COVERAGE
	urg -dir simv.vdb

# Cleanup
clean:
	rm -rf simv* csrc urgReport vc_hdrs.h *.log *.hvp ral_slave.sv ucli.key

clean_all:
	rm -rf ral_slave.sv csrc simv* urgReport .vcsmx_rebuild vc_hdrs.h *~ apb/*~ 
