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

class ahb_trans;
  `vmm_typename(ahb_trans)
  string name;
  vmm_object parent;
  rand bit [7:0] addr;
  static vmm_log log;

  function new(string name = "", vmm_object parent = null, bit[7:0] addr=0);
     log = new(this.get_typename(), "object");
     this.name = name;
     this.parent = parent;
     this.addr = addr;
  endfunction
  
  virtual function ahb_trans allocate();
    allocate = new;
  endfunction

  virtual function ahb_trans copy();
    copy = new(this.name, this.parent, this.addr);
  endfunction

  `vmm_class_factory(ahb_trans)
endclass

class my_ahb_trans extends ahb_trans;
  `vmm_typename(my_ahb_trans)
  rand bit [7:0] data;


  function new(string name = "", vmm_object parent = null, bit[7:0] addr=0, bit[7:0] data=0);
    super.new(name, parent, addr);
    this.data = data;
  endfunction
  
  virtual function my_ahb_trans copy();
     my_ahb_trans tr = new(this.name, this.parent, this.addr, this.data);
     return tr;
  endfunction

  virtual function my_ahb_trans allocate();
    allocate = new;
  endfunction

  `vmm_class_factory(my_ahb_trans)

endclass


class ahb_gen extends vmm_xactor;
`vmm_typename(ahb_gen)
   ahb_trans tr;

   function new(string name);
     super.new(get_typename(), name);
   endfunction

   virtual function void build_ph();
     tr = ahb_trans::create_instance(this, "Ahb_Tr0", `__FILE__, `__LINE__); 
    // `vmm_note(log, $psprintf("Ahb transaction type is %s", tr.get_typename()));
	 if(!((tr.get_typename() =="class P.ahb_trans") || (tr.get_typename() == "class P.my_ahb_trans")))
        `vmm_error(log,"ERROR");
   endfunction

endclass

class test extends vmm_test;
vmm_log log;
function new(string name);
super.new(name);
log = new("t","tst");
endfunction

virtual function void build_ph();
  ahb_gen gen0 = new("gen0");
  ahb_gen gen1 = new("gen1");
  ahb_trans tr;
  my_ahb_trans mtr;

  gen0.build_ph();
	if(gen0.tr.addr !==00)
        `vmm_error(log,"Error1");


  tr = new("gen0_trans", null, 5);
  ahb_trans::override_with_copy("@%*", tr, log, `__FILE__, `__LINE__);
  gen0.build_ph();
	if(gen0.tr.addr !==05)
        `vmm_error(log,"Error1");


  ahb_trans::override_with_new("@%*", my_ahb_trans::this_type, log, `__FILE__, `__LINE__);
  gen0.build_ph();
  gen1.build_ph();
if(gen0.tr.addr !==00)
        `vmm_error(log,"Error1");
if(gen1.tr.addr !==00)
        `vmm_error(log,"Error1");


  mtr = new("gen1_trans", null, 50, 500);
  my_ahb_trans::override_with_copy("@%*", mtr, log, `__FILE__, `__LINE__);
  gen1.build_ph();
	if(gen0.tr.addr !==00)
        `vmm_error(log,"Error1");
	if(gen1.tr.addr !==00)
        `vmm_error(log,"Error1");
endfunction
endclass

initial
begin
 test test_inst = new("mytest");
 vmm_simulation::run_tests();
  test_inst.log.report();
end

endprogram



