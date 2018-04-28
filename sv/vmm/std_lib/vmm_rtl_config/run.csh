#_!/bin/csh -f

./simv +vmm_rtl_config=RTLCFG +vmm_gen_rtl_config -l run1.log
./simv +vmm_rtl_config=RTLCFG -l run2.log
