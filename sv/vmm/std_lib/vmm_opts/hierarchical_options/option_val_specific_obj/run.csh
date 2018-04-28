#!/bin/csh -f

./simv +vmm_opts+FOO_INT=99@d2:b1+FOO_INT=1050@d2:c2:b1+FOO_BIT@d2:b1+FOO_BIT@d2:c2:b1+FOO_STR=NEW_VAL1@d2:b1+FOO_STR=NEW_VAL2@d2:c2:b1 -l run.log
