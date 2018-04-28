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
int foo_int;
bit foo_bit;
string foo_str;

function new(string name, vmm_object parent=null);
  bit is_set;
  super.new(parent,name);
  foo_int = vmm_opts::get_object_int(is_set, this, "FOO_INT", 2, "SET foo_int value", 0);
  foo_bit = vmm_opts::get_object_bit(is_set, this, "FOO_BIT", "SET foo_bit value", 0);
  foo_str = vmm_opts::get_object_string(is_set, this, "FOO_STR", "DEF_VAL", "SET foo_str value", 0);

endfunction

endclass

class C extends A;
B b1;

function new(string name, vmm_object parent=null);
  super.new(name,parent);
  b1 = new("b1",this);
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
    a1 = new("a1",this);
    b1 = new("b1",this);
    c3 = new("c",this);
    c1 = new("c1",this);
    c2 = new("c2", this);
  endfunction

endclass

D d2;
B b2;
C c2;

initial
begin
d2 = new("d2", null);
b2 = new("b2", null);
c2 = new("c2", null);

$display("\nTEST FOR INT OPTION VAL for specific hierarchical path only ");

$display(" Value of foo_int in d2.b1 is %0d (Expected value 99)", d2.b1.foo_int);
if(d2.b1.foo_int != 99) `vmm_error(log, `vmm_sformatf(" Value of foo_int in d2.b1 is %0d instead of '99' \n",d2.b1.foo_int));

$display(" Value of foo_int in d2.c1.b1 is %0d (Expected value 2)", d2.c1.b1.foo_int);
if(d2.c1.b1.foo_int != 2) `vmm_error(log, `vmm_sformatf(" Value of foo_int in d2.c1.b1 is %0d instead of '2' \n",d2.c1.b1.foo_int));

$display(" Value of foo_int in d2.c2.b1 is %0d (Expected value 1050)", d2.c2.b1.foo_int);
if(d2.c2.b1.foo_int != 1050) `vmm_error(log, `vmm_sformatf(" Value of foo_int in d2.c2.b1 is %0d instead of '1050' \n",d2.c2.b1.foo_int));


$display(" Value of foo_int in b2 is %0d (Expected value 2)", b2.foo_int);
if(b2.foo_int != 2) `vmm_error(log, `vmm_sformatf(" Value of foo_int in b2 is %0d instead of '2' \n",b2.foo_int));


$display("\nTEST FOR BIT OPTION VAL for specific hierarchical path only ");

$display(" Value of foo_bit in d2.b1 is %0d (Expected value 1)", d2.b1.foo_bit);
if(d2.b1.foo_bit != 1) `vmm_error(log, `vmm_sformatf(" Value of foo_bit in d2.b1 is %0d instead of '1' \n",d2.b1.foo_bit));

$display(" Value of foo_bit in d2.c2.b1 is %0d (Expected value 1)", d2.c2.b1.foo_bit);
if(d2.c2.b1.foo_bit != 1) `vmm_error(log, `vmm_sformatf(" Value of foo_bit in d2.c2.b1 is %0d instead of '1' \n",d2.c2.b1.foo_bit));

$display(" Value of foo_bit in b2 is %0d (Expected value 0)", b2.foo_bit);
if(b2.foo_bit != 0) `vmm_error(log, `vmm_sformatf(" Value of foo_bit in b2 is %0d instead of '0' \n",b2.foo_bit));

$display(" Value of foo_bit in c2.b1 is %0d (Expected value 0)", c2.b1.foo_bit);
if(c2.b1.foo_bit != 0) `vmm_error(log, `vmm_sformatf(" Value of foo_bit in c2.b1 is %0d instead of '0' \n",c2.b1.foo_bit));


$display("\nTest FOR STRING OPTION VAL for specific hierarchical path only ");

$display(" Value of foo_str in d2.b1 is %0s (Expected value \"NEW_VAL\")", d2.b1.foo_str);
if(d2.b1.foo_str != "NEW_VAL1") `vmm_error(log, `vmm_sformatf(" Value of foo_str in d2.b1 is %0s instead of \"NEW_VAL1\" \n",d2.b1.foo_str));

$display(" Value of foo_str in d2.c2.b1 is %0s (Expected value \"NEW_VAL\")", d2.c2.b1.foo_str);
if(d2.c2.b1.foo_str != "NEW_VAL2") `vmm_error(log, `vmm_sformatf(" Value of foo_str in d2.c2.b1 is %0s instead of 'NEW_VAL2' \n",d2.c2.b1.foo_str));

$display(" Value of foo_str in b2 is %0s (Expected value \"DEF_VAL\")", b2.foo_str);
if(b2.foo_str != "DEF_VAL") `vmm_error(log, `vmm_sformatf(" Value of foo_str in b2 is %0s instead of 'DEF_VAL' \n",b2.foo_str));

$display(" Value of foo_str in c2.b1 is %0s (Expected value \"DEF_VAL\")", c2.b1.foo_str);
if(c2.b1.foo_str != "DEF_VAL") `vmm_error(log, `vmm_sformatf(" Value of foo_str in c2.b1 is %0s instead of 'DEF_VAL' \n",c2.b1.foo_str));


$display("\n");
log.report();
end
endprogram
