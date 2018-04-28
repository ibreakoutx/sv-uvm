/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

#include "vcsuser.h"
#include "svdpi.h"

extern "C" {

	void mydisplay(const svOpenArrayHandle a) {
		
		svBitVec32 c;

		int low = svLow(a,1);
		int high = svHigh(a,1);

		for(int i=low;i<=high;i++) {
			svGetBitArrElemVec32(&c,a,i);
			io_printf("C: a[%d]=%d\n",i,c);
		}
	}

}
