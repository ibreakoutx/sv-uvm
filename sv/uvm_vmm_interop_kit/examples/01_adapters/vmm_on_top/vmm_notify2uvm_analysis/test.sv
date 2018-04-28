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
`define VMM_ON_TOP

`include "uvm_pkg.sv"
`include "vmm.sv"
 
`include "uvm_apb_rw.sv"
`include "vmm_apb_rw.sv"
`include "apb_rw_converters.sv"
 
`include "vmm_producers.sv"
`include "uvm_consumers.sv"
`include "apb_scoreboard.sv"

//------------------------------------------------------------------------------

class env extends `VMM_ENV;

  vmm_notifier  #(vmm_apb_rw) sender;
  uvm_subscribe #(uvm_apb_rw) observer;
  apb_notify2analysis         ntfy2ap;
  apb_scoreboard              compare;
  vmm_apb_rw                  tmp;

  virtual function void build();
    super.build();
    sender    = new("v_prod");
    observer  = new("o_cons",uvm_top);
    ntfy2ap   = new("ntfy2ap",uvm_top, sender.notify, sender.GENERATED);
    ntfy2ap.analysis_port.connect(observer.analysis_export);
    compare  = new("comparator", uvm_top, sender.out_chan,1);
    observer.ap.connect(compare.uvm_in);
    uvm_build();
  endfunction

  virtual task start();
    super.start();
    tmp  = new();
    sender.start_xactor();
  endtask

  virtual task wait_for_end();
    super.wait_for_end();
    //Stop the simulation after 100 timeunits
    #100;
  endtask

  virtual task report();
    super.report();
    if(compare.m_matches > 0 && compare.m_mismatches == 0)
      `vmm_note(log,"Simulation PASSED");
    else
      `vmm_error(log,"Simulation FAILED");
  endtask // report
  
endclass


program example_16_vmm_notify2uvm_analysis;

  env e = new;

  initial begin
     e.build();
     #10;
     e.run();
  end
   
endprogram
