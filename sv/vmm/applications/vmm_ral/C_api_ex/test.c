/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



#ifdef VMM_RAL_PURE_C_MODEL
#define VMM_RAL_ADDR_GRANULARITY 1
#endif

#include "ral_mysys.h"

#ifdef VMM_RAL_PURE_C_MODEL
//void cmain(void * blk)
int main()
{
void *blk = calloc(410024,1);
cmain((void *) (((size_t)blk)>>2)+1);
}
#endif
void cmain(unsigned int blk)
{
   unsigned int rd[3],wd[3],wd1[3],tmp,err=0;
   int i;

   vmm_ral_init();

   //Register R1 address
   ral_addr_of_R1_in_myblk(blk);
   
   //Accessing fields of R1

   //TEST 1 : Write to Register R1 - Readback, readback fields
   wd1[0] = 0x99999999;
   wd[0] = wd1[0];
   ral_write_R1_in_myblk(blk, wd1);
   printf("Wrote R1: 32'h%08X (status: %0d)\n", wd1[0], vmm_ral_status);   
   if (vmm_ral_status != 0) {
      fprintf(stderr, "ERROR: ral_write_R1_in_myblk(%ud, %ud) failed with vmm_ral_status = %d\n",
              blk, wd[0], vmm_ral_status);
      exit(1);
   }
   
   rd[0] = 0;
   ral_read_R1_in_myblk(blk, rd);
   printf("Read  R1: 32'h%08X (status: %0d)\n", rd[0], vmm_ral_status);   
   if (vmm_ral_status != 0) {
      fprintf(stderr, "ERROR: ral_read_R1_in_myblk(%ud, %ud) failed with vmm_ral_status = %d\n", 
              blk, rd[0], vmm_ral_status);
      exit(1);
   }
     if (wd[0] != rd[0]) {
      fprintf(stderr, "ERROR: ral_write/read_R1_in_myblk failed. Wrote: 32'h%08X Read back: 32'h%08X\n",
              wd[0], rd[0]);
         err++;
     }

}//end of cmain

