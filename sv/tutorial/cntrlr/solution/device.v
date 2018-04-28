/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


//object of this base class can not be directly created
virtual class device;
    task driveRamData(input logic [7:0] data);
        vintf.CBcntrlr.ramData <= data;
    endtask

    function  logic [7:0] getBusData();
        return vintf.CBcntrlr.busData;
    endfunction

    function  logic [5:0] getRamAddr();
        return vintf.CBcntrlr.ramAddr;
    endfunction

    function  logic [7:0] getRamData();
        return vintf.CBcntrlr.ramData;
    endfunction

    function logic getRdWr_N();
        return vintf.CBcntrlr.rdWr_N;
    endfunction

    // these methods must be defined in derived classes 
    extern virtual function logic getCe_N();
    extern virtual task waitCe_N();

endclass

class device0 extends device;
    function logic getCe_N();
        return vintf.CBcntrlr.ce0_N;
    endfunction

    task waitCe_N();
        @vintf.CBcntrlr.ce0_N;
    endtask
endclass

class device1 extends device;
    function logic getCe_N();
        return vintf.CBcntrlr.ce1_N;
    endfunction

    task waitCe_N();
        @vintf.CBcntrlr.ce1_N;
    endtask
endclass

class device2 extends device;
    function logic getCe_N();
        return vintf.CBcntrlr.ce2_N;
    endfunction

    task waitCe_N();
        @vintf.CBcntrlr.ce2_N;
    endtask
endclass

class device3 extends device;
    function logic getCe_N();
        return vintf.CBcntrlr.ce3_N;
    endfunction

    task waitCe_N();
        @vintf.CBcntrlr.ce3_N;
    endtask
endclass
