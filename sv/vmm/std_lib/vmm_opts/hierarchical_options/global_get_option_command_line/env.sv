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

vmm_log log = new("prgm", "prgm");

class A extends vmm_object;
function new(string name, vmm_object parent=null);
  super.new(parent,name);
endfunction
endclass


class B extends vmm_object;
int foo_int=2;
bit foo_bit;
string foo_str = "INIT_VAL";

function new(string name, vmm_object parent=null);
  super.new(parent,name);
  foo_int = vmm_opts::get_int("FOO_INT", 0, "SET foo value", 0);
  foo_bit = vmm_opts::get_bit("FOO_BIT", "SET foo value", 0);
  foo_str = vmm_opts::get_string("FOO_STR", "DEF_VAL", "SET foo value", 0);
endfunction

endclass

class C extends A;
B b1;

function new(string name, vmm_object parent=null);
  super.new(name,parent);
  b1 = new("b1_obj_C",this);
endfunction
endclass

class D extends vmm_object;
  A a1;
  B b1;
  C c1;
  C c2;
  C c3;
  
  function new(string name, vmm_object parent=null);
  super.new(parent,name);
    a1 = new("a1_obj",this);
    b1 = new("b1_obj_D",this);
    c3 = new("c",this);
    c1 = new("c1_obj",this);
    c2 = new("c2_obj");
  endfunction

endclass

D d2;
B b2;
C c2;

initial
begin
d2 = new("d2_obj", null);
b2 = new("b2_obj", null);
c2 = new("c2_obj", null);

$display("\nCheck for int option globally");
$display(" Value of foo_int in d2.b1 is %0d (Expected value 99)", d2.b1.foo_int);
if(d2.b1.foo_int != 99) `vmm_error(log, `vmm_sformatf(" Value of foo_int in d2.b1 is %0d instead of '99' \n",d2.b1.foo_int));

$display(" Value of foo_int in d2.c2.b1 is %0d (Expected value 99)", d2.c2.b1.foo_int);
if(d2.c2.b1.foo_int != 99) `vmm_error(log, `vmm_sformatf(" Value of foo_int in d2.c2.b1 is %0d instead of '99' \n",d2.c2.b1.foo_int));

$display(" Value of foo_int in b2 is %0d (Expected value 99)", b2.foo_int);
if(b2.foo_int != 99) `vmm_error(log, `vmm_sformatf(" Value of foo_int in b2 is %0d instead of '99' \n",b2.foo_int));



$display("\nCheck for string option globally");

$display(" Value of foo_str in d2.b1 is %0s (Expected value \"NEW_VAL\")", d2.b1.foo_str);
if(d2.b1.foo_str != "NEW_VAL") `vmm_error(log, `vmm_sformatf(" Value of foo_str in d2.b1 is %0s instead of 'NEW_VAL' \n",d2.b1.foo_str));

$display(" Value of foo_str in d2.c1.b1 is %0s (Expected value \"NEW_VAL\")", d2.c1.b1.foo_str);
if(d2.c1.b1.foo_str != "NEW_VAL") `vmm_error(log, `vmm_sformatf(" Value of foo_str in d2.c1.b1 is %0s instead of 'NEW_VAL' \n",d2.c1.b1.foo_str));

$display(" Value of foo_str in b2 is %0s (Expected value \"NEW_VAL\")", b2.foo_str);
if(b2.foo_str != "NEW_VAL") `vmm_error(log, `vmm_sformatf(" Value of foo_str in b2 is %0s instead of 'NEW_VAL' \n",b2.foo_str));


$display("\nCheck for bit option globally");

$display(" Value of foo_bit in d2.c1.b1 is %0d (Expected value 1)", d2.c1.b1.foo_bit);
if(d2.c1.b1.foo_bit != 1) `vmm_error(log, `vmm_sformatf(" Value of foo_bit in d2.c1.b1 is %0d instead of '1' \n",d2.c1.b1.foo_bit));

$display(" Value of foo_bit in d2.c2.b1 is %0d (Expected value 1)", d2.c2.b1.foo_bit);
if(d2.c2.b1.foo_bit != 1) `vmm_error(log, `vmm_sformatf(" Value of foo_bit in d2.c2.b1 is %0d instead of '1' \n",d2.c2.b1.foo_bit));

$display(" Value of foo_bit in d2.c3.b1 is %0d (Expected value 1)", d2.c3.b1.foo_bit);
if(d2.c3.b1.foo_bit != 1) `vmm_error(log, `vmm_sformatf(" Value of foo_bit in d2.c3.b1 is %0d instead of '1' \n",d2.c3.b1.foo_bit));


$display("\n");
log.report();
end
endprogram
