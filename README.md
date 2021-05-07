# FPGA-Build
This repository contains the design of a video stitching algorithm in a FPGA using verilog HDL. The SIFT algorithm is used to compare and stitch the image frames coming from the left and right cameras.
The digital data coming from each camera goes through the following processes:-
1. Grayscaling
2. Gaussian blur



Currently, the repository contains the modules the implement the grayscaling the data coming from the camera. A camera module is written that outputs 12 bytes. All the above mentioned processing occurs on these bytes.

Folder description:
1. The main working verilog modules are inside the 'design' folder.
2. Their corresponding testbenches are kept inside the 'testbenches' folder.
3. The output simulation waveforms are dumped into .vcd files. These are present in the 'vcd' folder.
4. The terminal commands needed to compile and execute these files are written in a makefile. This makefile is inside the folder named 'make'. To use this makefile, open the terminal and go to the location where the makefile is saved. Then type "make create" to compile .v files within the makefile. Then type "make simulate" to open the dumpfile in a simulator like GTKWave. If you wish to delete the .bin file created during compilation, then type "make clean".
5. The 'templates' folder contains a simple design structure followed while designing the working verilog modules.
