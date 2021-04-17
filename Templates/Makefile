#This makefile automates the process of simulating a verilog module.
#Remember to change the 'SOURCE_FILES' and 'DUMPFILES' to simulate a new module.

CC=iverilog
FLAGS=-Wall -Winfloop
SOURCE_FILES= controller_tb.v controller.v slave_1.v
DUMPFILES=controller_tb.vcd

create: 
	${CC} ${FLAGS} -o output.bin ${SOURCE_FILES}
	vvp output.bin
simulate:
	gtkwave ${DUMPFILES} 
clean:
	rm -f *.bin 