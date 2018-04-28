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


program p;
`include "vmm.sv"

class myclass;
	`vmm_typename(myclass);
	vmm_log myclslog = new("mycls","mycls");
	int i =0;
	virtual function myclass copy();
		myclass tr = new();
		tr.i = this.i;
		return tr;
	endfunction

	virtual function myclass allocate();
		allocate = new();//this.get_object_name(), get_parent_object());
	endfunction

`vmm_class_factory(myclass);

endclass

class myclass_new;
`vmm_typename(myclass_new);
int i =0;
vmm_log myclslog = new("mycls","mycls");
	virtual function myclass_new copy();
		myclass_new tr = new();
		tr.i = this.i;
		return tr;
	endfunction

	virtual function myclass_new allocate();
		allocate = new();//this.get_object_name(), get_parent_object());
	endfunction

`vmm_class_factory(myclass_new);
endclass

class myclass_new_ext extends myclass_new;
`vmm_typename(myclass_new_ext);

	function new();
		i = 5;
	endfunction

	virtual function myclass_new_ext copy();
		myclass_new_ext tr = new();
		tr.i = this.i;
		return tr;
	endfunction

	vmm_log myclslog = new("mycls_new_ext","mycls_new_ext");
	virtual function myclass_new_ext allocate();
		allocate = new();//this.get_object_name(), get_parent_object());
	endfunction

`vmm_class_factory(myclass_new_ext);
endclass



class ext extends myclass;
`vmm_typename(ext)
vmm_log ext_log = new("ext","ext");
	function new();
		super.new();
		super.i = 1;
	endfunction

	virtual function ext copy();
		ext tr = new();
		tr.i = this.i;
		return tr;
	endfunction


	virtual function ext allocate();
		allocate = new();//this.get_object_name(), get_parent_object());
	endfunction

`vmm_class_factory(ext);
endclass

class ext1 extends ext;
`vmm_typename(ext1)
vmm_log ext1_log = new("ext1","ext1");
	function new();
		super.new();
		super.i = 2;
	endfunction

	virtual function ext1 copy();
		ext1 tr = new();
		tr.i = this.i;
		return tr;
	endfunction


	virtual function ext1 allocate();
		allocate = new();//this.get_object_name(), get_parent_object());
	endfunction


	`vmm_class_factory(ext1);
endclass

class gen extends vmm_xactor;
`vmm_typename(gen)
myclass tr;
myclass_new tr1[1:0];
myclass_new tr2;
vmm_log log = new("cl","cl");

virtual function void build_ph();
	tr = myclass::create_instance(this,"mydummyclass", `__FILE__,`__LINE__);
	tr1[1] = myclass_new::create_instance(this,"myclass_new", `__FILE__,`__LINE__);
	tr2 = myclass_new::create_instance(this,"myclass_new", `__FILE__,`__LINE__);
//	`vmm_note(log,$psprintf("new Transction type is **** %d %s", tr.i,tr.get_typename()));
if(!((tr.i == 1) && (tr.get_typename() == "class p.ext")))
`vmm_error(log,"ERROR1");

//	`vmm_note(log,$psprintf("newclass Transction type is **** %d %s", tr1[1].i,tr1[1].get_typename()));
if(!((tr1[1].i == 5) && (tr1[1].get_typename() == "class p.myclass_new_ext")))
`vmm_error(log,"ERROR2");
//	`vmm_note(log,$psprintf("newclass Transction type is **** %d %s", tr2.i,tr2.get_typename()));
if(!((tr2.i == 5) && (tr2.get_typename() == "class p.myclass_new_ext")))
`vmm_error(log,"ERROR3");
endfunction

	function new (string name);
		super.new(get_typename(), name);
	endfunction

endclass

class gen1 extends vmm_xactor;
	`vmm_typename(gen)
	myclass tr;
	vmm_log log = new("cl","cl");

	virtual function void build_ph();
		tr = ext::create_instance(this,"ext", `__FILE__,`__LINE__);
//		`vmm_note(log,$psprintf("new Transction type is **** %d %s", tr.i,tr.get_typename()));
if(!((tr.i == 2) && (tr.get_typename() == "class p.ext1")))
`vmm_error(log,"ERROR");

	endfunction

	function new (string name);
		super.new(get_typename(), name);
	endfunction

endclass


class test extends vmm_test;
vmm_log log1;

function new(string name); 
super.new(name);
log1 = new("cl1","cl1");
endfunction

virtual function void build_ph();
gen gen0 = new("gen0");
gen1 gen10 = new("gen10");
ext ext_inst[1:0];
ext1 ext1 = new();
ext_inst[0] = new();
ext_inst[1] = new();
myclass::override_with_copy("@%*",ext_inst[0],log1,`__FILE__, `__LINE__);
myclass_new::override_with_new("@%*",myclass_new_ext::this_type,log1,`__FILE__, `__LINE__);
gen0.build_ph();

ext::override_with_copy("@%*",ext1,log1,`__FILE__, `__LINE__);
gen10.build_ph();
endfunction
endclass

initial
begin
 test test_inst = new("mytest");
 vmm_simulation::run_tests();
 test_inst.log1.report();
end

endprogram
