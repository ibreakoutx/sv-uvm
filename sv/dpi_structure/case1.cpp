/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

#include "stdio.h"
#include "svdpi.h"

extern "C" {

	typedef struct {
		int a;
		int b;
	}  mystruct;

	void mydisplay(mystruct *s1) {
		int s2;
		printf("C: gets values from SV, s1.a=%d, s1.b=%d\n",s1->a,s1->b);
		s1->a = 100;
		s1->b = 200;
		printf("C: set values,  s1.a=%d, s1.b=%d\n",s1->a,s1->b);
	}	


}
