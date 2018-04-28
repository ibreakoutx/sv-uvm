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


program P;

`include "vmm.sv"

class vip1 extends vmm_xactor;
`vmm_typename(vip1)

  function new(string inst, vmm_unit parent = null);
    super.new(get_typename(), inst, 0,parent);
  endfunction

  virtual task config_dut_ph();
    `vmm_note(log, "Configuring dut...");
     #5;
    `vmm_note(log, "Done Configuring dut...");
  endtask
endclass

class vip2 extends vmm_xactor;
`vmm_typename(vip2)

  function new(string inst, vmm_unit parent = null);
    super.new(get_typename(), inst, 0,parent);
  endfunction

  virtual task run_ph();
    `vmm_note(log, "Starting run_phase...");
     #5;
    `vmm_note(log, "Ending run_phase...");
  endtask
endclass

class my_env extends vmm_timeline;
`vmm_typename(my_env)
  vip1 v1;
  vip2 v2;
  
  function new(string inst, vmm_unit parent = null);
    super.new(get_typename(), inst, parent);
  endfunction

  virtual function void build_ph();
     v1 = new("v1", this);
     v2 = new("v2", this);
  endfunction

endclass

class my_test1 extends vmm_test;
`vmm_typename(my_test1)
  
  function new(string name);
     super.new(name);
  endfunction

  virtual function void start_of_sim_ph();
     vmm_simulation::display_phases();
  endfunction

  virtual function void destruct_ph();
    `vmm_note(log, "Destruct phase done");
  endfunction

endclass

class my_test2 extends vmm_test;
`vmm_typename(my_test2)
  
  function new(string name);
     super.new(name);
  endfunction

  virtual function void start_of_sim_ph();
     vmm_simulation::display_phases();
  endfunction

  virtual function void destruct_ph();
    `vmm_note(log, "Destruct phase done");
  endfunction

endclass

class my_test3 extends vmm_test;
`vmm_typename(my_test3)
  
  function new(string name);
     super.new(name);
  endfunction

  virtual function void start_of_sim_ph();
     vmm_simulation::display_phases();
  endfunction

  virtual function void destruct_ph();
    `vmm_note(log, "Destruct phase done");
  endfunction

endclass

my_test1 test1;
my_test2 test2;
my_test3 test3;
initial begin
   my_env env;
   test1 = new("test1");
   test2 = new("test2");
   test3 = new("test3");
   env = new("env");

   //test1.run_phase();
   //vmm_simulation::list();
   vmm_simulation::run_tests();
end

endprogram



