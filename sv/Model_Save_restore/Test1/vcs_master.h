#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <stdlib.h>

#include "vpi_user.h"

typedef struct {
    int  (*vcs_main)(int argc, char *argv[]);
    void (*VcsInit)();
    void (*VcsRandomInitStart)(unsigned time);
    void (*VcsRandomInit)(unsigned time);
    int  (*vpi_printf)(char *format, ...);
    vpiHandle (*vpi_iterate)(PLI_INT32 type, vpiHandle refHandle);
    int    (*vpi_get)(PLI_INT32 property, vpiHandle object);
    char * (*vpi_get_str)(PLI_INT32 property, vpiHandle object);
    vpiHandle (*vpi_scan)(vpiHandle itr);
    vpiHandle (*vpi_handle)(PLI_INT32 type, vpiHandle refHandle);
    void      (*vpi_get_value)(vpiHandle expr, p_vpi_value value_p);
    vpiHandle (*vpi_put_value)(vpiHandle object, p_vpi_value value_p, p_vpi_time time_p, PLI_INT32 flags);
    vpiHandle (*vpi_register_cb)(p_cb_data cb_data_p); 
    vpiHandle (*vpi_handle_by_name)(char *name, vpiHandle scope);
    void (*VcsSimUntil)(int *time);
    int (*vcsExecTf)(char *cli_line, vpiHandle h1);
    int (*vpi_get_time)(vpiHandle h1, p_vpi_time sim_time);
    int (*ModelRestore)(const char *label, int);
    int (*ModelSave)(const char *label);
    int (*vpi_configure)(PLI_INT32 item,  PLI_BYTE8 *value);
} vpi_interface;

extern int ModelRestore(const char *label, int);
extern int ModelSave(const char *label);

extern vpi_interface vcs_slave;
extern p_vpi_time sim_time;
extern vpiHandle top;

#define vcs_main  vcs_slave.vcs_main
#define VcsInit  vcs_slave.VcsInit
#define VcsRandomInitStart  vcs_slave.VcsRandomInitStart
#define VcsRandomInit  vcs_slave.VcsRandomInit
#define vpi_printf  vcs_slave.vpi_printf
#define vpi_iterate  vcs_slave.vpi_iterate
#define vpi_get  vcs_slave.vpi_get
#define vpi_get_str  vcs_slave.vpi_get_str
#define vpi_scan  vcs_slave.vpi_scan
#define vpi_handle_by_name  vcs_slave.vpi_handle_by_name
#define vpi_handle  vcs_slave.vpi_handle
#define vpi_get_value  vcs_slave.vpi_get_value
#define vpi_put_value  vcs_slave.vpi_put_value
#define vpi_register_cb  vcs_slave.vpi_register_cb
#define vpi_handle_by_name  vcs_slave.vpi_handle_by_name
#define VcsSimUntil  vcs_slave.VcsSimUntil
#define vcsExecTf  vcs_slave.vcsExecTf
#define vpi_get_time  vcs_slave.vpi_get_time
#define ModelRestore vcs_slave.ModelRestore
#define ModelSave vcs_slave.ModelSave
#define vpi_configure vcs_slave.vpi_configure

