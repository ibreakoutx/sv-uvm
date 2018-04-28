`ifndef RAL_DROPSYS
`define RAL_DROPSYS

`include "vmm_ral.sv"

class ral_reg_dropbox_l_rw0 extends vmm_ral_reg;
	rand vmm_ral_field value;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 8, offset, domain, cvr, rights, unmapped, vmm_ral::NO_COVERAGE);
`ifdef VMM_11
		this.value = new(this, "value", 8, vmm_ral::RW, 8'h0, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr);
`else
		this.value = new(this, "value", 8, vmm_ral::RW, 8'h0, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr, 1);
`endif
	endfunction: new
endclass : ral_reg_dropbox_l_rw0


class ral_reg_dropbox_l_wo0 extends vmm_ral_reg;
	rand vmm_ral_field value;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 8, offset, domain, cvr, rights, unmapped, vmm_ral::NO_COVERAGE);
`ifdef VMM_11
		this.value = new(this, "value", 8, vmm_ral::WO, 8'hA5, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr);
`else
		this.value = new(this, "value", 8, vmm_ral::WO, 8'hA5, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr, 1);
`endif
	endfunction: new
endclass : ral_reg_dropbox_l_wo0


class ral_reg_dropbox_wide extends vmm_ral_reg;
	rand vmm_ral_field wide_f1;
	rand vmm_ral_field wide_f2;
	rand vmm_ral_field wide_f3;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 48, offset, domain, cvr, rights, unmapped, vmm_ral::NO_COVERAGE);
`ifdef VMM_11
		this.wide_f1 = new(this, "wide_f1", 8, vmm_ral::RW, 8'h54, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr);
`else
		this.wide_f1 = new(this, "wide_f1", 8, vmm_ral::RW, 8'h54, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr, 1);
`endif
`ifdef VMM_11
		this.wide_f2 = new(this, "wide_f2", 32, vmm_ral::RW, 32'hDCBA_9876, `VMM_RAL_DATA_WIDTH'hx, 8, 0, cvr);
`else
		this.wide_f2 = new(this, "wide_f2", 32, vmm_ral::RW, 32'hDCBA_9876, `VMM_RAL_DATA_WIDTH'hx, 8, 0, cvr, 1);
`endif
`ifdef VMM_11
		this.wide_f3 = new(this, "wide_f3", 8, vmm_ral::RW, 8'hFE, `VMM_RAL_DATA_WIDTH'hx, 40, 0, cvr);
`else
		this.wide_f3 = new(this, "wide_f3", 8, vmm_ral::RW, 8'hFE, `VMM_RAL_DATA_WIDTH'hx, 40, 0, cvr, 1);
`endif
	endfunction: new
endclass : ral_reg_dropbox_wide


class ral_reg_dropbox_l_mbits extends vmm_ral_reg;
	rand vmm_ral_field rcf;
	rand vmm_ral_field w1f;
	vmm_ral_field rof;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 8, offset, domain, cvr, rights, unmapped, vmm_ral::NO_COVERAGE);
`ifdef VMM_11
		this.rcf = new(this, "rcf", 2, vmm_ral::RC, 2'b10, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr);
`else
		this.rcf = new(this, "rcf", 2, vmm_ral::RC, 2'b10, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr, 0);
`endif
`ifdef VMM_11
		this.w1f = new(this, "w1f", 2, vmm_ral::W1C, 2'b10, `VMM_RAL_DATA_WIDTH'hx, 2, 0, cvr);
`else
		this.w1f = new(this, "w1f", 2, vmm_ral::W1C, 2'b10, `VMM_RAL_DATA_WIDTH'hx, 2, 0, cvr, 0);
`endif
`ifdef VMM_11
		this.rof = new(this, "rof", 2, vmm_ral::RO, 2'b10, `VMM_RAL_DATA_WIDTH'hx, 4, 0, cvr);
`else
		this.rof = new(this, "rof", 2, vmm_ral::RO, 2'b10, `VMM_RAL_DATA_WIDTH'hx, 4, 0, cvr, 0);
`endif
	endfunction: new
endclass : ral_reg_dropbox_l_mbits


class ral_reg_dropbox_l_rw_file extends vmm_ral_reg;
	rand vmm_ral_field value;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 8, offset, domain, cvr, rights, unmapped, vmm_ral::NO_COVERAGE);
`ifdef VMM_11
		this.value = new(this, "value", 8, vmm_ral::RW, 8'h0, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr);
`else
		this.value = new(this, "value", 8, vmm_ral::RW, 8'h0, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr, 1);
`endif
	endfunction: new
endclass : ral_reg_dropbox_l_rw_file


class ral_reg_dropbox_l_ro0 extends vmm_ral_reg;
	vmm_ral_field value;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 8, offset, domain, cvr, rights, unmapped, vmm_ral::NO_COVERAGE);
`ifdef VMM_11
		this.value = new(this, "value", 8, vmm_ral::RO, 8'h5C, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr);
`else
		this.value = new(this, "value", 8, vmm_ral::RO, 8'h5C, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr, 1);
`endif
	endfunction: new
endclass : ral_reg_dropbox_l_ro0


class ral_reg_srw0 extends vmm_ral_reg;
	rand vmm_ral_field value;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 8, offset, domain, cvr, rights, unmapped, vmm_ral::NO_COVERAGE);
`ifdef VMM_11
		this.value = new(this, "value", 8, vmm_ral::RW, 8'h0, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr);
`else
		this.value = new(this, "value", 8, vmm_ral::RW, 8'h0, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr, 1);
`endif
	endfunction: new
endclass : ral_reg_srw0


class ral_reg_srw1 extends vmm_ral_reg;
	rand vmm_ral_field value;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 8, offset, domain, cvr, rights, unmapped, vmm_ral::NO_COVERAGE);
`ifdef VMM_11
		this.value = new(this, "value", 8, vmm_ral::RW, 8'h0, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr);
`else
		this.value = new(this, "value", 8, vmm_ral::RW, 8'h0, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr, 1);
`endif
	endfunction: new
endclass : ral_reg_srw1


class ral_mem_dropbox_l_mem0 extends vmm_ral_mem;
	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] base_address, string domain, int cvr,
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, vmm_ral::RW, `VMM_RAL_ADDR_WIDTH'h100, 16, base_address, domain, cvr, rights, unmapped, vmm_ral::NO_COVERAGE);
	endfunction: new
endclass : ral_mem_dropbox_l_mem0


class ral_mem_smem0 extends vmm_ral_mem;
	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] base_address, string domain, int cvr,
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, vmm_ral::RW, `VMM_RAL_ADDR_WIDTH'h100, 16, base_address, domain, cvr, rights, unmapped, vmm_ral::NO_COVERAGE);
	endfunction: new
endclass : ral_mem_smem0


class ral_mem_smem1 extends vmm_ral_mem;
	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] base_address, string domain, int cvr,
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, vmm_ral::RW, `VMM_RAL_ADDR_WIDTH'h100, 16, base_address, domain, cvr, rights, unmapped, vmm_ral::NO_COVERAGE);
	endfunction: new
endclass : ral_mem_smem1


class ral_reg_dropbox_r_rw0 extends vmm_ral_reg;
	rand vmm_ral_field value;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 8, offset, domain, cvr, rights, unmapped, vmm_ral::NO_COVERAGE);
`ifdef VMM_11
		this.value = new(this, "value", 8, vmm_ral::RW, 8'h0, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr);
`else
		this.value = new(this, "value", 8, vmm_ral::RW, 8'h0, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr, 1);
`endif
	endfunction: new
endclass : ral_reg_dropbox_r_rw0


class ral_reg_dropbox_r_wo0 extends vmm_ral_reg;
	rand vmm_ral_field value;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 8, offset, domain, cvr, rights, unmapped, vmm_ral::NO_COVERAGE);
`ifdef VMM_11
		this.value = new(this, "value", 8, vmm_ral::WO, 8'hA5, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr);
`else
		this.value = new(this, "value", 8, vmm_ral::WO, 8'hA5, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr, 1);
`endif
	endfunction: new
endclass : ral_reg_dropbox_r_wo0


class ral_mem_dropbox_r_mem0 extends vmm_ral_mem;
	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] base_address, string domain, int cvr,
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, vmm_ral::RW, `VMM_RAL_ADDR_WIDTH'h100, 16, base_address, domain, cvr, rights, unmapped, vmm_ral::NO_COVERAGE);
	endfunction: new
endclass : ral_mem_dropbox_r_mem0


class ral_block_dropbox extends vmm_ral_block;
	rand ral_reg_dropbox_l_rw0 l_rw0;
	rand ral_reg_dropbox_l_wo0 l_wo0;
	rand ral_reg_dropbox_wide wide;
	rand ral_reg_dropbox_l_mbits l_mbits;
	rand ral_reg_dropbox_l_rw_file l_rw_file[4];
	rand ral_reg_dropbox_l_ro0 l_ro0;
	rand ral_reg_srw0 srw0;
	rand ral_reg_srw1 srw1;
	rand ral_mem_dropbox_l_mem0 l_mem0;
	rand ral_mem_smem0 smem0;
	rand ral_mem_smem1 smem1;
	rand ral_reg_dropbox_r_rw0 r_rw0;
	rand ral_reg_dropbox_r_wo0 r_wo0;
	rand ral_mem_dropbox_r_mem0 r_mem0;
	rand vmm_ral_field l_rw0_value;
	rand vmm_ral_field l_wo0_value;
	rand vmm_ral_field wide_wide_f1;
	rand vmm_ral_field wide_f1;
	rand vmm_ral_field wide_wide_f2;
	rand vmm_ral_field wide_f2;
	rand vmm_ral_field wide_wide_f3;
	rand vmm_ral_field wide_f3;
	rand vmm_ral_field l_mbits_rcf;
	rand vmm_ral_field rcf;
	rand vmm_ral_field l_mbits_w1f;
	rand vmm_ral_field w1f;
	vmm_ral_field l_mbits_rof;
	vmm_ral_field rof;
	rand vmm_ral_field l_rw_file_value[4];
	vmm_ral_field l_ro0_value;
	rand vmm_ral_field srw0_value;
	rand vmm_ral_field srw1_value;
	rand vmm_ral_field r_rw0_value;
	rand vmm_ral_field r_wo0_value;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "dropbox", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "dropbox", 2, vmm_ral::LITTLE_ENDIAN, base_addr, "left", cover_on, vmm_ral::NO_COVERAGE);
		this.add_domain(2, vmm_ral::LITTLE_ENDIAN, "right");
		this.l_rw0 = new(this, "l_rw0", `VMM_RAL_ADDR_WIDTH'h1, "left", cover_on, 2'b11, 0);
		this.l_rw0_value = this.l_rw0.value;
		this.l_wo0 = new(this, "l_wo0", `VMM_RAL_ADDR_WIDTH'h2, "left", cover_on, 2'b11, 0);
		this.l_wo0_value = this.l_wo0.value;
		this.wide = new(this, "wide", `VMM_RAL_ADDR_WIDTH'h3, "left", cover_on, 2'b11, 0);
		this.wide_wide_f1 = this.wide.wide_f1;
		this.wide_f1 = this.wide.wide_f1;
		this.wide_wide_f2 = this.wide.wide_f2;
		this.wide_f2 = this.wide.wide_f2;
		this.wide_wide_f3 = this.wide.wide_f3;
		this.wide_f3 = this.wide.wide_f3;
		this.l_mbits = new(this, "l_mbits", `VMM_RAL_ADDR_WIDTH'h6, "left", cover_on, 2'b11, 0);
		this.l_mbits_rcf = this.l_mbits.rcf;
		this.rcf = this.l_mbits.rcf;
		this.l_mbits_w1f = this.l_mbits.w1f;
		this.w1f = this.l_mbits.w1f;
		this.l_mbits_rof = this.l_mbits.rof;
		this.rof = this.l_mbits.rof;
		foreach (this.l_rw_file[i]) begin
			int J = i;
			this.l_rw_file[J] = new(this, $psprintf("l_rw_file[%0d]",J), `VMM_RAL_ADDR_WIDTH'h8+J*`VMM_RAL_ADDR_WIDTH'h1, "left", cover_on, 2'b11, 0);
			this.l_rw_file_value[J] = this.l_rw_file[J].value;
		end
		this.l_ro0 = new(this, "l_ro0", `VMM_RAL_ADDR_WIDTH'hC, "left", cover_on, 2'b11, 0);
		this.l_ro0_value = this.l_ro0.value;
		this.srw0 = new(this, "srw0", `VMM_RAL_ADDR_WIDTH'h10, "left", cover_on, 2'b11, 0);
		this.srw0_value = this.srw0.value;
		this.srw1 = new(this, "srw1", `VMM_RAL_ADDR_WIDTH'h11, "left", cover_on, 2'b01, 0);
		this.srw1_value = this.srw1.value;
		this.l_mem0 = new(this, "l_mem0", `VMM_RAL_ADDR_WIDTH'h100, "left", cover_on, 2'b11, 0);
		this.smem0 = new(this, "smem0", `VMM_RAL_ADDR_WIDTH'h200, "left", cover_on, 2'b11, 0);
		this.smem1 = new(this, "smem1", `VMM_RAL_ADDR_WIDTH'h300, "left", cover_on, 2'b01, 0);
		this.r_rw0 = new(this, "r_rw0", `VMM_RAL_ADDR_WIDTH'h1, "right", cover_on, 2'b11, 0);
		this.r_rw0_value = this.r_rw0.value;
		this.r_wo0 = new(this, "r_wo0", `VMM_RAL_ADDR_WIDTH'h2, "right", cover_on, 2'b11, 0);
		this.r_wo0_value = this.r_wo0.value;
		this.srw0.add_domain(`VMM_RAL_ADDR_WIDTH'h40, "right", 2'b11, 0);
		this.srw1.add_domain(`VMM_RAL_ADDR_WIDTH'h41, "right", 2'b10, 0);
		this.r_mem0 = new(this, "r_mem0", `VMM_RAL_ADDR_WIDTH'h300, "right", cover_on, 2'b11, 0);
		this.smem0.add_domain(`VMM_RAL_ADDR_WIDTH'h100, "right", 2'b11, 0);
		this.smem1.add_domain(`VMM_RAL_ADDR_WIDTH'h200, "right", 2'b10, 0);
		this.Xlock_modelX();
	endfunction : new
endclass : ral_block_dropbox


class ral_sys_dropsys extends vmm_ral_sys;
	rand ral_block_dropbox box0;
	rand ral_block_dropbox box1;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "dropsys", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "dropsys", 2, vmm_ral::LITTLE_ENDIAN, base_addr, "up", cover_on, vmm_ral::NO_COVERAGE);
		this.add_domain(2, vmm_ral::LITTLE_ENDIAN, "down");
		this.box0 = new(cover_on, "box0", this, `VMM_RAL_ADDR_WIDTH'h0);
		this.register_block(this.box0, "left", "up", `VMM_RAL_ADDR_WIDTH'h0);
		this.box1 = new(cover_on, "box1", this, `VMM_RAL_ADDR_WIDTH'h10000);
		this.register_block(this.box1, "left", "up", `VMM_RAL_ADDR_WIDTH'h10000);
		this.register_block(this.box0, "right", "down", `VMM_RAL_ADDR_WIDTH'h0);
		this.register_block(this.box1, "right", "down", `VMM_RAL_ADDR_WIDTH'h10000);
		this.Xlock_modelX();
	endfunction : new
endclass : ral_sys_dropsys


`endif
