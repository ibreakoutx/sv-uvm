/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


`include "vmm.sv"

program test;

initial
begin
   vmm_log log = new("vmm_opts", "test");

   string s;
   int    i;
   bit    b;

   $write("Checking default values...\n");
   b = vmm_opts::get_bit("bit", "bit option");
   if (b) `vmm_error(log, "bit option is TRUE instead of FALSE.");

   i = vmm_opts::get_int("int", 9, "int option");
   if (i != 9) `vmm_error(log, $psprintf("int option is %0d instead of 9.", i));
   i = vmm_opts::get_int("int", 99, "Should not show up in HELP");
   if (i != 99) `vmm_error(log, $psprintf("int option is %0d instead of 99.", i));
   i = vmm_opts::get_int("int");
   if (i != 0) `vmm_error(log, $psprintf("int option is %0d instead of 0.", i));
   
   s = vmm_opts::get_string("str", "DEF", "str option");
   if (s != "DEF") `vmm_error(log, $psprintf("str option is \"%s\" instead of \"DEF\".", s));
   s = vmm_opts::get_string("str", "ABC", "Should not show up in HELP");
   if (s != "ABC") `vmm_error(log, $psprintf("str option is \"%s\" instead of \"ABC\".", s));

   $write("Checking option setting by type & source...\n");
   b = vmm_opts::get_bit("b1", "+vmm_opt");
   if (b != 1) `vmm_error(log, "b1 option is not set.");
   i = vmm_opts::get_int("i1", 0, "+vmm_opt");
   if (i != 1) `vmm_error(log, $psprintf("i1 option is %0d instead of 1.", i));
   s = vmm_opts::get_string("s1", "-", "+vmm_opt");
   if (s != "x") `vmm_error(log, $psprintf("s1 option is \"%s\" instead of \"x\".", s));

   b = vmm_opts::get_bit("b2", "+vmm_b2");
   if (b != 1) `vmm_error(log, "b2 option is not set.");
   i = vmm_opts::get_int("i2", 0, "+vmm_i2");
   if (i != 2) `vmm_error(log, $psprintf("i2 option is %0d instead of 3.", i));
   s = vmm_opts::get_string("s2", "-", "+vmm_s2");
   if (s != "y") `vmm_error(log, $psprintf("s2 option is \"%s\" instead of \"y\".", s));

   b = vmm_opts::get_bit("b3", "file1");
   if (b != 1) `vmm_error(log, "b3 option is not set.");
   i = vmm_opts::get_int("i3", 0, "file1");
   if (i != 3) `vmm_error(log, $psprintf("i3 option is %0d instead of 3.", i));
   s = vmm_opts::get_string("s3", "-", "file1");
   if (s != "z") `vmm_error(log, $psprintf("s3 option is \"%s\" instead of \"z\".", s));

   b = vmm_opts::get_bit("b4", "file2");
   if (b != 1) `vmm_error(log, "b4 option is not set.");
   i = vmm_opts::get_int("i4", 0, "file2");
   if (i != 4) `vmm_error(log, $psprintf("i4 option is %0d instead of 4.", i));
   s = vmm_opts::get_string("s4", "-", "file2");
   if (s != "a") `vmm_error(log, $psprintf("s4 option is \"%s\" instead of \"a\".", s));

   $write("Checking option setting order...\n");
   i = vmm_opts::get_int("ix", 0, "file1->file2");
   if (i != 5) `vmm_error(log, $psprintf("ix option is %0d instead of 5.", i));
   i = vmm_opts::get_int("iy", 0, "file2->+vmm_opts");
   if (i != 5) `vmm_error(log, $psprintf("iy option is %0d instead of 5.", i));
   i = vmm_opts::get_int("iz", 0, "file2->+vmm_iz");
   if (i != 5) `vmm_error(log, $psprintf("iz option is %0d instead of 5.", i));
   i = vmm_opts::get_int("ii", 0, "+vmm_opts->+vmm_ii");
   if (i != 5) `vmm_error(log, $psprintf("ii option is %0d instead of 5.", i));

   $write("--- Start of Reflog ---\n"); 

   vmm_opts::get_help();

   log.report();
   $write("--- End of Reflog ---\n");
end
endprogram

