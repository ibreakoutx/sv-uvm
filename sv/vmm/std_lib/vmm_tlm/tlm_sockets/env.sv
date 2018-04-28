//
// -------------------------------------------------------------
//    Copyright 2004-2009 Synopsys, Inc.
//    All Rights Reserved Worldwide
//
//    Licensed under the Apache License, Version 2.0 (the
//    "License"); you may not use this file except in
//    compliance with the License.  You may obtain a copy of
//    the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in
//    writing, software distributed under the License is
//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//    CONDITIONS OF ANY KIND, either express or implied.  See
//    the License for the specific language governing
//    permissions and limitations under the License.
// -------------------------------------------------------------
//

program test();
`include "vmm.sv"


////////////////////////////////////////////////////////////
class my_trans extends vmm_data;
  typedef enum { READ , WRITE } type_t;
  rand bit [7:0] addr;
  rand bit [7:0] data;
  rand type_t rw;

  `vmm_data_member_begin(my_trans)
	`vmm_data_member_scalar(addr, DO_ALL)
	`vmm_data_member_scalar(data, DO_ALL)
	`vmm_data_member_enum(rw, DO_ALL)
  `vmm_data_member_end(my_trans)
endclass : my_trans


////////////////////////////////////////////////////////////
class initiator extends vmm_xactor;
  my_trans trans = new();
  vmm_tlm_initiator_socket#(initiator, my_trans) socket = new(this, "initiator_put");
  vmm_tlm::phase_e l_ph;
  int l_delay;

  function new(vmm_object parent, string name);
    super.new(name , "inst1"  , 0, parent);
  endfunction
   
   virtual function vmm_tlm::sync_e nb_transport_bw(int id = -1, my_trans trans, ref vmm_tlm::phase_e ph, ref int delay);
   endfunction 
   
   virtual protected task main();
    fork
      super.main();
    join_none

    forever begin
      trans.randomize();
      `vmm_note(this.log, trans.psdisplay("From initiator "));
      trans.notify.indicate(vmm_data::STARTED);
      socket.nb_transport_fw(trans,l_ph,l_delay);
      trans.notify.wait_for(vmm_data::ENDED);
      #5;
    end
  endtask: main
endclass: initiator

////////////////////////////////////////////////////////////
class target extends vmm_xactor;
   vmm_tlm_target_socket#(target, my_trans) socket = new(this, "target_put");
 
   function new(vmm_object parent, string name);
     super.new(name , "inst2",, parent);
   endfunction
   
   my_trans trans;

   virtual protected task main();
     super.main();
   endtask : main

   virtual function vmm_tlm::sync_e nb_transport_fw(int id = -1, my_trans trans, ref vmm_tlm::phase_e ph, ref int delay);
      `vmm_note(this.log, trans.psdisplay("from target "));
      trans.notify.indicate(vmm_data::ENDED);
      return vmm_tlm::TLM_ACCEPTED;
   endfunction: nb_transport_fw

   virtual task b_transport(int id = -1, my_trans trans, ref int delay );
   endtask : b_transport   
endclass : target

////////////////////////////////////////////////////////////
class env extends vmm_env;
   initiator initiator0;
   target target0; 
   static vmm_log log = new("env", "vmm_env");

   function new();
     super.new();
   endfunction: new

   virtual function void build();
      super.build();
      initiator0 = new(this,"initiator");
      target0 = new(this,"target");
      initiator0.socket.tlm_bind(target0.socket);
   endfunction : build

   virtual task start();
      super.start();
      initiator0.start_xactor();
      target0.start_xactor();
   endtask : start

   virtual task wait_for_end();
     super.wait_for_end();
     #49;
   endtask : wait_for_end

   virtual task stop();
      initiator0.stop_xactor();
      target0.stop_xactor();
      super.stop();
   endtask : stop
endclass: env


  env my_env;

  initial begin
    my_env = new();
    my_env.run();
  end

endprogram: test
