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



all_normal: clean gen compile_normal run_normal

all_disable: clean gen compile_disable run_disable

clean:
	\rm -rf csrc simv* vc* log.* ucli.key ral_ec.sv


gen:
	ralgen -l sv -t ec ec.ralf

compile_normal:	
	vcs -l vcs.log -sverilog +incdir+$$VCS_HOME/etc/rvm   -debug_all ec_intf.if.svi ec_ral_test.sv ec.v ec_top.v

compile_disable:	
	vcs -l vcs.log -sverilog +incdir+$$VCS_HOME/etc/rvm   -debug_all ec_intf.if.svi ec_ral_test.sv ec.v ec_top.v +define+DISABLE_CH_MSG

run_normal:
	simv +vmm_log_default=verbose 

