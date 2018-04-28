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
  vmm_tlm_b_transport_port#(initiator, my_trans) socket;
  vmm_tlm::phase_e l_ph;
  int l_delay;

  function new(vmm_object parent, string name, string inst, int stream_id);
    super.new(name,inst, stream_id, parent);
    socket = new(this, $psprintf("%s.%s", name,inst));
  endfunction
   
  virtual protected task main();
    fork
      super.main();
    join_none

    forever begin
      trans.randomize() with {data==this.stream_id;};
      `vmm_note(this.log, trans.psdisplay());
      socket.b_transport(trans,l_delay);
    end
  endtask: main
endclass: initiator

////////////////////////////////////////////////////////////
class memories extends vmm_xactor;
  vmm_tlm_nb_transport_fw_export#(memories, my_trans) socket;
 
  function new(vmm_object parent, string name, string inst);
    super.new(name,inst, stream_id, parent);
    socket = new(this, "target_put");
  endfunction
  
  my_trans trans;

  virtual protected task main();
    super.main();
  endtask : main

  virtual function vmm_tlm::sync_e nb_transport_fw(int id =-1 , vmm_data trans, ref vmm_tlm::phase_e ph, ref int delay);
    `vmm_note(this.log, trans.psdisplay());
    trans.notify.indicate(vmm_data::ENDED);
    return vmm_tlm::TLM_ACCEPTED;
  endfunction: nb_transport_fw
endclass : memories

////////////////////////////////////////////////////////////
class router #(INPUTS_NB=4, OUTPUTS_NB=4) extends vmm_xactor;
  vmm_tlm_b_transport_export#(router, my_trans) in_socket[INPUTS_NB];
  vmm_tlm_nb_transport_fw_port#(router, my_trans) out_socket[OUTPUTS_NB];
  vmm_tlm_port_base#(my_trans) peer;
  int l_delay;

  function new(vmm_object parent, string name, string inst);
    super.new(inst, name,, parent);
    foreach(in_socket[i]) 
      in_socket[i] = new(this, $psprintf("in_socket %0d", i));
    foreach(out_socket[i]) 
      out_socket[i] = new(this, $psprintf("out_socket %0d", i));
  endfunction
  
  virtual protected task main();
    super.main();
  endtask : main

  function int decode_address(int address);
    int range = 256/OUTPUTS_NB;
    for (int i=0; i<OUTPUTS_NB; i++)
      if(address>=range*i && address<(range*(i+1)))
        return i;
  endfunction

  virtual task b_transport(int index = -1, vmm_data trans, ref int delay);
    my_trans d;
    string str;
    int id;
    vmm_tlm::phase_e l_ph;
    peer = this.in_socket[0].get_peer();
    str = $psprintf("%s: ", peer.get_object_name());
    $cast(d, trans);
    `vmm_note(this.log, d.psdisplay(str));
    id = decode_address(d.addr);
    out_socket[id].nb_transport_fw(d,l_ph,l_delay);
    #5;
  endtask

endclass: router
      
////////////////////////////////////////////////////////////
class env extends vmm_env;
   initiator initiators[4];
   memories memories[4]; 
   router#(4) router0;
   static vmm_log log = new("env", "vmm_env");

   function new();
     super.new();
   endfunction: new

   virtual function void build();
      super.build();
      router0 = new(this, "Router", "0");
      foreach(initiators[i])
        initiators[i] = new(this, "initiator", $psprintf("%0d", i), i);
      foreach(memories[i]) 
        memories[i] = new(this, "mem", $psprintf("%0d", i));

      foreach(router0.in_socket[i]) 
        initiators[i].socket.tlm_bind(router0.in_socket[i]);
      foreach(router0.out_socket[i]) 
        router0.out_socket[i].tlm_bind(memories[i].socket);
   endfunction : build

   virtual task start();
      super.start();
      foreach(initiators[i]) 
        initiators[i].start_xactor();
   endtask : start

   virtual task wait_for_end();
     super.wait_for_end();
     #49;
   endtask : wait_for_end

   virtual task stop();
      foreach(initiators[i]) 
        initiators[i].stop_xactor();
      super.stop();
   endtask : stop
endclass: env

  env my_env;

  initial begin
    my_env = new();
    my_env.run();
  end

endprogram: test
