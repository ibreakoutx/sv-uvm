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
vpiHandle net_handle,nh2;
s_vpi_value current_value,cv2;

void run_test() {

/*    t[0] += 0;
    var_time.low = t[0];
    VcsSimUntil((int *)&t); 
    vpi_printf("Going to do restore now -----------------\n");
    ModelRestore("saveimage_40",10);
*/  
    t[0] += 30;
    var_time.low = t[0];
    VcsSimUntil((int *)&t);
    vpi_printf("Going to do restore now -----------------\n");
    ModelRestore("saveimage_75",10);

    net_handle = vpi_handle_by_name("tb.clk",NULL);
    current_value.format = vpiIntVal;
    current_value.value.integer = 0;
    vpi_put_value(net_handle,&current_value,NULL,vpiNoDelay);

    nh2 = vpi_handle_by_name("tb.glb_clk",NULL);
    cv2.format = vpiIntVal;
    cv2.value.integer = 0;
    vpi_put_value(nh2,&cv2,NULL,vpiNoDelay);

    t[0] += 105;
    var_time.low = t[0];
    VcsSimUntil((int *)&t);
    ModelRestore("saveimage_175",10);  
  
    vpi_put_value(net_handle,&current_value,NULL,vpiNoDelay);
    vpi_put_value(nh2,&cv2,NULL,vpiNoDelay);

    t[0] += 50;
    var_time.low = t[0];
    VcsSimUntil((int *)&t);
 

 }
