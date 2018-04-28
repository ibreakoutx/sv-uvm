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

class basic;
	int j =1;
endclass

class myclass ;
	`vmm_typename(myclass);
	basic basic_inst ;
	int i =0;

	function new;
	basic_inst = new();
	endfunction

	virtual task mytask;
		i = 1;
	endtask

	virtual function myclass copy();
	myclass tr = new();
		tr.i = this.i;
		tr.basic_inst = new this.basic_inst;
		return tr;
	endfunction

	vmm_log myclslog = new("mycls","mycls");
	virtual function myclass allocate();
		allocate = new();//this.get_object_name(), get_parent_object());
	endfunction

	`vmm_class_factory(myclass);
endclass

class ext extends myclass;
`vmm_typename(ext)
vmm_log ext_log = new("ext","ext");

	function new();
	super.new();
	super.i = 1;
	endfunction

task mytask;
i = 3;
endtask

	virtual function ext copy();
	ext tr = new();
	tr.i = this.i;
	tr.basic_inst = new this.basic_inst;
	return tr;
	endfunction


	virtual function ext allocate();
	allocate = new();//this.get_object_name(), get_parent_object());
	endfunction


`vmm_class_factory(ext);
endclass

class gen extends vmm_xactor;
`vmm_typename(gen)
	myclass tr;
	vmm_log log = new("cl","cl");

	virtual function void build_ph();
	tr = myclass::create_instance(this,"mydummyclass", `__FILE__,`__LINE__);
	tr.mytask;
	if(!((tr.i== 3) && (tr.basic_inst.j == 5)))
	`vmm_error(log,"ERROR");
	endfunction

	function new (string name);
	super.new(get_typename(), name);
	endfunction

endclass


class env extends vmm_group;
`vmm_typename(env)
gen gen0 ;
gen gen1 ;
gen gen2 ;
gen gen3 ;
gen gen4 ;

function new(string name);
super.new(get_typename(), name);
gen0 = new("gen0");
gen1 = new("gen0");
gen2 = new("gen0");
gen3 = new("gen0");
gen4 = new("gen0");
endfunction
vmm_log log1 = new("cl1","cl1");

virtual function void build_ph();
ext ext0 = new();
ext ext1 = new();
ext ext2 = new();
ext ext3 = new();
ext ext4 = new();

ext0.basic_inst.j = 5;
ext1.basic_inst.j = 5;
ext2.basic_inst.j = 5;
ext3.basic_inst.j = 5;
ext4.basic_inst.j = 5;

myclass::override_with_copy("@%*",ext0,log1,`__FILE__, `__LINE__);
gen0.build_ph();
myclass::override_with_copy("@%*",ext1,log1,`__FILE__, `__LINE__);
gen1.build_ph();
myclass::override_with_copy("@%*",ext2,log1,`__FILE__, `__LINE__);
gen2.build_ph();
myclass::override_with_copy("@%*",ext3,log1,`__FILE__, `__LINE__);
gen3.build_ph();
myclass::override_with_copy("@%*",ext4,log1,`__FILE__, `__LINE__);
gen4.build_ph();
log1.report();
endfunction

endclass


initial
begin
env env10= new("env");
env10.build_ph();
end

endprogram
