## 
## -------------------------------------------------------------
##    Copyright 2004-2008 Synopsys, Inc.
##    All Rights Reserved Worldwide
## 
##    Licensed under the Apache License, Version 2.0 (the
##    "License"); you may not use this file except in
##    compliance with the License.  You may obtain a copy of
##    the License at
## 
##        http://www.apache.org/licenses/LICENSE-2.0
## 
##    Unless required by applicable law or agreed to in
##    writing, software distributed under the License is
##    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
##    CONDITIONS OF ANY KIND, either express or implied.  See
##    the License for the specific language governing
##    permissions and limitations under the License.
## -------------------------------------------------------------
## 


APB	= ./apb_src
TESTS	= $(VCS_HOME)/etc/vmm/sv/RAL/tests

VCS	= vcs -R +plusarg_save -sverilog -ntb_opts rvm \
              +incdir+$(APB) +vmm_log_default=normal \
              +define+SLAVE_TOP_PATH=tb_top.dut tb_top.sv

all: clean hw_reset bit_bash_cov mem_walk mem_access user_test

ral_slave.sv: slave.ralf
	ralgen -c b -b -l sv -t slave slave.ralf

bit_bash: 
	$(VCS) $(TESTS)/bit_bash.sv 

hw_reset: ral_slave.sv 
	$(VCS) $(TESTS)/hw_reset.sv 

mem_walk: ral_slave.sv
	$(VCS) $(TESTS)/mem_walk.sv 

mem_access: ral_slave.sv
	$(VCS) $(TESTS)/mem_access.sv 

gen_html: ral_slave.sv
	$(VCS) $(TESTS)/gen_html.sv

user_test: ral_slave.sv
	$(VCS) user_test.sv 


# RAL functional coverage:
bit_bash_cov: ral_slave.sv
	$(VCS) $(TESTS)/bit_bash.sv +define+RAL_COVERAGE
	urg -dir simv.vdb

# Cleanup
clean:
	rm -rf ral_slave.sv csrc *.log simv* urgReport vc_hdrs.h *.hvp
