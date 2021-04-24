# Modules and Description

+ Camera.v      : To emulate an actual camera hardware
+ RWM_1.v       : A simple read/write memory to store the color pixel data from the camera
+ Grayscaler.v  : Converts the colour pixels in RGB format to 8 bit grayscale
+ RWM_2.v       : A simple read/write memory to store the grayscale pixel data from the camera
+ Controller.v  : A FSM controller to control the working of each individual modules  
