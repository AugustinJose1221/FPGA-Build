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
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
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

The  input  video  stream  for  the  system  is  in  8  bit  RGB format.  Each  individual  frame  of  the  video  stream  will  have three  channels  corresponding  to  red,  green  and  blue.  The colour  information  in  the  video  frames  does  not  enhance feature  detection.  Moreover,  computation  on  a  3  channel  8 bit image takes more time compared to a single channel 8 bit image. Therefore, the RGB video frame is converted to an 8 bit grayscale image. The generated grayscale images will have lesser noise, more details in the shadows and provides better computational efficiency. 

#### SIFT Based Feature Extraction

Feature extraction from the grayscale images is done using SIFT  algorithm.  SIFT  algorithm  can  be  separated  into  two main steps:
* Keypoint Detection
* Descriptor Generation

### Built With

This section should list any major frameworks that you built your project using. Leave any add-ons/plugins for the acknowledgements section. Here are a few examples.
* [Bootstrap](https://getbootstrap.com)
* [JQuery](https://jquery.com)
* [Laravel](https://laravel.com)



<!-- GETTING STARTED -->
## Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Prerequisites

This is an example of how to list things you need to use the software and how to install them.
* npm
  ```sh
  npm install npm@latest -g
  ```

### Installation

1. Get a free API Key at [https://example.com](https://example.com)
2. Clone the repo
   ```sh
   git clone https://github.com/your_username_/Project-Name.git
   ```
3. Install NPM packages
   ```sh
   npm install
   ```
4. Enter your API in `config.js`
   ```JS
   const API_KEY = 'ENTER YOUR API';
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
