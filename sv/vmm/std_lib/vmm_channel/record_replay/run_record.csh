#!/bin/csh -f
./simv +vmm_opts+NUM_TRANS=10+NUM_CHANS=2 +vmm_MODE=RECORD \
        -l simv_tr=10_ch=2_rec.log
