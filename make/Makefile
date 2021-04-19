#This makefile automates the process of simulating a verilog module.
#Remember to change the 'SOURCE_FILES' and 'DUMPFILES' to simulate a new module.

CC=iverilog
FLAGS=-Wall -Winfloop
SOURCE_FILES= ../testbenches/video_stitcher_tb.v ../design/Controller.v ../design/RWM.v ../design/camera.v ../design/Grayscaler.v
DUMPFILES=../vcd/video_stitcher_tb.vcd

create:
	${CC} ${FLAGS} -o ../outputfiles/output.bin ${SOURCE_FILES}
	vvp ../outputfiles/output.bin
simulate:
	gtkwave ${DUMPFILES}
clean:
	rm -f ../outputfiles/*.bin
