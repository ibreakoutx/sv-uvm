/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


class trans extends vmm_data;
  typedef enum bit {READ=1'b0, WRITE=1'b1} kind_e;

  rand bit [31:0] addr;
  rand bit [71:0] data;
  rand kind_e     kind;

  `vmm_data_member_begin(trans)
     `vmm_data_member_scalar(addr, DO_ALL)
     `vmm_data_member_scalar(data, DO_ALL)
     `vmm_data_member_enum(kind, DO_ALL)
  `vmm_data_member_end(trans)
endclass
`vmm_channel(trans)
`vmm_atomic_gen(trans, "Gen")
`vmm_scenario_gen(trans, "SGen")
