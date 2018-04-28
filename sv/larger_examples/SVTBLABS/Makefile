DIR = $(shell basename `pwd`)
tar:	clean
	cd ..;tar cvfz ${DIR}.tgz ${DIR}
	@ls -l ../${DIR}.tgz


clean:
	@make -C lab1 clean
	@make -C lab2 clean
	@make -C lab3 clean
	@make -C lab4 clean
	@make -C apb_if clean
	@rm -f *~ *.tmp