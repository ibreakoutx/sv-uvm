/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class Configuration;
  rand int run_for_n_packets; // number of packets to process for test
  rand int num_of_iports;     // number of input ports to be tested
  rand int num_of_oports;     // number of output ports to be tested
  rand bit iports_in_use[];   // array of ON/OFF flag for input ports
  rand bit oports_in_use[];   // array of ON/OFF flag for output ports
       int valid_iports[$];   // queue of active input ports
       int valid_oports[$];   // queue of active output ports

  constraint valid {
    run_for_n_packets >= 0;
    num_of_iports inside { [1:16] };
    num_of_oports inside { [1:16] };
    iports_in_use.sum() == num_of_iports;
    oports_in_use.sum() == num_of_oports;
  }

  function new();
    iports_in_use = new[16]; // set to total number of input ports
    oports_in_use = new[16]; // set to total number of output ports
  endfunction

  function void post_randomize();
    valid_iports = iports_in_use.find_index with (item == 1);
    valid_oports = oports_in_use.find_index with (item == 1);
  endfunction

  virtual function void display(string prefix = "Test Configuration");
    string tmp;
    $display("[%s] run_for_n_packets = %0d", prefix, run_for_n_packets);
    $display("[%s] num_of_iports = %0d", prefix, num_of_iports);
    $display("[%s] num_of_oports = %0d", prefix, num_of_oports);
    for(int i=0; i<(valid_iports.size()-1); i++)
      tmp = { tmp, $psprintf("%0d, ", valid_iports[i]) };
    tmp = { tmp, $psprintf("%0d", valid_iports[$]) };
    $display("[%s] valid input ports: %s", prefix, tmp);
    tmp = "";
    for(int i=0; i<(valid_oports.size()-1); i++)
      tmp = { tmp, $psprintf("%0d, ", valid_oports[i]) };
    tmp = { tmp, $psprintf("%0d", valid_oports[$]) };
    $display("[%s] valid output ports: %s\n", prefix, tmp);
  endfunction

endclass
