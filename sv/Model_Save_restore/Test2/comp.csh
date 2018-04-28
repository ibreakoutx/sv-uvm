#!/bin/csh -f

vcs test_with_sv_mda.v test_with_sv_mda_tb.v -sverilog -o simv.so -e vcs_main -slave +modelsave -LDFLAGS "-shared" -debug
gcc -g test_with_sv_mda_save.c -o test_with_sv_mda_save.so -shared -I$VCS_HOME/include -I$VCCS_HOME/lib -fPIC -m32
gcc -g test_with_sv_mda_restore.c -o test_with_sv_mda_restore.so -shared -I$VCS_HOME/include -ICS_HOME/lib -fPIC -m32
gcc -g vcs_master.c -o run_vcs_master -ldl -rdynamic -I$VCS_HOME/include -I$VCS_HOME/lib -m32


