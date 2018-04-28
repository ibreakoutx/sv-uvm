/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



`ifndef RAL_TOP
`define RAL_TOP

`include "vmm_ral.sv"

class ral_mem_ram1 extends vmm_ral_mem;
	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] base_address, string domain, int cvr,
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, vmm_ral::RW, `VMM_RAL_ADDR_WIDTH'h400, 8, base_address, domain, cvr, rights, unmapped, vmm_ral::NO_COVERAGE);
	endfunction: new
endclass : ral_mem_ram1


class ral_reg_dut_reg1 extends vmm_ral_reg;
	rand vmm_ral_field f1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 16, offset, domain, cvr, rights, unmapped, vmm_ral::NO_COVERAGE);
`ifdef VMM_11
		this.f1 = new(this, "f1", 16, vmm_ral::RW, 16'h0, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr);
`else
		this.f1 = new(this, "f1", 16, vmm_ral::RW, 16'h0, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr, 1);
`endif
	endfunction: new
endclass : ral_reg_dut_reg1


class ral_vreg_vreg extends vmm_ral_vreg;
	rand vmm_ral_vfield f1;
	rand vmm_ral_vfield f2;
	rand vmm_ral_vfield f3;

	function new(vmm_ral_block parent, string name, int unsigned n_bits,
			 bit[`VMM_RAL_ADDR_WIDTH-1:0] offset = `VMM_RAL_ADDR_WIDTH'h0, vmm_ral_mem mem = null, longint unsigned size = 0, int unsigned incr = 0);
		super.new(parent, name, n_bits, offset, mem, size, incr);
		this.f1 = new(this, "f1", 4, 0);
		this.f2 = new(this, "f2", 4, 4);
		this.f3 = new(this, "f3", 8, 8);
	endfunction: new
endclass : ral_vreg_vreg


class ral_block_dut extends vmm_ral_block;
	rand ral_mem_ram1 ram1;
	rand ral_reg_dut_reg1 reg1;
	rand ral_vreg_vreg vreg1;
	rand ral_vreg_vreg vreg2;
	rand ral_vreg_vreg vreg3;
	rand vmm_ral_field reg1_f1;
	rand vmm_ral_vfield vreg1_f1;
	rand vmm_ral_vfield vreg1_f2;
	rand vmm_ral_vfield vreg1_f3;
	rand vmm_ral_vfield vreg2_f1;
	rand vmm_ral_vfield vreg2_f2;
	rand vmm_ral_vfield vreg2_f3;
	rand vmm_ral_vfield vreg3_f1;
	rand vmm_ral_vfield vreg3_f2;
	rand vmm_ral_vfield vreg3_f3;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "dut", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "dut", 2, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on, vmm_ral::NO_COVERAGE);
		this.ram1 = new(this, "ram1", `VMM_RAL_ADDR_WIDTH'h0, "", cover_on, 2'b11, 0);
		this.reg1 = new(this, "reg1", `VMM_RAL_ADDR_WIDTH'h100, "", cover_on, 2'b11, 0);
		this.reg1_f1 = this.reg1.f1;
		this.vreg1 = new(this, "vreg1", 16, `VMM_RAL_ADDR_WIDTH'h10, this.ram1, 5, 2);
		this.vreg1_f1 = this.vreg1.f1;
		this.vreg1_f2 = this.vreg1.f2;
		this.vreg1_f3 = this.vreg1.f3;
		this.vreg2 = new(this, "vreg2", 16);
		this.vreg2_f1 = this.vreg2.f1;
		this.vreg2_f2 = this.vreg2.f2;
		this.vreg2_f3 = this.vreg2.f3;
		this.vreg3 = new(this, "vreg3", 16);
		this.vreg3_f1 = this.vreg3.f1;
		this.vreg3_f2 = this.vreg3.f2;
		this.vreg3_f3 = this.vreg3.f3;
		this.Xlock_modelX();
	endfunction : new
endclass : ral_block_dut


class ral_sys_top extends vmm_ral_sys;
	rand ral_block_dut dut;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "top", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "top", 2, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on, vmm_ral::NO_COVERAGE);
		this.dut = new(cover_on, "dut", this, `VMM_RAL_ADDR_WIDTH'h0);
		this.register_block(this.dut, "", "", `VMM_RAL_ADDR_WIDTH'h0);
		this.Xlock_modelX();
	endfunction : new
endclass : ral_sys_top


`endif
