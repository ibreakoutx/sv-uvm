/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

#include "svdpi.h"
#include "vcsuser.h"

extern "C" {
	void mydisplay(long long *i1) {
		io_printf("C: size of long long is %0d bytes\n",sizeof(long long));
		io_printf("C: i1 is %llx\n",*i1);
		(*i1) = (*i1) * 2;	
		io_printf("C: change i1 to %llx\n",*i1);
		
	}
}

