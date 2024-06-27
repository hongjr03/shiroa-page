#import "../template.typ": *
#import "@preview/fletcher:0.5.0" as fletcher: diagram, node, edge
#import fletcher.shapes: house, hexagon, ellipse
#import "@preview/pinit:0.1.4": *
#import "@preview/cetz:0.2.2"
#import "/book.typ": book-page

#show: book-page.with(title: "数字图像处理基础 | DIP")

= 数字图像处理基础 Digital Image Fundamentals

== 光和电磁波 Light and the Electromagnetic Spectrum


#figure(image("../assets/2024-06-01-23-44-35.png", width: 60%), caption: "RGB 和 CMYK 颜色模型")

可以用 RGB 三原色来加性描述颜色，也可以用 CMYK 颜色模型来描述颜色，关系如下：

$ mat(C;M;Y) = mat(1;1;1) - mat(R;G;B) $

K 即为黑色，是为了补充 CMY 三原色的不足而引入的。

还可以用 HSI 颜色模型来描述颜色，其中 H 为色调，S 为饱和度，I 为强度。在这种模型下，$z$轴表示光强，每个 $z$ 值切出的面可以表示为极坐标 $(r, theta)$，其中 $r$ 为饱和度，$theta$ 为色调。可以截取
RGB、CMY 六个纯色和黑白色作为正方体的顶点，这样也是 HSI 颜色模型。

#figure(image("../assets/2024-06-01-23-53-35.png"), caption: "HSI 颜色模型")

== 图像感知和获取 Image Sensing and Acquisition

传感器的种类：

- Single imaging sensor 单传感器，一次只能获取一个像素的信息
  - 适用于精密测量和逐点扫描的场景。
- Line sensor 线阵传感器，一次可以获取一行像素的信息，用于扫描图像，成本低
  - 适用于连续扫描和快速检测的场景，常用于工业和文档扫描。
- Array sensor 阵列传感器，一次可以获取多行像素的信息
  - 适用于需要高分辨率和大面积成像的场景，如数码相机、医疗成像和遥感卫星。

传感器的原理：感光材料接收到经过滤镜的能量后，会产生电压的变化，进而转化为数字信号。
#figure(image("../assets/2024-06-02-00-10-10.png", width: 80%), caption: "一个图像采集过程的例子")
图像采集的建模：
$ f(x,y) = i(x,y)r(x,y) $
其中，$f(x,y)$ 为图像，$i(x,y)$ 为光照强度，$r(x,y)$ 为反射率。这个式子无法直接求解，只能通过一些方法来估计。

== 图像采样和量化 Image Sampling and Quantization

#definition[*Sampling 采样*：指的是将坐标值转化为离散的像素值]
#definition[*Quantization 量化*：指的是将各个像素的幅值转化为离散的灰度值]

图像大小：
- 用位表示，$M times N times K$
- 用字节表示，$M times N times K times 1/8$

图像格式：头部信息 + 数据信息

一张 $256 times 256$ 的图像至少需要 6bit 色深（$64$ 级灰度，即 $2^6 = 64$），这样才能保证图像的细节不会丢失。
