#!/bin/csh -f

./run_vcs_master ./test_with_sv_mda_save.so ./simv.so
./run_vcs_master ./test_with_sv_mda_restore.so ./simv.so


