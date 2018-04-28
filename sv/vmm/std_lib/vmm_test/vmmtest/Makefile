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


COMP_OPTS = -sverilog   $(OPTS) \
	    +incdir+./verif+./tests -ntb_opts rvm

RUN_OPTS  =

TEST = Default

all default: clean comp run 

comp:
	vcs -sverilog $(COMP_OPTS) \
		./rtl/alu.v ./verif/alu_test.sv ./verif/alu_tb_top.sv


run:
	./simv $(RUN_OPTS) +vmm_test=$(TEST)


clean:
	rm -rf simv* csrc ucli.key
	rm -rf vc_hdrs.h  *.log

