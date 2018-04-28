OPTS	=

VCS	= vcs -R -sverilog -ntb_opts rvm \
	       $(OPTS) 

all : clean test 
test: sqltxt 

sqlite:
	$(VCS) +define+USE_SQLITE test.sv \
	       $(VCS_HOME)/etc/vmm/shared/src/vmm_sqlite_interface.c \
	       -CFLAGS "-I$(SQLITE3_HOME)/include"

sqltxt:
	$(VCS) +define+USE_SQLTXT test.sv \
	       $(VCS_HOME)/etc/vmm/shared/src/vmm_sqltxt_interface.c

run:
	simv
clean:
	rm -rf simv* csrc *.db *.sql vc_hdrs.h ucli.key
