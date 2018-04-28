## 
## -------------------------------------------------------------
##    Copyright 2004-2009 Synopsys, Inc.
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



all : common_logger unique_logger

common_logger: clean comp_common_logger run_common_logger

unique_logger : clean comp_unique_logger run_unique_logger

clean:
	\rm -rf csrc* simv* *.log *.h ucli.key

comp_common_logger:
	vcs -sverilog -ntb_opts rvm dut.v vmm_sva.sv test.sv dut_test_top.v  +incdir+${VCS_HOME}/packages/sva -y ${VCS_HOME}/packages/sva +libext+.sv +incdir+./ +define+ASSERT_ON +define+SVA_VMM_LOG_ON +define+COMMON_LOG +libext+.sv  -l comp_com.log

run_common_logger:
	simv -l run_com.log
	
comp_unique_logger:
	vcs -sverilog -ntb_opts rvm dut.v test.sv dut_test_top.v +incdir+${VCS_HOME}/packages/sva -y ${VCS_HOME}/packages/sva +libext+.sv +incdir+./ +define+ASSERT_ON +define+SVA_VMM_LOG_ON +libext+.sv  -l comp_unq.log

run_unique_logger:
	simv -l run_unq.log
