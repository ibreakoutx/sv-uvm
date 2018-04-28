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

void run_test() {


/*    t[0] += 0;
    var_time.low = t[0];
    VcsSimUntil((int *)&t);
    ModelSave("saveimage_0");
    vpi_printf("***Save Point at 0 time units of simulation ***\n");
*/
    t[0] += 75;
    var_time.low = t[0];
    VcsSimUntil((int *)&t);
    ModelSave("saveimage_75");
    vpi_printf("***Save Point at 75 time units of simulation ***\n");

    t[0] += 50;
    var_time.low = t[0];
    VcsSimUntil((int *)&t);
    ModelSave("saveimage_125");
    vpi_printf("***Save Point at 125 time units of simulation ***\n");

    t[0] += 50;
    var_time.low = t[0];
    VcsSimUntil((int *)&t);
    ModelSave("saveimage_175");
    vpi_printf("***Save Point at 175 time units of simulation ***\n");  

    t[0] += 25;
    var_time.low = t[0];
    VcsSimUntil((int *)&t);
    vpi_printf("*** End of simulation ***");
 
}
