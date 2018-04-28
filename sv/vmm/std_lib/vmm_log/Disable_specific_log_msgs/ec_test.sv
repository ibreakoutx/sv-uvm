/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


program ec_test(ec_intf ec_bind);


initial begin
   ec_trans ec_trans_0;
   ec_env ec_env_0;
   ec_env_0 = new(ec_bind);
   ec_env_0.start();
   ec_trans_0 = new();
   ec_trans_0.randomize() with {addr==32'h1234;};
   ec_env_0.ec_bfm_0.ch_in.put(ec_trans_0);
   ec_trans_0.randomize() with {addr==32'h9876;};
   ec_env_0.ec_bfm_0.ch_in.put(ec_trans_0);
   ec_env_0.run();

end

 
endprogram



