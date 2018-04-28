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
#include "vc_hdrs.h"

void idpi(ST *h) {
    // svGetDynArrayPtr(const svDynamicArrayHandle h);
    // To get the pointer to the data from the dynamic array handle.
    
    int *ptr = (int *) svGetDynArrayPtr(h->da);

    //  int svGetDynArrayElemNum(const svDynamicArrayHandle h);
    //  To get the actual number of elements of the dynamic array.
    int arr_size = svGetDynArrayElemNum(h->da);

    int i; 
    printf("\nMembers of the st.da are :\n");
    for(i = 0; i < arr_size; i++) {
        printf("st.da[%0d] = %0d\n",i,ptr[i]);
    }
}
