## 
## -------------------------------------------------------------
##    Copyright 2010 Synopsys, Inc.
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

ifndef USE_VCS_LIB
COMP_ARGS = \
           -sverilog \
	   -ntb_opts uvm+rvm \
           +define+VMM_ON_TOP	\
           +incdir+../../../../src \
           +incdir+../../../../src/hfpb \
           +incdir+../../../../src/hfpb_components
else
COMP_ARGS = \
           -sverilog \
           +incdir+$(VCS_HOME)/etc/vmm \
           +incdir+$(VCS_HOME)/etc/uvm \
           +incdir+../../../../src \
           +incdir+../../../../src/hfpb \
           +incdir+../../../../src/hfpb_components \
           +define+VMM_ON_TOP	\
	   +define+VMM_IN_PACKAGE
endif

RUN_ARGS = +vmm_log_default=trace  -timescale=100ns/100ns

ifdef EXTRA_OPTS
COMP_ARGS += $(EXTRA_OPTS)
endif



all: clean comp run

clean:
	rm -rf simv* csrc vc_hdrs.h *.log ucli.key

comp:
	vcs $(COMP_ARGS) -l comp.log test.sv

run:
	simv -l run.log

