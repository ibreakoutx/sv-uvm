/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

 
//ALU transaction
class alu_trans extends vmm_data;
   typedef enum bit [2:0] {ADD=3'b000, SUB=3'b001, MUL=3'b010, LS=3'b011, RS=3'b100} kind_t;
   rand kind_t kind;
   rand bit [3:0] a, b;
   rand bit [6:0] y;
 
`vmm_data_member_begin(alu_trans)
   `vmm_data_member_enum(kind, DO_ALL)
   `vmm_data_member_scalar(a, DO_ALL)
   `vmm_data_member_scalar(b, DO_ALL)
   `vmm_data_member_scalar(y, DO_ALL)
`vmm_data_member_end(alu_trans)
 
endclass
`vmm_channel(alu_trans)
`vmm_scenario_gen(alu_trans, "ALU SCN")
 

