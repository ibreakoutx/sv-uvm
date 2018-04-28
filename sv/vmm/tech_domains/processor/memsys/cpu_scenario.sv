/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class cpu_scenario extends cpu_trans_scenario;
  
  constraint cst_cpu_scenario {
    repeated == 0;
    length == 2;
  }

  function new();
    super.new();
    this.define_scenario("CPU SCENARIO", 2);
  endfunction


endclass



