`ifndef RAL_B
`define RAL_B

import uvm_pkg::*;

class ral_reg_B_R extends uvm_reg;
	rand uvm_reg_field F;

	function new(string name = "B_R");
		super.new(name, 8,UVM_NO_COVERAGE);
	endfunction: new
   virtual function void build();
      this.F = uvm_reg_field::type_id::create("F");
      this.F.configure(this, 8, 0, "RW", 0, 8'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_B_R)

endclass : ral_reg_B_R


class ral_reg_B_CTL extends uvm_reg;
	rand uvm_reg_field CTL;

	function new(string name = "B_CTL");
		super.new(name, 8,UVM_NO_COVERAGE);
	endfunction: new
   virtual function void build();
      this.CTL = uvm_reg_field::type_id::create("CTL");
      this.CTL.configure(this, 2, 0, "WO", 0, 2'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_B_CTL)

endclass : ral_reg_B_CTL


class ral_block_B extends uvm_reg_block;
	rand ral_reg_B_R R;
	rand ral_reg_B_CTL CTL;
	rand uvm_reg_field R_F;
	rand uvm_reg_field F;
	rand uvm_reg_field CTL_CTL;

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
      this.CTL = ral_reg_B_CTL::type_id::create("CTL");
      this.CTL.build();
      this.CTL.configure(this, null, "");
      this.default_map.add_reg(this.CTL, `UVM_REG_ADDR_WIDTH'h1, "RW", 0);
		this.CTL_CTL = this.CTL.CTL;
		this.lock_model();
	endfunction : build

	`uvm_object_utils(ral_block_B)

endclass : ral_block_B



`endif
