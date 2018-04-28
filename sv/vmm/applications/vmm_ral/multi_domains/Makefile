
NTB_OPTS= -ntb_opts rvm
TEST_HOME= ./

OPTS = 

#MODEL = domains
#MODEL = simple
#MODEL = array
MODEL = domains

DUT = $(TEST_HOME)/dropbox.sv $(TEST_HOME)/dropsys.sv 
TB = $(TEST_HOME)

all: clean tests

tests: hw_reset \
	bit_bash

%: ral_dropsys.sv $(VCS_HOME)/etc/vmm/sv/RAL/tests/%.sv
	vcs -sverilog +verilog1995ext+.v \
		$(OPTS) -R -ntb $(NTB_OPTS) \
		$(VCS_HOME)/etc/vmm/sv/RAL/tests/$*.sv $(TB)/tb_top.sv $(DUT) +incdir+$(TB)

user_test: ral_dropsys.sv user_test.sv
	vcs -sverilog +verilog1995ext+.v \
		$(OPTS) -R -ntb $(NTB_OPTS) \
		user_test.sv $(TB)/tb_top.sv $(DUT) +incdir+$(TB) 

user_test1: ral_dropsys.sv user_test1.sv
	vcs -sverilog +verilog1995ext+.v \
		$(OPTS) -R -ntb $(NTB_OPTS) \
		user_test1.sv $(TB)/tb_top.sv $(DUT) +incdir+$(TB)
ral_dropsys.sv: drop_$(MODEL).ralf
	ralgen -l sv -t dropsys drop_$(MODEL).ralf

clean:
	rm -rf ral_slave.sv csrc *.log simv* vc_hdrs.h  ucli.key
