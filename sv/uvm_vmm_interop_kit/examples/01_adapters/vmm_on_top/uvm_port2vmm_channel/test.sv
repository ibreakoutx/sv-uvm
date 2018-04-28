
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

// This test shows using vmm_uvm_channel adapter between vmm driver and uvm
//   producer

`define VMM_ON_TOP

`include "uvm_pkg.sv"
`include "vmm.sv"
 
`include "uvm_apb_rw.sv"             // UVM apb transaction
`include "vmm_apb_rw.sv"             // VMM apb transaction
`include "apb_rw_converters.sv"

`include "uvm_producers.sv"          // generic UVM producer
`include "vmm_consumers.sv"          // generic VMM consumer
`include "apb_scoreboard.sv"

class env extends `VMM_ENV;

  uvm_producer #(uvm_apb_rw) gen;
  vmm_consumer #(vmm_apb_rw) drv;
  apb_uvm_tlm2channel            adapter;
  apb_scoreboard             compare;
  bit PASS  = 0;

  function new (string name="env",
                uvm_component parent=null);
    super.new(name);
  endfunction

  virtual function void build();
    super.build();
    gen     = new("UVM Gen", uvm_top);
    drv     = new("VMM Drv",0);
    adapter = new("Channel Adapter", uvm_top, drv.in_chan);
    compare = new("comparator", uvm_top, drv.in_chan);
    uvm_top.set_config_int("UVM Gen", "num_trans",10);
    gen.blocking_put_port.connect(adapter.put_export);
    adapter.request_ap.connect(compare.uvm_in);

    // build all components
    uvm_build();
 endfunction

  virtual task start();
    super.start();
    drv.start_xactor();
  endtask

  virtual task wait_for_end();
    int num_trans;
    super.wait_for_end();
    uvm_report_info("Demo",
       $psprintf("Waiting for %0d transactions to complete",gen.num_trans));
    @(drv.num_insts == gen.num_trans);
    #100;
  endtask
  virtual task stop();
   super.stop();
    if(compare.m_matches == 10 && compare.m_mismatches == 0)
      PASS  = 1;
  endtask
  
  virtual task cleanup();
    super.cleanup();
    `vmm_note(log, ((PASS==1)?"TEST RESULT PASSED":"TEST RESULT FAILED"));
  endtask
    
endclass

module example_13_uvm_port2vmm_channel;
  env e = new;
  initial begin
    uvm_top.enable_print_topology=1;
    set_config_int("UVM Gen","num_trans",5);
    e.run();
  end

endmodule
