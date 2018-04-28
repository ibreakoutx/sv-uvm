`ifndef __DPI_TASKS_SV_H__
`define __DPI_TASKS_SV_H__

`ifndef VMM_RAL_C_INT_WIDTH
`define VMM_RAL_C_INT_WIDTH 32
`endif

`define VMM_RAL_C_DATA_SIZE ((`VMM_RAL_DATA_WIDTH-1)/(`VMM_RAL_C_INT_WIDTH)+1)


import "DPI-C" context task cmain(int unsigned ral_model_ID);


export "DPI-C" function vmm_ral_sys__get_subsys_by_name;
function int unsigned vmm_ral_sys__get_subsys_by_name(int unsigned sys_id,
                                                    string      name,
                                                    int         idx);
   vmm_ral_sys subsys;
   vmm_ral_sys sys;
   sys = vmm_ral_get_sys_by_ID(sys_id);
   assert (sys != null);
   subsys = sys.get_subsys_by_name(name);
   vmm_ral_sys__get_subsys_by_name = subsys.get_sys_ID();
endfunction

export "DPI-C" function vmm_ral_sys__get_block_by_name;
function int unsigned vmm_ral_sys__get_block_by_name(int unsigned sys_id,
                                                    string      name,
                                                    int         idx);
   vmm_ral_block blk;
   vmm_ral_sys sys;
   sys = vmm_ral_get_sys_by_ID(sys_id);
   assert (sys != null);
   blk = sys.get_block_by_name(name);
   vmm_ral_sys__get_block_by_name = blk.get_block_ID();
endfunction

export "DPI-C" function vmm_ral_block_or_sys__get_reg_by_name;
function int unsigned vmm_ral_block_or_sys__get_reg_by_name(int unsigned blk_or_sys_id,
                                                           string               name,
                                                           int                  idx);
   vmm_ral_reg rg;
   vmm_ral_block_or_sys blk_or_sys;
   blk_or_sys = vmm_ral_get_block_or_sys_by_ID(blk_or_sys_id);
   assert(blk_or_sys != null);

   rg = blk_or_sys.get_reg_by_name(name);
   vmm_ral_block_or_sys__get_reg_by_name = rg.get_reg_ID();
endfunction

export "DPI-C" function vmm_ral_reg__get_fullname;
function string vmm_ral_reg__get_fullname(int unsigned reg_id);
   vmm_ral_reg rg;
   rg = vmm_ral_get_reg_by_ID(reg_id);
   assert(rg != null);
   vmm_ral_reg__get_fullname = rg.get_fullname();
endfunction

export "DPI-C" task vmm_ral_reg__read;
task vmm_ral_reg__read(input  int unsigned reg_id,
                       output int         status,
                       output int         v [`VMM_RAL_C_DATA_SIZE],
                       input  int         i,
                       input  int         j);
   bit [`VMM_RAL_DATA_WIDTH-1:0] bits;
   int k;
   vmm_ral_reg rg;
   vmm_rw::status_e st;
   rg = vmm_ral_get_reg_by_ID(reg_id);
   assert(rg != null);

   rg.read(st, bits);
   status = int'(st);
   k = 0;
   while (i <= j) begin
      v[k] = bits[i*(`VMM_RAL_C_INT_WIDTH)+:(`VMM_RAL_C_INT_WIDTH)];
      k++;
      i++;
   end
endtask


export "DPI-C" task vmm_ral_reg__write;
task vmm_ral_reg__write(input  int unsigned reg_id,
                        output int         status,
                        input  int         v [`VMM_RAL_C_DATA_SIZE],
                        input  int         i,
                        input  int         j);
   bit [`VMM_RAL_DATA_WIDTH-1:0] bits;
   int k;
   vmm_ral_reg rg;
   vmm_rw::status_e st;
   rg = vmm_ral_get_reg_by_ID(reg_id);
   assert(rg != null);

   bits = rg.get();
   k = 0;
   while (i <= j) begin
      bits[i*((`VMM_RAL_C_INT_WIDTH))+:((`VMM_RAL_C_INT_WIDTH))] = v[k];
      i++;
      k++;
   end
   rg.write(st, bits);
   status = int'(st);
endtask


`endif //__DPI_TASKS_SV_H__
