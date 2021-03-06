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

#VMM	= +incdir+$(VMM_HOME)/sv
VMM	= -ntb_opts rvm

TESTDIR	= $(VCS_HOME)/etc/vmm/sv/RAL/tests

WB	= ./wishbone
MII	= ./ethernet
TB	= tb_top.sv $(VMM) +incdir+$(WB)+$(MII)

DUTDIR	= ./oc_ethernet
DUT	= -F $(DUTDIR)/rtl_file_list.lst +incdir+$(DUTDIR)

OPTS	=

VCS	= vcs -R -sverilog +verilog1995ext+.v -extinclude \
	      +warn=noBCNACMBP $(OPTS)


all: clean tests 

tests: hw_reset \
	bit_bash \
	reg_access \
	mem_walk

%: ral_oc_ethernet.sv $(TESTDIR)/%.sv
	mkdir -p work
	$(VCS) timescale.v $(TESTDIR)/$*.sv $(TB) $(DUT) \
               +define+OC_ETHERNET_TOP_PATH=tb_top.dut \
               +define+VMM_RAL_TEST_PRE_INCLUDE=ral_env.svh \
               +define+VMM_RAL_TEST_POST_INCLUDE=ral_pgm.svh \
               +define+SINGLE_RAM_VARIABLE

report:
	urg -dir simv.vdb
	urg -show text -dir simv.vdb

ral_oc_ethernet.sv: oc_ethernet.ralf
	ralgen -b -l sv -t oc_ethernet oc_ethernet.ralf

clean:
	rm -rf *.log csrc simv* *.h ral_oc*.sv ucli.key 
