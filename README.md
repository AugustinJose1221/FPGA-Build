# FPGA-Build
This repository contains the design of a video stitching algorithm in a FPGA using verilog HDL. The SIFT algorithm is used to compare and stitch the image frames coming from the left and right cameras. 
The digital data coming from each camera goes through the following processes:-
a)Grayscaling
b)Gaussian blur



Currently, the repository contains the modules the implement the grayscaling the data coming from the camera. A camera module is written that outputs 12 bytes. All the above mentioned processing occurs on these bytes.
