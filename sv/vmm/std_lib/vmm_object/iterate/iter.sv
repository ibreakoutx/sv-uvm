
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

class A extends vmm_object;
function new(string name, vmm_object parent=null);
  super.new(parent,name);
endfunction
endclass

class B extends vmm_object;
function new(string name, vmm_object parent=null);
  super.new(parent,name);
endfunction
endclass

class C extends A;
function new(string name, vmm_object parent=null);
  super.new(name,parent);
endfunction
endclass

class D extends vmm_object;
  A a1;
  B b1;
  C c1;
  C c2;

  function new(string name, vmm_object parent=null);
  super.new(parent,name);
    a1 = new({name,"_a1_obj"},this);
    b1 = new({name,"_b1_obj"},this);
    c1 = new({name,"_c1_obj"},this);
    c2 = new({name,"_c2_obj"}); //No parent
  endfunction

endclass

class E extends vmm_object;
  D d1;
  D d2;
function new(string name, vmm_object parent=null );
  super.new(parent,name);
  d1 = new({name,"_d1_obj"},null);
  d2 = new({name,"_d2_obj"},this);
endfunction
endclass



program P;
`include "vmm.sv"

initial begin
  vmm_log log = new("Test","main");
  E e11 = new("e11_obj");
  vmm_object_iter my_iter = new(e11, "/a1/");
  vmm_object my_obj;

 `foreach_vmm_object(vmm_object,"@%*", e11) begin
	`vmm_note(log, $psprintf("Got: %s", obj.get_object_name()));
   end

  my_obj = my_iter.first();
  if(my_obj.get_object_name() == "e11_obj_d2_obj_a1_obj")
    `vmm_note(log, "Expected pattern matched - a1");
  else
    `vmm_error(log, $psprintf("Error - Expecting object a1 but found %s", my_obj.get_object_name()));

  my_obj = my_iter.next();
  if(my_obj == null)
    `vmm_note(log, "Null expected");
  else
    `vmm_error(log, $psprintf("Error - Expecting object null but found %s", my_obj.get_object_name()));

  log.report();
end


endprogram
