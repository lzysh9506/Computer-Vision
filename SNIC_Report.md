---
title: "CS 558 Final project Question 4"
author: "Zhenyue Liu"
date: "November 27, 2018"

---


# Applied Superpixels using Simple Non-Iterative Clustering (SNIC)
## Introduction
SNIC is an improved version of the Simple Linear Iterative Clustering (SLIC) superpixel segmentation. Unlike SLIC, SNIC algorithm is non-iterative, enforces connectivity from the start, requires lesser memory, and is faster. In this project, I will implemente this algrorithm to two images and compare the performance with SLIC written by me and SLIC from skimage package.

## Data source and reference
This algorithm based on：   
> Achanta, Radhakrishna, and Sabine Süsstrunk. "Superpixels and polygons using simple non-iterative clustering." Computer Vision and Pattern Recognition (CVPR), 2017 IEEE Conference on. Ieee, 2017.

Code reference by:  
>https://github.com/MoritzWillig/pysnic   
>https://github.com/laixintao/slic-python-implementation  

Evaluation method reference:  
> Stutz, David. "Superpixel segmentation: an evaluation." German Conference on Pattern Recognition. Springer, Cham, 2015.    
> Arbelaez, Pablo, et al. "Contour detection and hierarchical image segmentation." IEEE transactions on pattern analysis and machine intelligence 33.5 (2011): 898-916.

Image source:  
>https://www2.eecs.berkeley.edu/Research/Projects/CS/vision/grouping/resources.html

### Data

The frist image comes from homework 3  
![Image1](https://github.com/lzysh9506/Computer-Vision/raw/master/Final4/wt_slic.png)   


The second image (Both original image and ground truth boundary) comes from BSDS500 dataset.   
![Image2](https://github.com/lzysh9506/Computer-Vision/raw/master/Final4/118035.jpg) 

##Run

`python comparison_three_algorithms.py`  

### Argument

`grid_of_x = 10` Set the gird along wdith to be 10   
`grid_of_y = 10` Set the grid along height to be 10   
`compactness = 40` Set the compactness to be 40   
`iteration = 10`Max iteration of SLIC is 10

## Result

![image3](https://github.com/lzysh9506/Computer-Vision/raw/master/Final4/all_seg_0.png)    


![image4](https://github.com/lzysh9506/Computer-Vision/raw/master/Final4/all_seg_1.png)   


## Discussion

### Consuming time

`>>> [Image 1] SLIC Algorithm written by Zhenyue Liu consuming time: 684.7430646419525`  
`>>> [Image 1] SNIC Algorithm consuming time: 39.16222429275513`  
`>>> [Image 1] SLIC Algorithm from skimage package consuming time: 0.03571367263793945`  
`>>> [Image 2] SLIC Algorithm written by Zhenyue Liu consuming time: 148.2505235671997`  
`>>> [Image 2] SNIC Algorithm consuming time: 9.404099464416504`  
`>>> [Image 2] SLIC Algorithm from skimage package consuming time: 0.020943403244018555`

The SLIC written by me costs long time for just 10 iterations. When the number of pixels and iterations doubles roughly from 153k(320x480) of image 2 to 375k(500*750) of image 1, the consuming time rises to 4 times.  
In comparison, the SNIC only costs 1/15 time of SLIC written by Liu. And when the number of pixels doubles, the consuming time also rise to 4 times.
SLIC from skimage has far less consuming time than the others.

### Qualitative
The visual appearance of superpixels is determined by compactness, and regularity properties that may also have strong influence on possible applications
We could see directly from three image:  
1. Four SLIC images all produce regular superpixels, but those written by Liu has lots of noisy along boundaries. In contrast, Snic images have highly irregualr superpixels.  
2. When the number of pixels is small, SLIC could capture more details than SNIC (the cross on the roof, the bell), but when the number of pixels increases, SNIC has better performance in capturing details (Sawtooth shape of the tower, the person sits on bench).   
3. SNIC has better performance in highly textured ares, such as trees and the second floor of the tower, while SLIC missed a lot.

### Quantitative
#### Image 1
For Image 1, I just choose one part to analyze, following is the edge cutout by Photoshop :
<br>

![image5](https://github.com/lzysh9506/Computer-Vision/raw/master/Final4/edge_truth0.png)   
 
<br>
 
![image6](https://github.com/lzysh9506/Computer-Vision/raw/master/Final4/all_HOG.png)

I crop the same part from all three images, using canny edge detector to generate HOG, and caculate their distance to the HOG of ground truth.  
`Dist between HOG of ground truth and HOG of SLIC by Zhenyue Liu : 0.029191`  
`Dist between HOG of ground truth and HOG of SNIC : 0.004785`  
`Dist between HOG of ground truth and HOG of SLIC by skimage  : 0.005898`  
<br>
We could see that SNIC has the smallest distance to ground truth, which means its effect of segmentation is best.

####Image 2
For image 2, I use another benchmark introduced by Arbelaez et al., to evaluate superpixel algorithms. The benchmark includes Boundary Recall(Rec) and Undersegmentation Error(UE) as primary metrics to asses superpixel algorithms, and in this project, I will just use Rec to implemente.
![image7](https://github.com/lzysh9506/Computer-Vision/raw/master/Final4/all_gt.png)  

|X1             | SLIC_Liu| SNIC   | SLIC_skimage|
|:--------------|--------:|-------:|------------:|
|Average        |  0.00715| 0.00571|      0.00559|
|Ground_truth_1 |  0.00711| 0.00560|      0.00589|
|Ground_truth_2 |  0.00519| 0.00375|      0.00401|
|Ground_truth_3 |  0.01023| 0.00865|      0.00780|
|Ground_truth_4 |  0.00603| 0.00462|      0.00488|
|Ground_truth_5 |  0.00720| 0.00591|      0.00540|  

In BSDS500 dataset, five ground truth pictures with different levels of details are given. In the consequence table, all recall score are not absolute, but just comparable with each other. We could see that SLIC written by Liu has best performance in all images, and SNIC has roughly the same performance with SLIC by skimage. 

### Conclusion
Based on all discussion above, SNIC has a best details detection performance and fair consuming time when dealing with large number of pixels. However, it could miss details when segmenting small images, one possible reason may be there's not enough information to update centroids. SLIC written by me is in an opposite way, it consumes lots of time but gives good performance in small images. Its problem is the noisy could be extremly high when the number of pixels increases. One solution may be smooth before segmentation. If only considering of efficiency, calling the SLIC function from skimage must be the best choice, but surprisingly, its performance dealing small image is not good enough.     
In addition, one issue about SNIC is that it could not improve its performance through running for many times, while SLIC could improve it through increasing the number of iterations(though its consuming time also increase dramatically).  
All the conclusion just come from two images with different sizes, I hope to complete a comprehensive consequence considering more alternatives, and improve the performance of SNIC in future study.
