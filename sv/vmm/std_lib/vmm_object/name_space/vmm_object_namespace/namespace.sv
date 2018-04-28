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


program test;

`include "vmm.sv"

vmm_log log = new("test", "VMM_OBJ_NAMESPACE");

class A extends vmm_object;
 function new (string name, vmm_object parent=null);
  super.new (parent, name);
  vmm_object::create_namespace("NS1", vmm_object::IN_BY_DEFAULT);
 endfunction
endclass

class B extends vmm_object;
 function new (string name, vmm_object parent=null);
  super.new (parent, name);
  vmm_object::create_namespace("NS2", vmm_object::OUT_BY_DEFAULT);
 endfunction
endclass


class C extends vmm_object;
 function new (string name, vmm_object parent=null);
  super.new (parent, name);
 endfunction
endclass

A a_a = new("a_a_obj");
B b_b = new("b_b_obj");
int i = 0;

initial begin
	string ns_array[];
	C c_c = new("c_c_obj");

	vmm_object::get_namespaces(ns_array);
	`vmm_note(log,{"Printing complete name space .... \n"});
         foreach (ns_array[i])
	  `vmm_note(log,{"Name space : ", ns_array[i]," is used in this test.\n"});

	vmm_object::create_namespace("NS3", vmm_object::IN_BY_DEFAULT);
	vmm_object::get_namespaces(ns_array);
	`vmm_note(log,{"Printing complete name space .... \n"});
         foreach (ns_array[i])
	   `vmm_note(log,{"Name space : ", ns_array[i]," is used in this test.\n"});
 
 	log.report();
end 
endprogram
