/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



module test;

    event ev1, ev2;

    always @(ev1)
    $display("ev1 triggered at %0ts",$time);

    initial wait (ev2.triggered)
    $display("ev2 triggered at %0ts",$time);

    initial begin
        ->> #5 ev1;         //Non-Blocking Trigger with delay control
    end

    initial begin
        ->> @(ev1) ev2;     //Non-Blocking Trigger with event control
    end

endmodule
