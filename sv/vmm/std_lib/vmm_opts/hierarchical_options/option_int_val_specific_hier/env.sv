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
int foo;

function new(string name, vmm_object parent=null);
  bit is_set;
  super.new(parent,name);
  foo = vmm_opts::get_object_int(is_set, this, "FOO", 2, "SET foo value", 0);
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
    c3 = new("c3",this);
    c1 = new("c1",this);
    c2 = new("c2", this);
  endfunction

endclass

D d1;
D d2;
B b2;
C c2;

initial
begin
d1 = new("d1", null);
d2 = new("d2", null);
b2 = new("b2", null);
c2 = new("c2", null);

$display("\nTEST FOR INT OPTION VAL for all \"b1\" objects anywhere under \"d2\" hierarchy only \n");

$display(" Value of foo in d1.b1 is %0d (Expected value 2)", d1.b1.foo);
if(d1.b1.foo != 2) `vmm_error(log, `vmm_sformatf(" Value of foo in d1.b1 is %0d instead of '2' \n",d1.b1.foo));

$display(" Value of foo in d2.b1 is %0d (Expected value 99)", d2.b1.foo);
if(d2.b1.foo != 99) `vmm_error(log, `vmm_sformatf(" Value of foo in d2.b1 is %0d instead of '99' \n",d2.b1.foo));

$display(" Value of foo in d2.c1.b1 is %0d (Expected value 99)", d2.c1.b1.foo);
if(d2.c1.b1.foo != 99) `vmm_error(log, `vmm_sformatf(" Value of foo in d2.c1.b1 is %0d instead of '99' \n",d2.c1.b1.foo));

$display(" Value of foo in d2.c2.b1 is %0d (Expected value 99)", d2.c2.b1.foo);
if(d2.c2.b1.foo != 99) `vmm_error(log, `vmm_sformatf(" Value of foo in d2.c2.b1 is %0d instead of '99' \n",d2.c2.b1.foo));

$display(" Value of foo in d2.c3.b1 is %0d (Expected value 99)", d2.c3.b1.foo);
if(d2.c3.b1.foo != 99) `vmm_error(log, `vmm_sformatf(" Value of foo in d2.c3.b1 is %0d instead of '99' \n",d2.c3.b1.foo));

$display(" Value of foo in b2 is %0d (Expected value 2)", b2.foo);
if(b2.foo != 2) `vmm_error(log, `vmm_sformatf(" Value of foo in b2 is %0d instead of '2' \n",b2.foo));

$display(" Value of foo in c2.b1 is %0d (Expected value 2)", c2.b1.foo);
if(c2.b1.foo != 2) `vmm_error(log, `vmm_sformatf(" Value of foo in c2.b1 is %0d instead of '2' \n",c2.b1.foo));

$display("\n");
log.report();
end
endprogram
