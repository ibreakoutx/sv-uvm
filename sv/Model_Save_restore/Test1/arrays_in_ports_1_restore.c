/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



#include "vcs_master.h"

static s_vpi_time var_time = {vpiSimTime,0,0,0};
static s_vpi_vecval var_vecval={0,0};
s_vpi_value var_value;
int print=1;
static unsigned t[] = {0, 0};
vpiHandle net_handle;
s_vpi_value current_value;

void run_test() {

    vpi_printf("TEST: Starting the test ...\n");
    
    t[0] += 5;
    var_time.low = t[0];
    VcsSimUntil((int *)&t); 
    
    vpi_printf("Going to do restore now -----------------\n");
    ModelRestore("saveimage_8",2);
 
    t[0] += 8;
    var_time.low = t[0];
    VcsSimUntil((int *)&t); 

}
