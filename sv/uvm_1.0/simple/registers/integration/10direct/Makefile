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

ifdef EXPLICIT_MON
OPTS	+= +define+EXPLICIT_MON
endif

all: clean comp run

clean:
	rm -rf simv* csrc *.log vc_hdrs.h ucli.key

comp:
	vcs -sverilog -cpp g++ -cc gcc -timescale=1ns/1ns -ntb_opts uvm-1.0 $(OPTS) +incdir+../common \
		+incdir+../../common/apb -debug_all \
		../common/test.sv -l comp.log

run:
	simv -l run.log +UVM_SEQUENCE=uvm_reg_mem_built_in_seq
