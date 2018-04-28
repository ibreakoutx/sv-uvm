
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


all: clean comp_blk_tx run_blk_tx comp_sys_tx run_sys_tx

clean:
	rm -rf ral_*.sv *.log csrc simv* vc_hdrs.h ucli.key

blk_trivial_test comp_blk_tx: ral_oc_ethernet
	vcs +plusarg_save -sverilog -ntb_opts rvm   +verilog1995ext+.v  +warn=noBCNACMBP +incdir+ethernet+wishbone+rtl +define+WEIRDNESS -F rtl/rtl_file_list.lst blk_trivial_test.sv -l comp_blk_tx.log

run_blk_tx:
	simv -l run_blk_tx.log

ral_oc_ethernet: oc_ethernet.ralf
	ralgen -l sv -t oc_ethernet oc_ethernet.ralf

sys_trivial_test comp_sys_tx: ral_dual_eth
	vcs +plusarg_save -sverilog -ntb_opts rvm   +verilog1995ext+.v  +warn=noBCNACMBP +incdir+ethernet+wishbone+rtl +define+WEIRDNESS -F rtl/rtl_file_list.lst dual_eth.v sys_trivial_test.sv -l comp_sys_tx.log

run_sys_tx:
	./simv -l run_sys_tx.log

ral_dual_eth: oc_ethernet.ralf dual_eth.ralf
	ralgen -l sv -t dual_eth dual_eth.ralf

