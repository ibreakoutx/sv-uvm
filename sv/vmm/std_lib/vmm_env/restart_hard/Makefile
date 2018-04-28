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


all: clean test_00 test_01 test_00_01 test_01_00

test_00: comp_00 run_00
test_01: comp_01 run_01
test_00_01: comp_00_01 run_00_01
test_01_00: comp_01_00 run_01_00

clean:
	rm -rf simv* csrc  *.log *.h ucli.key
comp_00:
	\rm -rf simv* csrc
	vcs -sverilog -ntb_opts rvm   +incdir+.+ run_00.sv -l comp0.log
run_00:
	simv -l run_0.log

comp_01:
	\rm -rf simv* csrc
	vcs -sverilog  -ntb_opts rvm   +incdir+.+ run_01.sv -l comp1.log
run_01:
	simv -l run_01.log


comp_00_01:
	\rm -rf simv* csrc
	vcs -sverilog  -ntb_opts rvm   +incdir+.+ run_00_01.sv -l comp2.log
run_00_01:
	simv -l run_00_01.log

comp_01_00:
	\rm -rf simv* csrc
	vcs -sverilog -ntb_opts rvm   +incdir+.+ run_01_00.sv  -l comp3.log
run_01_00:
	simv -l run_01_00.log

