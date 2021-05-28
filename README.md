[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/AugustinJose1221/FPGA-Build">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">FPGA Architecture for Real-time Video Stitching</h3>

  <p align="center">
    A novel architectural design for stitching video streams in real-time on an FPGA.
    <br />
    <a href="https://github.com/othneildrew/Best-README-Template"><strong>Explore the docs »</strong></a>
    <br />
    <br />
  </p>
</p>



<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

The designed architecture generates a video having a wider feild of view by stitching two video input based on features and keypoints. In simple terms, the output generated will be a panorama but with video. The architecture is optimized such that the output can be produced in real-time. The figure below illustrates the block diagram of the system depicting each step of the algorithm.
 
![Block Diagram](https://github.com/AugustinJose1221/FPGA-Build/blob/beta/img/System%20Design.jpg)

The system can be broadly divided into three subystems:
* Preprocessing
* SIFT Based Feature Extraction
* Frame Stitching

#### Preprocessing

The  input  video  stream  for  the  system  is  in  8  bit  RGB format. The input 8 bit image is shown in figure. Each  individual  frame  of  the  video  stream  will  have three  channels  corresponding  to  red,  green  and  blue.  The colour  information  in  the  video  frames  does  not  enhance feature  detection.  Moreover,  computation  on  a  3  channel  8 bit image takes more time compared to a single channel 8 bit image. Therefore, the RGB video frame is converted to an 8 bit grayscale image. The generated grayscale images will have lesser noise, more details in the shadows and provides better computational efficiency, shown in figure. 

| ![Input image](https://github.com/AugustinJose1221/FPGA-Build/blob/beta/img/Final1.jpg) | ![Grayscale image](https://github.com/AugustinJose1221/FPGA-Build/blob/beta/img/OUT2.jpg) |
|:---:|:---:|
| Input image | Grayscale image |

#### SIFT Based Feature Extraction

Feature extraction from the grayscale images is done using SIFT  algorithm.  SIFT  algorithm  can  be  separated  into  two main steps:
* Keypoint Detection

  SIFT operation begins with discrete convolution of the input image with different Gaussian filters. A Gaussian filter is a widely used image smoothing algorithm defined as:
  <p align="center">
    <img src="https://latex.codecogs.com/svg.latex?\Large&space;G(x,%20y,%20\sigma%20)%20=\frac{1}{2\pi%20\sigma%20^{2}}%20e^{-\frac{(x^{2}%20+%20y^{2})}{2\sigma%20^{2}}}">  
  </p>
  In the above equation,  G  is  the  Gaussian  kernel  at  the  point  (x,  y) and σ is  the  Gaussian  parameter. Using a larger  value  of σ produces a greater smoothing  effect  on  the  image.  Discrete  convolution of  the  image  with  Gaussian  kernel  generates  an  image  with lesser  noise  and  lesser  details.  In  SIFT,  discrete  convolution with Gaussian kernel is done with four different values of σ. Progressively  higher  values  of σ is  used  to  generate  a  set  of blurred images or an octave. 
| ![Input image](https://github.com/AugustinJose1221/FPGA-Build/blob/beta/res/Final2.jpg) | ![Sigma1_6](https://github.com/AugustinJose1221/FPGA-Build/blob/beta/res/SIGMA_1_6.jpg) | ![Sigma2_26](https://github.com/AugustinJose1221/FPGA-Build/blob/beta/res/SIGMA_2_26.jpg) | ![Sigma3_2](https://github.com/AugustinJose1221/FPGA-Build/blob/beta/res/SIGMA_3_2.jpg) | ![Sigma4_5](https://github.com/AugustinJose1221/FPGA-Build/blob/beta/res/SIGMA_4_5.jpg) |
|:---:|:---:|:---:|:---:|:---:|
| Input image | Sigma = 1.6 | Sigma = 2.26 | Sigma = 3.2 | Sigma = 4.5 |

  For a given value of σ, the sum of all coefficients in the convolution kernal should be equal to unity. Therefore, the size of the kernal increases as the value of σ increases. 

  Once the octave is generated,  a  DoG  space  is  built  based on the four images in the octave. DoG stands for difference of Gaussian.  DoG is a very computationally efficient approximation of Laplacian of Gaussian (LoG). The DoG space is built by  computing  the  difference  between  two  adjacent  Gaussian scale images, pixel by pixel. DoG space of four images in the octave will have three levels. 
| ![DoG1](https://github.com/AugustinJose1221/FPGA-Build/blob/beta/res/DIFF1.jpg) | ![DoG2](https://github.com/AugustinJose1221/FPGA-Build/blob/beta/res/DIFF2.jpg) | ![DoG3](https://github.com/AugustinJose1221/FPGA-Build/blob/beta/res/DIFF3.jpg) |
|:---:|:---:|:---:|
| Top level DoG | Middle level DoG | Bottom level DoG |

  Keypoints  are  extracted  from  the  DoG  space  by  finding the  local  maxima  or  minima  values.  A  pixel  is  considered a keypoint if it is a local maxima or minima within a 26 pixel neighbourhood consisting of 9 pixels in the top level, 8 pixels in the middle level and 9 pixels in the bottom level.
  <p align = "center">
  <img src = "https://github.com/AugustinJose1221/FPGA-Build/blob/beta/res/KEYPOINTS4.jpg"> <br>
  Keypoints
  </p>
* Descriptor Generation

  Keypoint descriptor is a unique identifier  for  a  particular  keypoint.  SIFT  uses  gradient  magnitude  and  direction  of  the  keypoint  as  the  basis  for  the descriptor.  Gradient  magnitude  and  direction  at  a  point  can be calculated by discrete convolution of the image with Sobel filters. 
  <p align = "center">
  <img src = "https://github.com/AugustinJose1221/FPGA-Build/blob/beta/res/SOBEL1.jpg"> <br>
  Sobel convolution output
  </p>
  To generate the keypoint descriptor, gradient magnitude and direction  of  every  point  inside  a  16x16  window  around  each keypoint is calculated. The gradient magnitudes of the 16x16 window  is  convolved  with  a  Gaussian  kernel.  The  gradient magnitudes in every 4x4 cell is combined such that the 16x16 window is reduced to a 4x4 window and 16 gradient directions. Finally, these 16 gradient directions are transferred into eight bins.  Hence  a  128  element  vector  is  built  which  acts  as  the keypoint descriptor.
  
#### Frame Stitching

Frame stitching is the process of combining two frames into a single image. Frame stitching is done in two steps:
* Keypoint Matching

  The  keypoint  descriptors  of  keypoints  in  the  video  frames  from  both  camera  sensors  are compared.  If  the  difference  between  the  keypoint  descriptors of  two  keypoints,  one  from  each  camera  sensor,  is  below  a error  threshold,  then  they  are considered  as  a  keypoint  pair.  The keypoint pair with the least difference between their keypoint descriptors is taken as the reference keypoints.  
  | ![DoG1](https://github.com/AugustinJose1221/FPGA-Build/blob/beta/res/left.jpg) | ![DoG1](https://github.com/AugustinJose1221/FPGA-Build/blob/beta/res/right.jpg) |
  |:---:|:---:|
  | Input image from left camera | Input image from right camera |
* Image Blending

  A  weighed  average  method  is  used to  blend  the  two  frames  into  a  single  image. The  values  of  pixels  in  the  overlapped  region  is  equal to  the  weighted  average  values  of  pixels  of  both  the  frames. The  weights  are  chosen  based  on  the  distance  between  the overlapped  pixel  and  the  border  of  the  corresponding  frame.
  <p align = "center">
  <img src = "https://github.com/AugustinJose1221/FPGA-Build/blob/beta/res/STITCH1.jpg"> <br>
  Stitched image
  </p>

<!-- GETTING STARTED -->
## Getting Started
### Prerequisites
The following packages needs to be installed on the Linux system before executing the source code.
* Icarus Verilog
  ```sh
  apt-get install iverilog
  ```
  
* Python
  ```sh
  apt-get install python3
  ```

* OpenCV
  ```sh
  pip3 install opencv-contrib-python
  ```
* numpy
  ```sh
  pip3 install numpy
  ```
  
* pillow
  ```sh
  pip3 install pillow
  ```

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/AugustinJose1221/FPGA-Build.git
   ```
2. Change working directory
   ```sh
   cd FPGA-Build/make
   ```
3. Compile the design
   ```sh
   make create
   ```
4. To view the RTL waveform
   ```sh
   make simulate
   ```
5. Generate output image
   ```sh
   python3 hexToImage.py
   ```
<!-- USAGE EXAMPLES -->
## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_



<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/othneildrew/Best-README-Template/issues) for a list of proposed features (and known issues).



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.



<!-- CONTACT -->
## Contact

Your Name - [@augustinjose121](https://twitter.com/augustinjose121) - augustinjose1221@gmail..com

Project Link: [https://github.com/AugustinJose1221/FPGA-Build](https://github.com/AugustinJose1221/FPGA-Build)







<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/AugustinJose1221/FPGA-Build.svg?style=for-the-badge
[contributors-url]: https://github.com/AugustinJose1221/FPGA-Build/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/AugustinJose1221/FPGA-Build.svg?style=for-the-badge
[forks-url]: https://github.com/AugustinJose1221/FPGA-Build/network/members
[stars-shield]: https://img.shields.io/github/stars/AugustinJose1221/FPGA-Build.svg?style=for-the-badge
[stars-url]: https://github.com/AugustinJose1221/FPGA-Build/stargazers
[issues-shield]: https://img.shields.io/github/issues/AugustinJose1221/FPGA-Build.svg?style=for-the-badge
[issues-url]: https://github.com/AugustinJose1221/FPGA-Build/issues
[license-shield]: https://img.shields.io/github/license/AugustinJose1221/FPGA-Build.svg?style=for-the-badge
[license-url]: https://github.com/AugustinJose1221/FPGA-Build/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/augustin-jose1221
[product-screenshot]: images/screenshot.png
