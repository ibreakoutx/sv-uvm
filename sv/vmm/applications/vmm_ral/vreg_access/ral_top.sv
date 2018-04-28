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

class ral_mem_top_dut_ram1_bkdr extends vmm_ral_mem_backdoor;
	virtual task read(output vmm_rw::status_e status, input bit [`VMM_RAL_ADDR_WIDTH-1:0] offset, 
					output bit [`VMM_RAL_DATA_WIDTH-1:0] data, input int data_id,
					input int scenario_id, input int stream_id);
		data = `TOP_TOP_PATH.dut.vreg[offset];
		status = vmm_rw::IS_OK;
	endtask

	virtual task write(output vmm_rw::status_e status, input bit [`VMM_RAL_ADDR_WIDTH-1:0] offset,
					input bit [`VMM_RAL_DATA_WIDTH-1:0] data, input int data_id, 
					input int scenario_id, input int stream_id);
		`TOP_TOP_PATH.dut.vreg[offset] = data;
		status = vmm_rw::IS_OK;
	endtask
endclass


class ral_mem_ram1 extends vmm_ral_mem;
	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] base_address, string domain, int cvr,
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, vmm_ral::RW, `VMM_RAL_ADDR_WIDTH'h400, 16, base_address, domain, cvr, rights, unmapped, vmm_ral::NO_COVERAGE);
	endfunction: new
endclass : ral_mem_ram1


class ral_vreg_vreg_rw extends vmm_ral_vreg;
	rand vmm_ral_vfield f1;

	function new(vmm_ral_block parent, string name, int unsigned n_bits,
			 bit[`VMM_RAL_ADDR_WIDTH-1:0] offset = `VMM_RAL_ADDR_WIDTH'h0, vmm_ral_mem mem = null, longint unsigned size = 0, int unsigned incr = 0);
		super.new(parent, name, n_bits, offset, mem, size, incr);
		this.f1 = new(this, "f1", 16, 0);
	endfunction: new
endclass : ral_vreg_vreg_rw


class ral_vreg_vreg_ro extends vmm_ral_vreg;
	rand vmm_ral_vfield f1;
	rand vmm_ral_vfield f2;

	function new(vmm_ral_block parent, string name, int unsigned n_bits,
			 bit[`VMM_RAL_ADDR_WIDTH-1:0] offset = `VMM_RAL_ADDR_WIDTH'h0, vmm_ral_mem mem = null, longint unsigned size = 0, int unsigned incr = 0);
		super.new(parent, name, n_bits, offset, mem, size, incr);
		this.f1 = new(this, "f1", 8, 0);
		this.f2 = new(this, "f2", 8, 8);
	endfunction: new
endclass : ral_vreg_vreg_ro


class ral_vreg_vreg_w1c extends vmm_ral_vreg;
	rand vmm_ral_vfield f1;
	rand vmm_ral_vfield f2;

	function new(vmm_ral_block parent, string name, int unsigned n_bits,
			 bit[`VMM_RAL_ADDR_WIDTH-1:0] offset = `VMM_RAL_ADDR_WIDTH'h0, vmm_ral_mem mem = null, longint unsigned size = 0, int unsigned incr = 0);
		super.new(parent, name, n_bits, offset, mem, size, incr);
		this.f1 = new(this, "f1", 8, 0);
		this.f2 = new(this, "f2", 8, 8);
	endfunction: new
endclass : ral_vreg_vreg_w1c


class ral_block_dut extends vmm_ral_block;
	rand ral_mem_ram1 ram1;
	rand ral_vreg_vreg_rw vreg_rw;
	rand ral_vreg_vreg_ro vreg_ro;
	rand ral_vreg_vreg_w1c vreg_w1c;
	rand vmm_ral_vfield vreg_rw_f1;
	rand vmm_ral_vfield vreg_ro_f1;
	rand vmm_ral_vfield vreg_ro_f2;
	rand vmm_ral_vfield vreg_w1c_f1;
	rand vmm_ral_vfield vreg_w1c_f2;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "dut", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "dut", 2, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on, vmm_ral::NO_COVERAGE);
		this.ram1 = new(this, "ram1", `VMM_RAL_ADDR_WIDTH'h0, "", cover_on, 2'b11, 0);
		this.vreg_rw = new(this, "vreg_rw", 16, `VMM_RAL_ADDR_WIDTH'h0, this.ram1, 20, 1);
		this.vreg_rw_f1 = this.vreg_rw.f1;
		this.vreg_ro = new(this, "vreg_ro", 16, `VMM_RAL_ADDR_WIDTH'h100, this.ram1, 3, 1);
		this.vreg_ro_f1 = this.vreg_ro.f1;
		this.vreg_ro_f2 = this.vreg_ro.f2;
		this.vreg_w1c = new(this, "vreg_w1c", 16, `VMM_RAL_ADDR_WIDTH'h200, this.ram1, 5, 1);
		this.vreg_w1c_f1 = this.vreg_w1c.f1;
		this.vreg_w1c_f2 = this.vreg_w1c.f2;
		this.Xlock_modelX();
	endfunction : new
endclass : ral_block_dut


class ral_sys_top extends vmm_ral_sys;
	rand ral_block_dut dut;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "top", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "top", 2, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on, vmm_ral::NO_COVERAGE);
		this.dut = new(cover_on, "dut", this, `VMM_RAL_ADDR_WIDTH'h0);
		this.register_block(this.dut, "", "", `VMM_RAL_ADDR_WIDTH'h0);

		//
		// Setting up backdoor access...
		//
		begin
			ral_mem_top_dut_ram1_bkdr bkdr = new;
			this.dut.ram1.set_backdoor(bkdr);
		end
		this.Xlock_modelX();
	endfunction : new
endclass : ral_sys_top


`endif
