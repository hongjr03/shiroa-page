#import "../template.typ": *
#import "@preview/fletcher:0.5.0" as fletcher: diagram, node, edge
#import fletcher.shapes: house, hexagon, ellipse
#import "@preview/pinit:0.1.4": *
#import "@preview/cetz:0.2.2"
#import "/book.typ": book-page

#show: book-page.with(title: "导论 | DIP")

= 导论

== 数字图像处理的基本步骤 Fundmental Steps in DIP

+ 图像获取 Image Acquisition
+ 图像增强 Image Enhancement
+ 图像复原 Image Restoration
+ 彩色图像处理 Color Image Processing
+ 小波变换和多分辨率处理 Wavelet and Multiresolution Processing
+ 压缩 Compression
+ 形态学处理 Morphological Processing ~ #pin(1) #h(1fr) #pin(2) ~ 以上输出主要为*图像*，以下主要为图像*属性*
+ 分割 Segmentation
+ 代表与描述 Representation and Description
+ 目标检测与识别 Object Recognition

#pinit-line(1, 2, end-dy: -3pt, start-dy: -3pt)