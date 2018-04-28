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

//This test shows vmm_uvm channel adapter between vmm generator and uvm driver
`define VMM_ON_TOP

`include "uvm_pkg.sv"
`include "vmm.sv"
 
`include "uvm_apb_rw.sv"
`include "vmm_apb_rw.sv"
`include "apb_rw_converters.sv"
`include "apb_scoreboard.sv"

`include "uvm_consumers.sv"

class env extends `VMM_ENV;

   vmm_apb_rw_atomic_gen        gen;
   uvm_consumer   #(uvm_apb_rw) drv;
   apb_channel2uvm_tlm              adapter;
   apb_scoreboard               compare;
   
   bit PASS  = 0;
   
  virtual function void build();
    super.build();
    gen     = new("VMM Gen",1);
    drv     = new("UVM Drv", uvm_top);
    adapter = new("Channel Adapter", uvm_top, gen.out_chan);
    compare = new("comparator",      uvm_top, gen.out_chan);
    drv.blocking_get_port.connect(adapter.get_peek_export);
    drv.analysis_port.connect(compare.uvm_in);
    uvm_build();
  endfunction

  virtual task start();
    super.start();
    gen.start_xactor();
  endtask

  virtual task wait_for_end();
    super.wait_for_end();
    gen.notify.wait_for(vmm_apb_rw_atomic_gen::DONE);
  endtask

  virtual task stop();
    super.stop();
    gen.stop_xactor();
    if(compare.m_matches == gen.stop_after_n_insts 
       && compare.m_mismatches == 0)
      PASS  = 1;
  endtask

  virtual task cleanup();
   super.cleanup();
   `vmm_note(log, ((PASS==1)?"TEST RESULT PASSED":"TEST RESULT FAILED"));
  endtask
endclass

program example_14_vmm_channel2uvm_port;
  env e = new;

  initial begin
    e.build();
    e.gen.stop_after_n_insts = 10;
    e.run();
  end

endprogram
