/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



class cpu_trans extends vmm_data;

   typedef enum bit {READ = 1'b1, WRITE =  1'b0} kind_e;

   rand bit [7:0] address;
   rand bit [7:0] data;
   rand kind_e    kind;
   rand int trans_delay;

   `vmm_data_member_begin(cpu_trans)
   `vmm_data_member_scalar(address, DO_ALL)
   `vmm_data_member_scalar(data, DO_ALL)
   `vmm_data_member_enum(kind, DO_ALL)
   `vmm_data_member_end(cpu_trans)

endclass
`vmm_channel(cpu_trans)
`vmm_scenario_gen(cpu_trans, "CPU atomic generator")
