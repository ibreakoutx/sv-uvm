/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



class t_scenario extends trans_scenario;

  int SCN1;

  constraint cst_t_scenario {
    scenario_kind == SCN1;
    repeated == 0;
  }

  function new(int i, string name);
    SCN1 = define_scenario(name, i);
  endfunction

endclass

