#This makefile automates the process of simulating a verilog module.
#Remember to change the 'SOURCE_FILES' and 'DUMPFILES' to simulate a new module.

CC=iverilog
FLAGS=-Wall -Winfloop
SOURCE_FILES= ../testbench/controller_tb.v ../design/controller.v ../design/slave_1.v
DUMPFILES=../vcd/controller_tb.vcd

create:
	${CC} ${FLAGS} -o ../outfiles/output.bin ${SOURCE_FILES}
	vvp ../outfiles/output.bin
simulate:
	gtkwave ${DUMPFILES}
clean:
	rm -f ../outfiles/*.bin
