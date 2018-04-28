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

class ahb_trans extends vmm_data;
  `vmm_typename(ahb_trans)
  rand bit [7:0] addr;
  static vmm_log log = new("ahb_trans", "object");

  virtual function ahb_trans allocate();
    allocate = new(this.get_object_name(), get_parent_object());
  endfunction

  virtual function ahb_trans copy(vmm_data to = null);
     ahb_trans tr = new(this.get_object_name(), get_parent_object());
     tr.addr = this.addr;
     return tr;
  endfunction

  function new(string name = "", vmm_object parent = null);
    super.new(log);
  endfunction
  
  `vmm_class_factory(ahb_trans)

endclass

class my_ahb_trans extends ahb_trans;
  `vmm_typename(my_ahb_trans)

  static vmm_log log = new("my_ahb_trans", "object");

  function new(string name = "", vmm_object parent = null);
    super.new(name, parent);
   	addr= 1'd1;
  endfunction
    
  virtual function my_ahb_trans allocate();
     allocate = new(this.get_object_name(), get_parent_object());
  endfunction

  virtual function my_ahb_trans copy(vmm_data to = null);
     my_ahb_trans tr = new(this.get_object_name(), get_parent_object());
     tr.addr = this.addr;
     return tr;
  endfunction

  `vmm_class_factory(my_ahb_trans)

endclass


class ahb_gen extends vmm_xactor;
`vmm_typename(ahb_gen)
   ahb_trans tr;

   function new(string name);
     super.new(get_typename(), name);
   endfunction

   virtual function void start_of_sim_ph();
     tr = ahb_trans::create_instance(this, "Ahb_Tr0", `__FILE__, `__LINE__); 
     `vmm_note(log, $psprintf("Ahb transaction type is %s %d", tr.get_typename() ,tr.addr));
   		if(!((tr.get_typename() =="class P.ahb_trans") || (tr.get_typename() == "class P.my_ahb_trans")))
      		`vmm_error(log,"ERROR1");

   		if((tr.get_typename() == "class P.my_ahb_trans"))
	      	if(tr.addr != 1'd1)
      		`vmm_error(log,"Error1");
   endfunction

endclass

class mytest1 extends vmm_test;
`vmm_typename(mytest1)

  ahb_gen gen0 = new("gen0");
  ahb_gen gen1 = new("gen1");
  ahb_trans tr;
  vmm_log log = new("prgm", "prgm");

 function new(string name);
   super.new(name);
 endfunction

 function void set_config(); ////As set_config() is used for test1, this test will not run in concatenation with other tests.
   ahb_trans::override_with_new("@%*", my_ahb_trans::this_type, log, `__FILE__, `__LINE__);
 endfunction

function void start_of_sim_ph;
     gen0.start_of_sim_ph();
     gen1.start_of_sim_ph();
 endfunction 

endclass

class mytest2 extends vmm_test;
`vmm_typename(mytest2)

  ahb_gen gen = new("gen");
  ahb_trans tr;
  vmm_log log = new("prgm", "prgm");

 function new(string name);
   super.new(name);
 endfunction

function void start_of_sim_ph;
    gen.start_of_sim_ph();
 endfunction

endclass


mytest1 test1;
mytest2 test2;
initial begin

test1 = new("test1");
test2 = new("test2");

vmm_simulation::list();
vmm_simulation::run_tests();

end

endprogram



