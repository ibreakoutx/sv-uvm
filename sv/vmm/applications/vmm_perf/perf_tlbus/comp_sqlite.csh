#!/bin/csh -f

vcs -R -sverilog -ntb_opts rvm   +define+USE_SQLITE test.sv \
       ${VCS_HOME}/etc/vmm/shared/src/vmm_sqlite_interface.c \
       -CFLAGS "-I$(SQLITE3_HOME)/include"
