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


all:	 def elect point1 point2 point3 point4
	
default: def

################## COMMON #########################

VCS = vcs
RTL = top.v  mem.v
OPT = -sverilog -debug_all -ntb_opts rvm 
INC = 
CMP =
RUN = 
DIR = $(shell basename `pwd`)

################## VCS #########################

def: comp_def run
elect: comp_ele	run_ele

point1: comp_01 run1
point2: comp_02	run2
point3: comp_03	run3
point4: comp_04	run4


err: 
	$(VCS) $(OPT) $(INC) test_01.sv $(RTL) $(CMP) +define+err


comp_%:
	$(VCS) $(OPT) $(INC) test_$*.sv $(RTL) $(CMP)


comp_def:
	$(VCS) $(OPT) $(INC) test_00.sv $(RTL) $(CMP) +define+def

comp_ele:
	$(VCS) $(OPT) $(INC) test_00.sv $(RTL) $(CMP) +define+def +define+elect


run:
	./simv $(RUN)
run_ele:
	./simv $(RUN)	
run1:
	./simv $(RUN)	
run2:
	./simv $(RUN)	
run3:
	./simv $(RUN)
run4:
	./simv $(RUN)	
	
################## HELP #########################

help:
	@echo "gmake - run this lab using VCS"gre

################## Clean #########################

clean:
	rm -rf simv* csrc* *.vpd* *.log *.h *.key


 
