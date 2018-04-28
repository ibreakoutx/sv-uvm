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

// test functions for vmm_unit: Associated with a timeline
   // test is_enabled()
   // test disable_module()
 
program automatic unitExample;
  `include "vmm.sv"

  bit reset;

  class vip1 extends vmm_xactor;
    `vmm_typename(vip1)
    int seq;
    int done;

    function new (string name, vmm_object parent = null);
      super.new(name, name, 0,parent);
    endfunction

    task start_ph;
      fork
        begin 
          repeat (10) #10 seq++;
          done = 1;
        end
      join_none
      `vmm_note(log, `vmm_sformatf("vip1 Started"));
    endtask
  endclass

  class vip2 extends vmm_xactor;
    `vmm_typename(vip2)
    int seq;
    int done;

    function new (string name, vmm_object parent = null);
      super.new(name, name,0, parent);
    endfunction

    task start_ph;
      fork
        begin 
          repeat (50) #5 seq++;
          done = 1;
        end
      join_none
      `vmm_note(log, `vmm_sformatf("vip2 Started"));
    endtask
  endclass

  class MyEnv extends vmm_test;
    `vmm_typename(MyEnv)
    vip1   c1;
    vip2   c2;

    function new (string name, vmm_object parent = null);
      super.new(name, name, parent);
    endfunction

    function void build_ph;
      c1 = new ({get_object_name(), "_c1"}, this);
      c2 = new ({get_object_name(), "_c2"}, this);
      `vmm_note(log, `vmm_sformatf("Building complete"));
    endfunction

    task reset_ph;
      unitExample.reset <= 1;
      #100 unitExample.reset <= 0;
      `vmm_note(log, `vmm_sformatf("Resetting start"));
    endtask

    task shutdown_ph;
      wait (c1.done && c2.done);
      `vmm_note(log, `vmm_sformatf("All components are done"));
    endtask
  endclass

  MyEnv   env;
  initial begin
    env = new ("env");
    vmm_simulation::run_tests();
  end

endprogram
