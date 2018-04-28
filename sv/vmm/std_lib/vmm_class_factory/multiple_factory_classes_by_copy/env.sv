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

class foo;
   int i;
   static vmm_log log = new("foo", "foo");

   virtual function foo copy();
     copy = new(); copy.i = i;
   endfunction

   virtual function foo allocate();
     allocate = new();
   endfunction
  
   virtual function string get_type();
     return "foo";
   endfunction

   `vmm_class_factory(foo)
endclass

class fubar extends foo;
   static vmm_log log = new("fubar", "fubar");
   virtual function foo copy();
     fubar cpy = new();
     cpy.i = this.i;
     return cpy;
   endfunction

   virtual function foo allocate();
     fubar tr = new();
     return tr;
   endfunction
  
   virtual function string get_type();
     return "fubar";
   endfunction

   `vmm_class_factory(fubar)
endclass

class bing extends fubar;
   static vmm_log log = new("bing", "bing");

   virtual function foo copy();
     bing cpy = new();
     cpy.i = this.i;
     return cpy;
   endfunction

   virtual function foo allocate();
     bing tr = new();
     return tr;
   endfunction
  
   virtual function string get_type();
     return "bing";
   endfunction

   `vmm_class_factory(bing)
endclass

class gen extends vmm_unit;
`vmm_typename(gen)
   foo tr;

   function new(string name);
     super.new(get_typename(), name);
   endfunction

   virtual function void build_ph();
     tr = foo::create_instance(this, "Ahb_Tr0", `__FILE__, `__LINE__);
     `vmm_note(log, $psprintf("FOO transaction type is %s", tr.get_type()));   
   endfunction
endclass

initial begin
  vmm_log log;
  gen gen0;
  string got, exp;
  foo f = new; 
  fubar fb = new; 
  bing bi = new; 
  log = new("Env", "Env0");

  gen0 = new("gen0");
  gen0.build_ph();
  got =  gen0.tr.get_type(); exp="foo";
  if(got != exp)
    `vmm_error(log, $psprintf("Factory Mismatch got %s expected %s", got, exp));

  foo::override_with_new("@%*", fubar::this_type, log, `__FILE__, `__LINE__);
  gen0.build_ph();
  got =  gen0.tr.get_type(); exp="fubar";
  if(got != exp)
    `vmm_error(log, $psprintf("Factory Mismatch got %s expected %s", got, exp));

  bi.i = 20;
  foo::override_with_copy("@%*", bi, log, `__FILE__, `__LINE__);
  gen0.build_ph();
  got =  gen0.tr.get_type(); exp="bing";
  if(got != exp)
    `vmm_error(log, $psprintf("Factory Mismatch got %s expected %s", got, exp));

  foo::override_with_new("@%*", foo::this_type, log, `__FILE__, `__LINE__);
  gen0.build_ph();
  got =  gen0.tr.get_type(); exp="foo";
  if(got != exp)
    `vmm_error(log, $psprintf("Factory Mismatch got %s expected %s", got, exp));

  log.report();

end

endprogram

