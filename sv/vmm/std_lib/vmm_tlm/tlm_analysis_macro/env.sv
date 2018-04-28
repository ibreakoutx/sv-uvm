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
  vmm_tlm_nb_transport_fw_port#(initiator, my_trans) socket = new(this, "initiator_put");
  vmm_tlm::phase_e l_ph;
  int l_delay;

  function new();
    super.new("initiator" , "inst1"  , 0);
  endfunction
   
  virtual protected task main();
    fork
      super.main();
    join_none

    forever begin
      trans.randomize();
      `vmm_note(this.log, trans.psdisplay("From initiator "));
      trans.notify.indicate(vmm_data::STARTED);
      socket.nb_transport_fw(trans, l_ph, l_delay);
      trans.notify.wait_for(vmm_data::ENDED);
      #5;
    end
  endtask: main
endclass: initiator

////////////////////////////////////////////////////////////
class target extends vmm_xactor;
  vmm_tlm_nb_transport_fw_export#(target, my_trans) socket = new(this, "target_put");

  vmm_tlm_analysis_port#(target,my_trans) write_port = new(this, "target_write_port");
 
  function new();
    super.new("target" , "inst2");
  endfunction
  
  my_trans trans;

  virtual protected task main();
    super.main();
  endtask : main

  virtual function vmm_tlm::sync_e nb_transport_fw(int id =-1, my_trans trans, ref vmm_tlm::phase_e ph, ref int delay);
    `vmm_note(this.log, trans.psdisplay("from target "));
    trans.notify.indicate(vmm_data::ENDED);
    this.write_port.write(trans);
    return vmm_tlm::TLM_ACCEPTED;
  endfunction: nb_transport_fw

endclass : target

class subscriber extends vmm_object;

   `vmm_tlm_analysis_export(1)
   `vmm_tlm_analysis_export(2)
   static vmm_log  log = new("subscriber", "class");

   vmm_tlm_analysis_export1#(subscriber,my_trans) write_export1 = new(this,"subscriber_write_port1");

   vmm_tlm_analysis_export2#(subscriber,my_trans) write_export2 = new(this,"subscriber_write_port2");

  function new(string name = "");
       super.new(null, name);

  endfunction : new
  virtual function write1(int id =-1, my_trans trans);

     `vmm_note(this.log, trans.psdisplay("from subscriber export1 "));
  endfunction : write1

  virtual function write2(int id=-1, my_trans trans);

     `vmm_note(this.log, trans.psdisplay("from subscriber export2 "));
  endfunction : write2
endclass : subscriber
////////////////////////////////////////////////////////////
class env extends vmm_env;
   initiator initiator0;
   initiator initiator1;
   target target0; 
   target target1; 
   subscriber sub0;
   static vmm_log log = new("env", "vmm_env");

   function new();
     super.new();
   endfunction: new

   virtual function void build();
      super.build();
      initiator0 = new();
      initiator1 = new();
      target0 = new();
      target1 = new();
      initiator0.socket.tlm_bind(target0.socket);
      initiator1.socket.tlm_bind(target1.socket);

      sub0 = new("subscriber1");
      target0.write_port.tlm_bind(sub0.write_export1);
      target1.write_port.tlm_bind(sub0.write_export2);
   endfunction : build

   virtual task start();
      super.start();
      initiator0.start_xactor();
      initiator1.start_xactor();
      target0.start_xactor();
      target1.start_xactor();
   endtask : start

   virtual task wait_for_end();
     super.wait_for_end();
     #49;
   endtask : wait_for_end

   virtual task stop();
      initiator0.stop_xactor();
      initiator1.stop_xactor();
      target0.stop_xactor();
      target1.stop_xactor();
      super.stop();
   endtask : stop
endclass: env


  env my_env;

  initial begin
    my_env = new();
    my_env.run();
  end

endprogram: test
