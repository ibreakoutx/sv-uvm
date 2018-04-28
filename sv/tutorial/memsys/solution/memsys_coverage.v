/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


enum logic [1:0] {IDLE, START, WRITE0, WRITE1} st;

covergroup range @(negedge memsys_test_top.dut.Umem.adxStrb);
   a: coverpoint memsys_test_top.dut.Umem.busAddr {
      bins m_state[] = {[0:255]};
   }
endgroup

covergroup cntlr_cov @vintf.CBmemsys;
   b: coverpoint memsys_test_top.dut.Umem.state {
      bins t0 = (IDLE => IDLE);
      bins t1 = (IDLE => START);
      bins t2 = (START => IDLE);
      bins t3 = (START => WRITE0);
      bins t4 = (WRITE0 => WRITE1);
      bins t5 = (WRITE1 => IDLE);
      bins bad_trans = default;
   }
endgroup
