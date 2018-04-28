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



all: clean comp run

clean:
	rm -rf simv* csrc vc_hdrs.h ucli.key *.log

comp:
	vcs -sverilog -ntb_opts rvm +incdir+./verif +define+ALU_BUG1 alu_test.sv \
		./rtl/alu.v ./verif/alu_tb_top.sv -l comp.log

run:
	simv -l run.log


