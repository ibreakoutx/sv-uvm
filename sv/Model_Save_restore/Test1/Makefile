
all : clean comp run 

clean:
	\rm -rf simv* csrc *.key *.so saveimage* run_vcs_master
comp:
	vcs -lca -sverilog arrays_in_ports.sv -o simv.so -e vcs_main -slave +modelsave -LDFLAGS "-shared" -debug -parallel+design=arrays_in_ports.parts
	gcc -g arrays_in_ports_1_save.c -o arrays_in_ports_1_save.so -shared -I${VCS_HOME}/include -I${VCS_HOME}/lib -fPIC -m32
	gcc -g arrays_in_ports_1_restore.c -o arrays_in_ports_1_restore.so -shared -I${VCS_HOME}/include -I${VCS_HOME}/lib -fPIC -m32
	gcc -g vcs_master.c -o run_vcs_master -ldl -rdynamic -I${VCS_HOME}/include -I${VCS_HOME}/lib -m32

run:
	./run_vcs_master ./arrays_in_ports_1_save.so ./simv.so
	./run_vcs_master ./arrays_in_ports_1_restore.so ./simv.so


