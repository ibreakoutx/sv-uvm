/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


  
class my_apb_scenario extends apb_trans_scenario;

  static vmm_log log = new ("my_scen_gen", "class");
  
  int unsigned RW_3;
  int unsigned addr_inc;

  constraint CRW_3 {$void(scenario_kind == RW_3) -> 
                    {
                     length == 10;
                     repeated == 0;
                     foreach (items[i]) {
                                         if (i < 3)     
                                         items[i].dir == apb_trans::READ;
                                         if (i>2  &&  i<5)
                                         items[i].dir ==  apb_trans::WRITE;
                                         } 
                     }
                    }
  
  constraint Cadd_inc 
                   {  
                    $void(scenario_kind == addr_inc) -> 
                       {
                        length == 10;
                         repeated == 0;
                         foreach (items[i]) 
                          if (i > 0)
                             items[i].addr == items[i-1].addr+1;
                         }
                      }
  
   function new();
      this.RW_3 = define_scenario("RW_3", 10);
      this.addr_inc = define_scenario("addr_inc", 10);

 endfunction

        

endclass

