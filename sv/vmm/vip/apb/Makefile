default: all

################## COMMON #########################

VCS = vcs
RTL = top.v  mem.v
OPT = -sverilog -debug_all -ntb_opts rvm
CMP =
RUN = 
DIR = $(shell basename `pwd`)

################## VCS #########################


all: clean comp run

cov:
	urg -dir simv.vdb

comp:
	$(VCS) $(OPT) $(INC) test_07.sv $(RTL) $(CMP)

run:
	./simv $(RUN)

################## HELP #########################

help:
	@echo "gmake - run this lab using VCS"

################## Clean #########################

clean:
	rm -rf simv* csrc* vc_hdrs.h *.vpd* *.log ucli.key

