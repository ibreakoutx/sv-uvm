//------------------------------------------------------------------------------
// Copyright 2010 Synopsys Inc.
//
// All Rights Reserved Worldwide
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License.  You may obtain
// a copy of the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
// License for the specific language governing permissions and limitations
// under the License.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// 
// This test shows how individual phases of UVM is synchronized with vmm_env methods
//
//------------------------------------------------------------------------------

`define VMM_ON_TOP 

`include "uvm_pkg.sv"
`include "vmm.sv"
 
`include "vmm_other.sv"
`include "uvm_other.sv"


program example_06_env_step_by_step;
   vmm_log log    = new("example_06_env_step_by_step","program");
   uvm_comp_ext c = new("comp");
   vmm_env_ext  e = new("env");

  initial begin
    e.gen_cfg();
    #100  `vmm_note(log, $psprintf("%t *** between GEN_CFG and BUILD",$time));
    e.build();
    #100  `vmm_note(log, $psprintf("%t *** between BUILD and RESET_DUT",$time));
    e.reset_dut();
    #100 `vmm_note(log, $psprintf("%t *** between RESET_DUT and CFG_DUT",$time));
    e.cfg_dut();
    #100  `vmm_note(log, $psprintf("%t *** between CFG_DUT and CLEANUP",$time));
     e.wait_for_end();
     e.cleanup();
    #100  `vmm_note(log, $psprintf("%t *** between CLEANUP and run",$time));
    e.run();
    #100  `vmm_note(log, $psprintf("%t *** after full run",$time));
  end

endprogram
