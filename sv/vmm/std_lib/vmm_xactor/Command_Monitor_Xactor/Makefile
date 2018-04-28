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



VCS	= vcs -R +plusarg_save -sverilog   \
              -ntb_opts rvm +vmm_log_default=trace

all: simple annotate
simple: clean comp run 
annotate: clean comp_annotate run_annotate

clean:
	rm -rf *.log csrc simv* vc_hdrs.h ucli.key 

comp:
	vcs +plusarg_save -sverilog   -ntb_opts rvm test_simple.sv tb_top.sv

run:
	simv -l run.log +vmm_log_default=trace

comp_annotate:
	vcs +plusarg_save -sverilog   -ntb_opts rvm  test_annotate.sv tb_top.sv -l comp_annotate.log

run_annotate:
	simv -l run.log +vmm_log_default=trace
