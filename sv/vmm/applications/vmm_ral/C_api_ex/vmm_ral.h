
#ifndef __VMM_RAL_H__
#define __VMM_RAL_H__

#include <stdio.h>
#include <stdlib.h>

/**
 * Ensure proper environment 
 */
#ifdef VMM_RAL_PURE_C_MODEL
#ifdef VMM_RAL_C_INTF_FOR_SV_MODEL
#error "ERROR: vmm_ral.h - When macro VMM_RAL_PURE_C_MODEL is defined, " \
       "VMM_RAL_C_INTF_FOR_SV_MODEL cannot be defined."
#endif
#ifdef VMM_RAL_C_INTF_FOR_OV_MODEL
#error "ERROR: vmm_ral.h - When macro VMM_RAL_PURE_C_MODEL is defined, " \
       "VMM_RAL_C_INTF_FOR_OV_MODEL cannot be defined."
#endif
#endif

#ifdef VMM_RAL_C_INTF_FOR_SV_MODEL
#ifdef VMM_RAL_C_INTF_FOR_OV_MODEL
#error "ERROR: vmm_ral.h - Both macro VMM_RAL_C_INTF_FOR_SV_MODEL and " \
       "VMM_RAL_C_INTF_FOR_OV_MODEL cannot be defined together."
#endif
#endif

#ifndef VMM_RAL_PURE_C_MODEL
#ifndef VMM_RAL_C_INTF_FOR_SV_MODEL
#ifndef VMM_RAL_C_INTF_FOR_OV_MODEL
#error "ERROR: vmm_ral.h - Macro VMM_RAL_PURE_C_MODEL, VMM_RAL_C_INTF_FOR_SV_MODEL " \
       "or VMM_RAL_C_INTF_FOR_OV_MODEL must be defined."
#endif
#endif
#endif


/****************************************************************************
 *
 * Published Macros/Variables/Types - Begin 
 *
 ***************************************************************************/

/**
 * Defines the word (physical interface) size (in bytes) of the top level block/system
 */
#ifndef VMM_RAL_DATA_BUS_WIDTH
#define VMM_RAL_DATA_BUS_WIDTH 4
#endif

/**
 * Defines the Address Granularity to be used for mappingi Address(es) 
 * in the RAL Model to actualy physical addresses in the underlying system/machine. 
 */
#ifndef VMM_RAL_ADDR_GRANULARITY
#ifdef VMM_RAL_DATA_BUS_WIDTH
#define VMM_RAL_ADDR_GRANULARITY VMM_RAL_DATA_BUS_WIDTH
#else
#define VMM_RAL_ADDR_GRANULARITY 4
#endif
#endif

/***
 * Variable to store return status of a read/write operation.
 */
int vmm_ral_status;

/****************************************************************************
 *
 * Published Macros/Variables/Types - End   
 *
 ***************************************************************************/




/***************************************************************************
 *
 * Internal implementation details follows.... 
 *
 * WARNING: PLEASE DO NOT USE THEM DIRECTLY UNLESS AS
 *          THEY MAY BE CHANGED WITHOUT NOTICE.
 *
 ***************************************************************************/

/**
 * Endian(s) supported in C Model.
 */
typedef enum vmm_ral_endian_tag {
    VMM_RAL_LITTLE_ENDIAN,
    VMM_RAL_BIG_ENDIAN
} vmm_ral_endian;


static int sizeof_int_in_bits = sizeof(int) * 8;


static unsigned int vmm_ral_addr_lshift;


#define vmm_ral_addr_align(addr) (((size_t) addr) << vmm_ral_addr_lshift)

    

/***
 * Error Handling Macro - Emits error message and exits the application.
 */
#define vmm_ral_error(msg)                                   \
    {                                                        \
        fprintf(stderr, "Error: vmm_ral.h - %s\n", msg);     \
        exit(1);                                             \
    }


/***
 * Warning Handling Macro - Emits warning message and continues execution.
 */
#define vmm_ral_warn(msg)                                    \
    {                                                        \
        fprintf(stderr, "Warning: vmm_ral.h - %s\n", msg);   \
    }


/***
 * Calculates log base 2
 */
static inline unsigned int logBase2(unsigned int N) {
    unsigned int log = 0;
    unsigned int tmp = N;

    if (N == 0) {
        vmm_ral_error("Attempted to calculate logarithm base 2 of zero.");
    }
    while (tmp != 1) { tmp >>= 1; log++; }
    if (N & (N-1)) log++;
    return log;
}


/**
 * Macro to get a field from a register.
 *
 * Arg Expectation:
 *  reg     should be unsigned int *    = Pointer to the base addr of the register.
 *  offset  should be unsigned int      = Offset of the field from LSB.
 *  width   should be unsigned int      = Width of the field in bits.
 *  val     should be unsigned int *    = Pointer to the base addr (of system mem) where
 *                                        field's value will be stored. 
 */
#define vmm_ral_field__read(reg,offset,width,val)                                       \
    {                                                                                   \
        vmm_ral_status = 1;                                                             \
        if (width > sizeof_int_in_bits) {                                               \
            vmm_ral_error("We don't yet support field width > sizeof(int) in C model.");\
        }                                                                               \
        if ((offset/sizeof_int_in_bits) != ((offset+width-1)/sizeof_int_in_bits)) {     \
            vmm_ral_error("We don't yet support accessing field(s) that span across "   \
                          "multiple segments in C model.");                             \
        }                                                                               \
        *(val) = (((*((reg)+(offset/sizeof_int_in_bits)))>>(offset%sizeof_int_in_bits)) \
                 &((((unsigned long long)1)<<(width))-1));                              \
        vmm_ral_status = 0;                                                             \
    }


/**
 * Macro to set a field in a register.
 *
 * Arg Expectation:
 *  reg     should be unsigned int *    = Pointer to the base addr of the register.
 *  offset  should be unsigned int      = Offset of the field from LSB.
 *  width   should be unsigned int      = Width of the field in bits.
 *  val     should be unsigned int *    = Pointer to the base addr (of system mem) where
 *                                        field's should be assigned/picked from.
 */
#define vmm_ral_field__write(reg,offset,width,val)                                      \
    {                                                                                   \
        vmm_ral_status = 1;                                                             \
        if (width > sizeof_int_in_bits) {                                               \
            vmm_ral_error("We don't yet support field width > sizeof(int) in C model.");\
        }                                                                               \
        if ((offset/sizeof_int_in_bits) != ((offset+width-1)/sizeof_int_in_bits)) {     \
            vmm_ral_error("We don't yet support accessing field(s) that span across "   \
                          "multiple segments in C model.");                             \
        }                                                                               \
        *((reg)+(offset/sizeof_int_in_bits)) = (                                        \
            (                                                                           \
               (*((reg)+(offset/sizeof_int_in_bits)))  &                                \
               (~(((((unsigned long long)1)<<(width))-1)<<(offset%sizeof_int_in_bits))) \
            ) | (                                                                       \
               ((*(val))&((((unsigned long long)1)<<(width))-1))  <<                    \
               (offset%sizeof_int_in_bits)                                              \
            )                                                                           \
        );                                                                              \
        vmm_ral_status = 0;                                                             \
    }


/**************************************************************
 *
 * Usage dependent API(s).
 * 
 *    a) For Generating Pure C RAL Model, macro 
 *       VMM_RAL_PURE_C_MODEL should have been defined.
 *    b) For Generating C API to SV RAL Model, macro 
 *       VMM_RAL_C_INTF_FOR_SV_MODEL should have been defined.
 *    c) For Generating C API to OV RAL Model, macro 
 *       VMM_RAL_C_INTF_FOR_OV_MODEL should have been defined.
 *
 **************************************************************/
#ifdef VMM_RAL_PURE_C_MODEL

/***************************************************
 *
 * BEGIN - API(s) for building RAL Model in Pure C
 *
 ***************************************************/


/**
 * Initialization macro 
 */
#define vmm_ral_init()                                                                          \
    {                                                                                           \
        vmm_ral_addr_lshift = logBase2(((VMM_RAL_DATA_BUS_WIDTH-1)/VMM_RAL_ADDR_GRANULARITY)+1);\
    }


/**
 * Macro to read a register's content.
 *
 * Arg Expectation:
 *  reg should be size_t            = Address of the Register in the RAL Model (not unsigned int *).
 *  n   should be unsigned int      = Number of segments of the register.
 *  endian should be a valid vmm_ral_endian type = Endianess to assume for reading. 
 *  val should be unsigned int *    = Buffer where the register will be read to.
 */
#define vmm_ral_reg__read(reg, n, endian, val)                                             \
    {                                                                                      \
        unsigned int __vmm_i, __vmm_j;                                                     \
        vmm_ral_status = 1;                                                                \
        for (__vmm_i = 0, __vmm_j = (n-1); __vmm_i < (n); __vmm_i++, __vmm_j--) {          \
            if (endian == VMM_RAL_LITTLE_ENDIAN)                                           \
                (val)[__vmm_i] = *((unsigned int *) vmm_ral_addr_align((reg) + __vmm_i));  \
            else if (endian == VMM_RAL_BIG_ENDIAN)                                         \
                (val)[__vmm_j] = *((unsigned int *) vmm_ral_addr_align((reg) + __vmm_i));  \
            else {                                                                         \
                vmm_ral_error("vmm_ral_reg__read(...) - Invalid endian received.");        \
            }                                                                              \
        }                                                                                  \
        vmm_ral_status = 0;                                                                \
    }


/**
 * Macro to write a register's content.
 *
 * Arg Expectation:
 *  reg should be size_t            = Address of the Register in the RAL Model (not unsigned int *).
 *  n   should be unsigned int      = Number of segments of the register.
 *  endian should be a valid vmm_ral_endian type = Endianess to assume for reading. 
 *  val should be unsigned int *    = Buffer storing the content to be written to the register.
 */
#define vmm_ral_reg__write(reg, n, endian, val)                                             \
    {                                                                                       \
        unsigned int __vmm_i, __vmm_j;                                                      \
        vmm_ral_status = 1;                                                                 \
        for (__vmm_i = 0, __vmm_j = n-1; __vmm_i < n; __vmm_i++, __vmm_j--) {               \
            if (endian == VMM_RAL_LITTLE_ENDIAN)                                            \
                *((unsigned int *) vmm_ral_addr_align((reg) + __vmm_i)) = (val)[__vmm_i];   \
            else if (endian == VMM_RAL_BIG_ENDIAN)                                          \
                *((unsigned int *) vmm_ral_addr_align((reg) + __vmm_i)) = (val)[__vmm_j];   \
            else {                                                                          \
                vmm_ral_error("vmm_ral_reg__write(...) - Invalid endian received.");        \
            }                                                                               \
        }                                                                                   \
        vmm_ral_status = 0;                                                                 \
    }



/**
 * Macro to read a memory's content.
 *
 * Arg Expectation:
 *  mem should be size_t            = Address of the Memory in the RAL Model (not unsigned int *).
 *  n_bits unsigned int             = Number of bits in each memory element/location. 
 *  offset should be size_t         = Offset of the memory element to be read.
 *  n   should be unsigned int      = Number of segments of a memory element.
 *  endian should be a valid vmm_ral_endian type = Endianess to assume for reading. 
 *  val should be unsigned int *    = Buffer where the memory will be read to.
 */
#define vmm_ral_mem__read(mem, n_bits, offset, n, endian, val)                             \
    {                                                                                      \
        unsigned int __vmm_i, __vmm_j, __vmm_last_seg = (n-1);                             \
        vmm_ral_status = 1;                                                                \
        for (__vmm_i = 0, __vmm_j = __vmm_last_seg; __vmm_i < (n); __vmm_i++, __vmm_j--) { \
            unsigned int __vmm_tmp = *((unsigned int *) vmm_ral_addr_align((mem) +         \
                                      ((offset) * (n)) + __vmm_i));                        \
            if (endian == VMM_RAL_LITTLE_ENDIAN) {                                         \
               if (__vmm_i == __vmm_last_seg) {                                            \
                  unsigned int n_bits_in_last_seg = (n_bits % sizeof_int_in_bits);         \
                  if (n_bits_in_last_seg) {                                                \
                     (val)[__vmm_i] = ((1 << n_bits_in_last_seg) - 1) & __vmm_tmp;         \
                  } else (val)[__vmm_i] = __vmm_tmp;                                       \
               } else (val)[__vmm_i] = __vmm_tmp;                                          \
            }                                                                              \
            else if (endian == VMM_RAL_BIG_ENDIAN) {                                       \
               if (__vmm_i == 0) {                                                         \
                  unsigned int n_bits_in_first_seg = (n_bits % sizeof_int_in_bits);        \
                  if (n_bits_in_first_seg) {                                               \
                     (val)[__vmm_j] = ((1 << n_bits_in_first_seg) - 1) & __vmm_tmp;        \
                  } else (val)[__vmm_j] = __vmm_tmp;                                       \
               } else (val)[__vmm_j] = __vmm_tmp;                                          \
            }                                                                              \
            else {                                                                         \
                vmm_ral_error("vmm_ral_mem__read(...) - Invalid endian received.");        \
            }                                                                              \
        }                                                                                  \
        vmm_ral_status = 0;                                                                \
    }


/**
 * Macro to write a memory's content.
 *
 * Arg Expectation:
 *  mem should be size_t            = Address of the Memory in the RAL Model (not unsigned int *).
 *  n_bits unsigned int             = Number of bits in each memory element/location. 
 *  offset should be size_t         = Offset of the memory element to be written.
 *  n   should be unsigned int      = Number of segments of a memory element.
 *  endian should be a valid vmm_ral_endian type = Endianess to assume for reading. 
 *  val should be unsigned int *    = Buffer storing the content to be written to the memory.
 */
#define vmm_ral_mem__write(mem, n_bits, offset, n, endian, val)                             \
    {                                                                                       \
        unsigned int __vmm_i, __vmm_j, __vmm_last_seg = (n-1);                              \
        vmm_ral_status = 1;                                                                 \
        for (__vmm_i = 0, __vmm_j = n-1; __vmm_i < n; __vmm_i++, __vmm_j--) {               \
            unsigned int * __vmm_ptr = (unsigned int *) vmm_ral_addr_align((mem)            \
                                       + ((offset) * (n)) + __vmm_i);                       \
            if (endian == VMM_RAL_LITTLE_ENDIAN) {                                          \
               if (__vmm_i == __vmm_last_seg) {                                             \
                  unsigned int n_bits_in_last_seg = (n_bits % sizeof_int_in_bits);          \
                  if (n_bits_in_last_seg) {                                                 \
                     *__vmm_ptr = (((1 << n_bits_in_last_seg) - 1) & (val)[__vmm_i]) |      \
                                  ((~((1 << n_bits_in_last_seg) - 1)) & *__vmm_ptr);        \
                  } else *__vmm_ptr = (val)[__vmm_i];                                       \
               } else *__vmm_ptr = (val)[__vmm_i];                                          \
            }                                                                               \
            else if (endian == VMM_RAL_BIG_ENDIAN) {                                        \
               if (__vmm_i == 0) {                                                          \
                  unsigned int n_bits_in_first_seg = (n_bits % sizeof_int_in_bits);         \
                  if (n_bits_in_first_seg) {                                                \
                     *__vmm_ptr = (((1 << n_bits_in_first_seg) - 1) & (val)[__vmm_j]) |     \
                                  ((~((1 << n_bits_in_first_seg) - 1)) & *__vmm_ptr);       \
                  } else *__vmm_ptr = (val)[__vmm_j];                                       \
               } else *__vmm_ptr = (val)[__vmm_j];                                          \
            }                                                                               \
            else {                                                                          \
                vmm_ral_error("vmm_ral_mem__write(...) - Invalid endian received.");        \
            }                                                                               \
        }                                                                                   \
        vmm_ral_status = 0;                                                                 \
    }



/***************************************************
 *
 * END - API(s) for building RAL Model in Pure C
 *
 ***************************************************/

#else

#ifdef VMM_RAL_C_INTF_FOR_SV_MODEL

/***********************************************************
 *
 * BEGIN - API(s) for building C interface to SV RAL Model
 *
 ***********************************************************/

#include "svdpi.h"

void
vmm_ral_init()
{
#ifdef __VCS2006_06_SP2__ 
    svScope scp = svGetScopeFromName("\\$root ");
    if (scp == NULL) {
        fprintf(stderr, "FATAL: Cannot set scope to $root\n");
        exit(-1);
    }
#else
#ifdef __VCS2008_09__ 
    svScope scp = svGetScopeFromName("\\$root ");
    if (scp == NULL) {
        fprintf(stderr, "FATAL: Cannot set scope to $root\n");
        exit(-1);
    }
#else
    svScope scp = svGetScopeFromName("$unit");
    if (scp == NULL) {
        fprintf(stderr, "FATAL: Cannot set scope to $unit\n");
        exit(-1);
    }
#endif
#endif
    svSetScope(scp);
    vmm_ral_addr_lshift = logBase2(((VMM_RAL_DATA_BUS_WIDTH-1)/VMM_RAL_ADDR_GRANULARITY)+1);
}


/**
 * Block and System accessing API(s).
 */
extern unsigned int vmm_ral_sys__get_subsys_by_name(unsigned int sys_id,
                                                    const char *name,
                                                    int idx);

extern unsigned int vmm_ral_sys__get_block_by_name(unsigned int sys_id,
                                                   const char *name,
                                                   int idx);

/**
 * Register accessing API(s)
 */
extern unsigned int vmm_ral_block_or_sys__get_reg_by_name(unsigned int blk_or_sys_id,
                                                          const char *name,
                                                          int idx);

extern const char * vmm_ral_reg__get_fullname(unsigned int reg_id);

extern void vmm_ral_reg__read(unsigned int reg_id, 
                              int *status,
                              unsigned int *val,
                              int i, int j);

extern void vmm_ral_reg__write(unsigned int reg_id,
                               int *status,
                               unsigned int *val,
                               int i, int j);

/**
 * Memory accessing API(s)
 */
extern unsigned int vmm_ral_block_or_sys__get_mem_by_name(unsigned int blk_or_sys_id,
                                                          const char *name);

extern const char * vmm_ral_mem__get_fullname(unsigned int mem_id);

extern void vmm_ral_mem__read(unsigned int mem_id, 
                              unsigned int mem_addr,
                              int *status,
                              unsigned int *val,
                              int i, int j);

extern void vmm_ral_mem__write(unsigned int mem_id,
                               unsigned int mem_addr,
                               int *status,
                               unsigned int *val,
                               int i, int j);


/***********************************************************
 *
 * END - API(s) for building C interface to SV RAL Model
 *
 ***********************************************************/

#else

#ifdef VMM_RAL_C_INTF_FOR_OV_MODEL

/***********************************************************
 *
 * BEGIN - API(s) for building C interface to OV RAL Model
 *
 ***********************************************************/

#error "Error: vmm_ral.h - We don't yet support C Interface Generation to OV RAL Model.\n"

/***********************************************************
 *
 * END - API(s) for building C interface to OV RAL Model
 *
 ***********************************************************/

#endif
#endif
#endif
#endif
