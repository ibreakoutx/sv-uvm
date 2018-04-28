
################## COMMON #########################

VCS = vcs
RTL = -f memsys.f memsys.test_top.v
OPT = -sverilog 
CMP = -cm assert+line+fsm+cond
RUN = -cm assert+line+fsm+cond
DIR = $(shell basename `pwd`)

################## VCS #########################

all : test00 clean test01
test00: memsys0 run cov hvp
test01: memsys1 run1 cov1 hvp1

cov:
	urg -dir simv.vdb

cov1:
	urg -dir simv.vdb
	
hvp:
	hvp annotate -lca -plan ../plans/memsys_plan.xml -dir "./simv.vdb" -userdata bugs.txt 
 
hvp1:
	hvp annotate -lca -plan ../plans/memsys_plan.xml -dir "./simv.vdb" -userdata bugs.txt 
   
memsys%:
	$(VCS) $(OPT) $(INC) memsys$*.v $(RTL) $(CMP) -lca

run:
	./simv $(RUN)

run1:
	./simv $(RUN)

################## HELP #########################

help:
	@echo "set VCS_HOME and do "gmake""
	@echo "by default it runs test00 if you want to run the other test do "gmake test01""

################## Clean #########################

clean:
	rm -rf *.vro simv* csrc* *.vshell depchk*vr 
	rm -rf .__snps* *.db* *.vpd* *.log *~ obj scs* work urg*

