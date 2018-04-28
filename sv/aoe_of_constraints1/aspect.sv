/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


// The following is a Aspect Oriented Extension, AOE,
// that modifies the original definition of Transaction, in-place.
// No new data type is created.  When randomized, constraint c1
// and constraint c2 will both be applied.

extends TransactionAspect(Transaction);
   constraint c2
   {
      addr > 50;
      addr < 1500;
      data < 10;
   }
endextends

