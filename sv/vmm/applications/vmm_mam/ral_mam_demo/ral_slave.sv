/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`ifndef RAL_SLAVE
`define RAL_SLAVE

`include "vmm_ral.sv"

class ral_reg_slave_CHIP_ID extends vmm_ral_reg;
	rand vmm_ral_field REVISION_ID;
	rand vmm_ral_field CHIP_ID;
	rand vmm_ral_field PRODUCT_ID;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.REVISION_ID = new(this, "REVISION_ID", 8, vmm_ral::RO, 'h03, 8'hx, 0, 0, cvr);
		this.CHIP_ID = new(this, "CHIP_ID", 8, vmm_ral::RO, 'h5A, 8'hx, 8, 0, cvr);
		this.PRODUCT_ID = new(this, "PRODUCT_ID", 10, vmm_ral::RO, 'h176, 10'hx, 16, 0, cvr);
	endfunction: new
endclass : ral_reg_slave_CHIP_ID


class ral_reg_slave_STATUS extends vmm_ral_reg;
	rand vmm_ral_field BUSY;
	rand vmm_ral_field TXEN;
	rand vmm_ral_field READY;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 24, offset, domain, cvr, rights, unmapped);
		this.BUSY = new(this, "BUSY", 1, vmm_ral::RO, 'h0, 1'hx, 0, 0, cvr);
		this.TXEN = new(this, "TXEN", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
		this.READY = new(this, "READY", 1, vmm_ral::W1C, 'h0, 1'hx, 16, 0, cvr);
	endfunction: new
endclass : ral_reg_slave_STATUS


class ral_reg_slave_MASK extends vmm_ral_reg;
	rand vmm_ral_field READY;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 24, offset, domain, cvr, rights, unmapped);
		this.READY = new(this, "READY", 1, vmm_ral::RW, 'h0, 1'hx, 16, 0, cvr);
	endfunction: new
endclass : ral_reg_slave_MASK


class ral_reg_slave_COUNTERS extends vmm_ral_reg;
	rand vmm_ral_field value;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.value = new(this, "value", 32, vmm_ral::RU, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_slave_COUNTERS


class ral_mem_slave_DMA_RAM extends vmm_ral_mem;
	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] base_address, string domain, int cvr,
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, vmm_ral::RW, `VMM_RAL_ADDR_WIDTH'h400, 32, base_address, domain, cvr, rights, unmapped);
	endfunction: new
endclass : ral_mem_slave_DMA_RAM


class ral_block_slave extends vmm_ral_block;
	rand ral_reg_slave_CHIP_ID CHIP_ID;
	rand ral_reg_slave_STATUS STATUS;
	rand ral_reg_slave_MASK MASK;
	rand ral_reg_slave_COUNTERS COUNTERS[256];
	rand ral_mem_slave_DMA_RAM DMA_RAM;
	rand vmm_ral_field CHIP_ID_REVISION_ID;
	rand vmm_ral_field REVISION_ID;
	rand vmm_ral_field CHIP_ID_CHIP_ID;
	rand vmm_ral_field CHIP_ID_PRODUCT_ID;
	rand vmm_ral_field PRODUCT_ID;
	rand vmm_ral_field STATUS_BUSY;
	rand vmm_ral_field BUSY;
	rand vmm_ral_field STATUS_TXEN;
	rand vmm_ral_field TXEN;
	rand vmm_ral_field STATUS_READY;
	rand vmm_ral_field MASK_READY;
	rand vmm_ral_field COUNTERS_value[256];
	rand vmm_ral_field value[256];

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "slave", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "slave", 4, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on);
		this.CHIP_ID = new(this, "CHIP_ID", `VMM_RAL_ADDR_WIDTH'h0, "", cover_on, 2'b11, 0);
		this.CHIP_ID_REVISION_ID = this.CHIP_ID.REVISION_ID;
		this.REVISION_ID = this.CHIP_ID.REVISION_ID;
		this.CHIP_ID_CHIP_ID = this.CHIP_ID.CHIP_ID;
		this.CHIP_ID_PRODUCT_ID = this.CHIP_ID.PRODUCT_ID;
		this.PRODUCT_ID = this.CHIP_ID.PRODUCT_ID;
		this.STATUS = new(this, "STATUS", `VMM_RAL_ADDR_WIDTH'h4, "", cover_on, 2'b11, 0);
		this.STATUS_BUSY = this.STATUS.BUSY;
		this.BUSY = this.STATUS.BUSY;
		this.STATUS_TXEN = this.STATUS.TXEN;
		this.TXEN = this.STATUS.TXEN;
		this.STATUS_READY = this.STATUS.READY;
		this.MASK = new(this, "MASK", `VMM_RAL_ADDR_WIDTH'h5, "", cover_on, 2'b11, 0);
		this.MASK_READY = this.MASK.READY;
		foreach (this.COUNTERS[i]) begin
			int J = i;
			this.COUNTERS[J] = new(this, $psprintf("COUNTERS[%0d]",J), `VMM_RAL_ADDR_WIDTH'h400+J*`VMM_RAL_ADDR_WIDTH'h1, "", cover_on, 2'b11, 0);
			this.COUNTERS_value[J] = this.COUNTERS[J].value;
			this.value[J] = this.COUNTERS[J].value;
		end
		this.DMA_RAM = new(this, "DMA_RAM", `VMM_RAL_ADDR_WIDTH'h800, "", cover_on, 2'b11, 0);
		this.Xlock_modelX();
	endfunction : new
endclass : ral_block_slave


`endif
