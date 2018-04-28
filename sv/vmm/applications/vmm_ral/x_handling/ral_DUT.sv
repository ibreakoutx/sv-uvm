/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



`ifndef RAL_DUT
`define RAL_DUT

`include "vmm_ral.sv"

class ral_reg_REG extends vmm_ral_reg;
	vmm_ral_field REG_VAL;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 8, offset, domain, cvr, rights, unmapped, vmm_ral::NO_COVERAGE);
`ifdef VMM_11
		this.REG_VAL = new(this, "REG_VAL", 8, vmm_ral::RO, 8'h0, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr);
`else
		this.REG_VAL = new(this, "REG_VAL", 8, vmm_ral::RO, 8'h0, `VMM_RAL_DATA_WIDTH'hx, 0, 0, cvr, 1);
`endif
	endfunction: new
endclass : ral_reg_REG


class ral_block_DUT_BLK extends vmm_ral_block;
	rand ral_reg_REG CTRL_REG;
	rand ral_reg_REG DATA_REG;
	rand ral_reg_REG STATUS_REG;
	vmm_ral_field CTRL_REG_REG_VAL;
	vmm_ral_field DATA_REG_REG_VAL;
	vmm_ral_field STATUS_REG_REG_VAL;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "DUT_BLK", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "DUT_BLK", 1, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on, vmm_ral::NO_COVERAGE);
		this.CTRL_REG = new(this, "CTRL_REG", `VMM_RAL_ADDR_WIDTH'h0, "", cover_on, 2'b11, 0);
		this.CTRL_REG_REG_VAL = this.CTRL_REG.REG_VAL;
		this.DATA_REG = new(this, "DATA_REG", `VMM_RAL_ADDR_WIDTH'h1, "", cover_on, 2'b11, 0);
		this.DATA_REG_REG_VAL = this.DATA_REG.REG_VAL;
		this.STATUS_REG = new(this, "STATUS_REG", `VMM_RAL_ADDR_WIDTH'h2, "", cover_on, 2'b11, 0);
		this.STATUS_REG_REG_VAL = this.STATUS_REG.REG_VAL;
		this.Xlock_modelX();
	endfunction : new
endclass : ral_block_DUT_BLK


class ral_sys_DUT extends vmm_ral_sys;
	rand ral_block_DUT_BLK DUT_BLK;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "DUT", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "DUT", 1, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on, vmm_ral::NO_COVERAGE);
		this.DUT_BLK = new(cover_on, "DUT_BLK", this, `VMM_RAL_ADDR_WIDTH'h0);
		this.register_block(this.DUT_BLK, "", "", `VMM_RAL_ADDR_WIDTH'h0);
		this.Xlock_modelX();
	endfunction : new
endclass : ral_sys_DUT


`endif
