/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



/*
    Passing unpacked/native structure containing dynamic array to 
    an import DPI function, and retrieves the array members in C side.
    
*/

program tb;
    typedef struct {
        int da[];
    } ST;

    import "DPI-C" function void idpi(input ST st);
    ST st;

    initial begin 
        st.da = new[4];
        st.da = '{0, 1, 2, 3};
        idpi(st);
    end 
endprogram 
