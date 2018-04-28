#!/bin/csh -f

vcs -sverilog   memsys1.v -f memsys.f memsys.test_top.v -cm assert+line+fsm+cond -lca
