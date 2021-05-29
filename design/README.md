# Top Level Design

 The top level design is divided into five stages: 
 * Preprocessing stage
 * Filter stage
 * Keypoint stage
 * Keypoint matching stage
 * Frame blending stage
 
 ### Preprocessing Stage
 A detailed veiw of this stage of operation is shown in figure:
 <p align = "center">
  <img src = "https://github.com/AugustinJose1221/FPGA-Build/blob/beta/img/Diagram1.png"> <br>
  Preprocessing stage
</p>

To emulate the working of camera sensors, [image.v](https://github.com/AugustinJose1221/FPGA-Build/blob/beta/design/image.v) and [image2.v](https://github.com/AugustinJose1221/FPGA-Build/blob/beta/design/image.v) are used, which inputs images corresponding to left and right camera sensor respectively. [RWM_1.v](https://github.com/AugustinJose1221/FPGA-Build/blob/beta/design/RWM_1.v) is a read-write memory that stores the 8 bit RGB image. When it is WRITE mode, the RGB image pixel data is written into the memory. After all the pixel values are stored, the memory is put in READ mode. In READ mode, each pixel value is read sequentially from the memory. 

### Filter Stage
 A detailed veiw of this stage of operation is shown in figure:
 <p align = "center">
  <img src = "https://github.com/AugustinJose1221/FPGA-Build/blob/beta/img/Diagram3.png"> <br>
  Filter stage
</p>

### Keypoint Stage
 A detailed veiw of this stage of operation is shown in figure:
 <p align = "center">
  <img src = "https://github.com/AugustinJose1221/FPGA-Build/blob/beta/img/Diagram4.png"> <br>
  Keypoint stage
</p>

### Keypoint Matching Stage
 A detailed veiw of this stage of operation is shown in figure:
 <p align = "center">
  <img src = "https://github.com/AugustinJose1221/FPGA-Build/blob/beta/img/Diagram5.png"> <br>
  Keypoint matching stage
</p>

### Frame Blending Stage
 A detailed veiw of this stage of operation is shown in figure:
 <p align = "center">
  <img src = "https://github.com/AugustinJose1221/FPGA-Build/blob/beta/img/Diagram6.png"> <br>
  Frame blending stage
</p>
