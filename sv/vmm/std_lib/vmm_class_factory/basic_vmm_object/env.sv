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
//vmm_object factory class


program P;
`include "vmm.sv"

class ahb_trans extends vmm_object;
  `vmm_typename(ahb_trans)
  rand bit [7:0] addr;
  static vmm_log log = new("ahb_trans", "object");

  virtual function ahb_trans allocate();
    allocate = new(this.get_object_name(), get_parent_object());
  endfunction

  virtual function ahb_trans copy();
     ahb_trans tr = new(this.get_object_name(), get_parent_object());
     tr.addr = this.addr;
     return tr;
  endfunction

  function new(string name = "", vmm_object parent = null);
    super.new(parent, name);
  endfunction
  
  `vmm_class_factory(ahb_trans)

endclass

class my_ahb_trans extends ahb_trans;
  `vmm_typename(my_ahb_trans)

  static vmm_log log = new("my_ahb_trans", "object");

  function new(string name = "", vmm_object parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function my_ahb_trans allocate();
     allocate = new(this.get_object_name(), get_parent_object());
  endfunction

  virtual function my_ahb_trans copy();
     my_ahb_trans tr = new(this.get_object_name(), get_parent_object());
     tr.addr = this.addr;
     return tr;
  endfunction

  `vmm_class_factory(my_ahb_trans)

endclass


class ahb_gen extends vmm_unit;
`vmm_typename(ahb_gen)
   ahb_trans tr;

   function new(string name);
     super.new(get_typename(), name);
   endfunction

   virtual function void build_ph();
     tr = ahb_trans::create_instance(this, "Ahb_Tr0", `__FILE__, `__LINE__); 
		if(!((tr.get_typename() =="class P.ahb_trans") || (tr.get_typename() == "class P.my_ahb_trans")))
		`vmm_error(log,"ERROR");

   endfunction

endclass

initial begin
  ahb_gen gen0 = new("gen0");
  ahb_gen gen1 = new("gen1");
  ahb_trans tr;
  vmm_log log = new("prgm", "prgm");

  gen0.build_ph();
	if(gen0.tr.addr !==00)
	`vmm_error(log,"Error1");


  tr = new("gen0_trans");
  tr.addr = 5;
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
log.report();
end

endprogram


