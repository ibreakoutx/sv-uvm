/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



#include <dlfcn.h>

#include "vcs_master.h"

char *test_so_file;
char *vcs_so_file;
void *test;
void *slaveVCSlib;
void *module;
int init_vcs_master();
vpi_interface vcs_slave = { 0 };

vpiHandle root_handle;
vpiHandle top;
vpiHandle itr;
vpiHandle dum;

// Global variables
void (*run_test)();
p_vpi_time sim_time;

int init_vcs_master () {
int err=1;
    if (run_test = dlsym(test, "run_test")) err++;
    else return(err); 
    if (vcs_main = dlsym(module, "vcs_main")) err++;
    else return(err); 
    if (VcsInit = dlsym(module, "VcsInit")) err++; 
    else return(err); 
   /* if (VcsRandomInitStart = dlsym(module, "VcsRandomInitStart")) err++; 
    else return(err); 
    if (VcsRandomInit = dlsym(module, "VcsRandomInit")) err++; 
    else return(err); 
  */  if (vpi_printf = dlsym(module, "vpi_printf")) err++; 
    else return(err); 
    if (vpi_iterate = dlsym(module, "vpi_iterate")) err++; 
    else return(err); 
    if (vpi_scan = dlsym(module, "vpi_scan")) err++; 
    else return(err); 
    if (vpi_get = dlsym(module, "vpi_get")) err++; 
    else return(err); 
    if (vpi_get_str = dlsym(module, "vpi_get_str")) err++; 
    else return(err); 
    if (vpi_handle_by_name = dlsym(module, "vpi_handle_by_name")) err++; 
    else return(err); 
    if (vpi_get_value = dlsym(module, "vpi_get_value")) err++; 
    else return(err); 
    if (vpi_put_value = dlsym(module, "vpi_put_value")) err++; 
    else return(err); 
    if (vpi_register_cb = dlsym(module, "vpi_register_cb")) err++; 
    else return(err); 
    if (vpi_register_cb = dlsym(module, "vpi_register_cb")) err++; 
    else return(err); 
    if (vpi_handle = dlsym(module, "vpi_handle")) err++; 
    else return(err); 
    if (VcsSimUntil = dlsym(module, "VcsSimUntil")) err++; 
    else return(err); 
    if (vcsExecTf = dlsym(module, "vcsExecTf")) err++; 
    else return(err); 
    if (vpi_get_time = dlsym(module, "vpi_get_time")) err++; 
    else return(err); 
    if (ModelRestore = dlsym(module, "ModelRestore")) err++; 
    else return(err); 
    if (ModelSave = dlsym(module, "ModelSave")) err++; 
    else return(err); 
    if (vpi_configure = dlsym(module, "vpi_configure")) err++; 
    else return(err); 
    return(0);
}

main(int argc, char *argv[]) {
  int err=0;
  // scan arguments for test.so
  if (argc < 2)
    printf("Usage: %s test.so simv.so <other run time options>\n",*argv);
  else {
      argc -= 1;
      argv += 1;
      test_so_file=*argv;
      test = dlopen(test_so_file, RTLD_NOW | RTLD_GLOBAL);
  //    slaveVCSlib = dlopen("libvcsfnew.so", RTLD_NOW );
  // scan arguments for simv.so
      argc -= 1;
      argv += 1;
      vcs_so_file=*argv;
      module = dlopen(vcs_so_file, RTLD_NOW );
      if (module) {
          if (!(err=init_vcs_master())) {
              vcs_main(argc, argv);
              VcsInit();
              root_handle = vpi_iterate(vpiModule, (vpiHandle)0x0);
              top = vpi_scan(root_handle);
              dum = vpi_scan(root_handle);
              vpi_printf("Top level verilog module = %s\n", vpi_get_str(vpiFullName, top));
              run_test();
              vpi_printf("End of simulation.\n");
              vcsExecTf("$finish",top);
          } else {
            printf("Error %d while initializing vcs_master\n",err);
          }
    } else {
  	printf("%s\n", (char*)dlerror());
    }
  }
}

