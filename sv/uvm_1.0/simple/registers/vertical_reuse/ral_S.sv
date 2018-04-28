`ifndef RAL_S
`define RAL_S

import uvm_pkg::*;

class ral_reg_B_R extends uvm_reg;
	rand uvm_reg_field F;

	function new(string name = "B_R");
		super.new(name, 8,UVM_NO_COVERAGE);
	endfunction: new
   virtual function void build();
      this.F = uvm_reg_field::type_id::create("F");
      this.F.configure(this, 1, 0, "RW", 0, 1'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_B_R)

endclass : ral_reg_B_R


class ral_block_B extends uvm_reg_block;
	rand ral_reg_B_R R;
	rand uvm_reg_field R_F;
	rand uvm_reg_field F;

	function new(string name = "B");
		super.new(name, build_coverage(UVM_NO_COVERAGE));
	endfunction: new

   virtual function void build();
      this.default_map = create_map("", 0, 1, UVM_LITTLE_ENDIAN);
      this.R = ral_reg_B_R::type_id::create("R");
      this.R.build();
      this.R.configure(this, null, "");
      this.default_map.add_reg(this.R, `UVM_REG_ADDR_WIDTH'h0, "RW", 0);
		this.R_F = this.R.F;
		this.F = this.R.F;
		this.lock_model();
	endfunction : build

	`uvm_object_utils(ral_block_B)

endclass : ral_block_B


class ral_sys_S extends uvm_reg_block;

   rand ral_block_B B[2];

	function new(string name = "S");
		super.new(name);
	endfunction: new

	function void build();
      this.default_map = create_map("", 0, 1, UVM_LITTLE_ENDIAN);
      foreach (this.B[i]) begin
         int J = i;
         this.B[J] = ral_block_B::type_id::create($psprintf("B[%0d]", J));
         this.B[J].configure(this, "");
         this.B[J].build();
         this.default_map.add_submap(this.B[J].default_map, `UVM_REG_ADDR_WIDTH'h100+J*`UVM_REG_ADDR_WIDTH'h100);
      end
		this.lock_model();
	endfunction : build

	`uvm_object_utils(ral_sys_S)
endclass : ral_sys_S



`endif
