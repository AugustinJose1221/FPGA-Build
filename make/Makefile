#This makefile automates the process of simulating a verilog module.
#Remember to change the 'SOURCE_FILES' and 'DUMPFILES' to simulate a new module.

CC=iverilog
FLAGS=-Wall -Winfloop
SOURCE_FILES= ../testbenches/top_tb.v ../design/Controller.v ../design/image.v ../design/image2.v ../design/display.v ../design/RWM_1.v ../design/RWM_2.v ../design/camera.v ../design/Grayscaler.v ../design/filter5x5.v ../design/keypoints.v ../design/sobel_filter.v ../design/descriptor.v ../design/matcher.v ../design/stitcher.v ../testbenches/top.v
DUMPFILES=../vcd/interface_tb.vcd

create:
	${CC} ${FLAGS} -o ../outfiles/output.bin ${SOURCE_FILES}
	vvp ../outfiles/output.bin
simulate:
	gtkwave ${DUMPFILES} -g
clean:
	rm -f ../outfiles/*.bin
