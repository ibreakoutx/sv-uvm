/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


class alu_cov;
  event cov_event;
  alu_data tr;

  covergroup cg_trans @(cov_event);
   coverpoint tr.kind;
  endgroup

  function new();
    cg_trans = new;
  endfunction


endclass
