# MGTV_Fusion
Infrared and visible image fusion through MGTV and AES.

## 1. Project Overview
This paper presents a novel fusion method for enhancing the contrast and edge details in fused images of infrared (IR) and visible (VIS) images. By leveraging multiscale Gaussian total variation (MGTV) decomposition, the source images are decomposed into high, medium, and low-frequency layers. For the medium-frequency layer, an adaptive local entropy and similar structural index-weighted (AES) fusion rule is employed, while the low and high-frequency layers are fused using the maximum selection strategy (MS) and the weighted least squares (WLS) fusion strategy, respectively. The final fused image is generated through an additive strategy. Experimental results on public datasets demonstrate that the proposed method outperforms existing fusion algorithms in terms of contrast preservation, edge sharpness, and noise reduction. Both qualitative and quantitative evaluations confirm the superior fusion performance of the proposed method, which aligns well with human visual perception.

## 2. Dependencies and Requirements
### Sofware Dependencies
MATLAB R2023b (or later)
Required MATLAB toolboxes:
Image Processing Toolbox
The required MATLAB packages can be installed via the matlab.addons.install function if needed.

### Hardware Requirements
A personal computer equipped with an AMD R7-6800H processor @ 3.2GHz and 16GB of RAM.

## 3. Installation and Usage
### Installation Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/lh-ite/MGTV_Fusion.git
   cd repository
### Usage
Running Fusion Algorithm: Open the MATLAB script main.m.
You need to set the path of the data set you want to use in this file.

## 4. Key Algorithms and Implementation
### Algorithm Description
[MGTV]: This method decomposes the image by using multi-scale Gaussian total variation to achieve the purpose of improving the contrast and details of the fused image.
You can find the Gaussian total variation code in the [GTV.m](./GTV.m) file.
In this file, I represents the input image, λ represents the balance parameter, σ1 and σ2 represent two Gaussian kernels, N represents the number of iterations, and flog is used to control whether to apply logarithmic gradient.
[AES]: This method extracts structural similarity and information entropy weight map from the image and then performs adaptive weighting as our fusion strategy.
You can find the related code in the [Relevancy.m](./Relevancy.m) file.
In this file, the input parameters consist of infrared images, visible light images and intermediate reference images.

## 5. Dataset and Experiments
## Dataset
Our data comes from the public datasets TNO and M3FD, which can be obtained from the following links:
https://figshare.com/articles/dataset/TNO_Image_Fusion_Dataset/1008029  

https://github.com/dlut-dimt/TarDAL
## Experiments
![image](https://github.com/user-attachments/assets/34f305b1-4224-432e-be94-f7f5021755a7)


## 6. Citation
If you use this work in your research, please cite it as follows:


## 7. Contact Information
For any questions or opportunities for collaboration, please feel free to reach out to the project lead:

- Email:  lh_010625@163.com or imagevisioner@outlook.com
