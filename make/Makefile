#This makefile automates the process of simulating a verilog module.
#Remember to change the 'SOURCE_FILES' and 'DUMPFILES' to simulate a new module.

CC=iverilog
FLAGS=-Wall -Winfloop
SOURCE_FILES= ../testbenches/interface_tb.v ../design/Controller.v ../design/image.v ../design/display.v ../design/RWM_1.v ../design/RWM_2.v ../design/camera.v ../design/Grayscaler.v ../design/filter5x5.v
DUMPFILES=../vcd/interface_tb.vcd

create:
	${CC} ${FLAGS} -o ../outfiles/output.bin ${SOURCE_FILES}
	vvp ../outfiles/output.bin
simulate:
	gtkwave ${DUMPFILES} -g
clean:
	rm -f ../outfiles/*.bin
