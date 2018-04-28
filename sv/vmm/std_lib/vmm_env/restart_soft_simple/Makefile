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



all: clean comp0 run0 comp1 run1 comp2 run2 comp3 run3

clean_pre:
	\rm -rf simv* csrc* 

clean:
	\rm -rf simv* csrc* *.log *.h ucli.key

comp0: clean_pre
	vcs -sverilog  -l comp0.log -ntb_opts rvm     +incdir+.+ run_00.sv
run0:
	simv -l run0.log


comp1:  clean_pre
	vcs -sverilog  -l comp1.log -ntb_opts rvm     +incdir+.+ run_01.sv
run1:
	simv -l run1.log

comp2: clean_pre
	vcs -sverilog -l comp2.log -ntb_opts rvm     +incdir+.+ run_00_01.sv
run2:
	simv -l run2.log

comp3: clean_pre
	vcs -sverilog -l comp3.log  -ntb_opts rvm     +incdir+.+ run_01_00.sv
run3:
	simv -l run3.log


