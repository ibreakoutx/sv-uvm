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

class A #(type I=int);
   I i;
   static vmm_log log = new("A", "A");

   virtual function A#(I) copy();
     copy = new(); copy.i = i;
   endfunction

   virtual function A#(I) allocate();
     allocate = new();
   endfunction
  
   virtual function string get_type();
     return "A";
   endfunction
   `vmm_class_factory(A#(I))
endclass

class AB#(type I=int, J=int) extends A#(I); 
   J j;
   static vmm_log log = new("AB", "AB");

   virtual function AB#(I,J) copy();
     copy = new(); 
     copy.i = i;
     copy.j = j;
   endfunction

   virtual function AB#(I,J) allocate();
     allocate = new();
   endfunction
  
   virtual function string get_type();
     return "AB";
   endfunction
   `vmm_class_factory(AB#(I,J))
endclass

class typed_gen #(type T=int) extends vmm_xactor;
  `vmm_typename(typed_gen)
   A #(T) a;

   function new(string name);
     super.new(get_typename(), name);
   endfunction

   virtual function void build_ph();
     a = A#(T)::create_instance(this, "A0", `__FILE__, `__LINE__);
     `vmm_note(log, $psprintf("A transaction type is %s", a.get_type()));   
   endfunction
endclass

  
typed_gen#(string) tgen0;
typedef A#(string) A_str;
typedef AB#(string,int) AB_str_i;

class test extends vmm_test;

  AB_str_i ab;
  vmm_log log;
  string got, exp;

  function new(string name);
  super.new(name);
  log = new("t","tst");
  endfunction

  virtual function void build_ph();
  tgen0 = new("tgen0");
  tgen0.build_ph();
  got =  tgen0.a.get_type(); exp="A";
  if(got != exp)
    `vmm_error(log, $psprintf("Factory Mismatch got %s expected %s", got, exp));

  ab = new();
  A_str::override_with_new("@%*", A_str::this_type, log, `__FILE__, `__LINE__);
  tgen0.build_ph();
  got =  tgen0.a.get_type(); exp="A";
  if(got != exp)
    `vmm_error(log, $psprintf("Factory Mismatch got %s expected %s", got, exp));
  
  A_str::override_with_new("@%*", AB_str_i::this_type, log, `__FILE__, `__LINE__);
  tgen0.build_ph();
  got =  tgen0.a.get_type(); exp="AB";
  if(got != exp)
    `vmm_error(log, $psprintf("Factory Mismatch got %s expected %s", got, exp));
  
  AB_str_i::override_with_new("@%*", AB_str_i::this_type, log, `__FILE__, `__LINE__);
  tgen0.build_ph();
  got =  tgen0.a.get_type(); exp="AB";
  if(got != exp)
    `vmm_error(log, $psprintf("Factory Mismatch got %s expected %s", got, exp));
  
endfunction
endclass

initial begin
  test test_inst = new("mytest");
  vmm_simulation::run_tests();
  test_inst.log.report();
end

endprogram

