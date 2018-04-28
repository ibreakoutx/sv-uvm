#!/bin/csh -f

./simv -cm assert+line+fsm+cond
urg -dir simv.vdb
hvp annotate -lca -plan ../plans/memsys_plan.xml -dir "./simv.vdb" -userdata bugs.txt
