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

// This test shows how to use analysis port for UVM with VMM notify

`define VMM_ON_TOP

`include "uvm_pkg.sv"
`include "vmm.sv"
 
`include "uvm_apb_rw.sv"
`include "vmm_apb_rw.sv"
`include "apb_rw_converters.sv"

`include "uvm_producers.sv"
`include "vmm_consumers.sv"


class env extends `VMM_ENV;

 
  uvm_publish #(uvm_apb_rw) sender;
  vmm_watcher #(vmm_apb_rw) observer;
  apb_analysis2notify       ap2ntfy;
   
  virtual function void build();
    super.build();
    sender = new("sender",uvm_top);
    observer = new("observer");
    ap2ntfy = new("ap2ntfy",uvm_top, observer.notify, observer.INCOMING);
    sender.out.connect(ap2ntfy.analysis_export);
    uvm_build();
  endfunction

  virtual task start();
    super.start();
    observer.start_xactor();
  endtask

  virtual task wait_for_end();
    super.wait_for_end();
    //Stop the simulation after 100 timeunits
    #100;
  endtask

   virtual task stop();
    super.stop();
    observer.stop_xactor();
  endtask

endclass


module example_15_uvm_analysis2vmm_notify;

  env e = new;

  initial begin
     e.build();
     #10;
     e.run();
  end

endmodule
