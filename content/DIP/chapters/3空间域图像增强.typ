#import "../template.typ": *
#import "@preview/fletcher:0.5.0" as fletcher: diagram, node, edge
#import fletcher.shapes: house, hexagon, ellipse
#import "@preview/pinit:0.1.4": *
#import "@preview/cetz:0.2.2"
#import "/book.typ": book-page

#show: book-page.with(title: "数字图像处理基础 | DIP")

= 空间域图像增强 Image Enhancement in the Spatial Domain

#definition[
  *空间域*：指的是图像的坐标空间，即图像的二维坐标系（aggregate of pixels）。
]

空间域图像增强直接对图像像素进行操作。

== 基本灰度变换 Basic Gray Level Transformations

#definition[*灰度变换*：指的是将输入图像的灰度级映射到输出图像的灰度级的过程]

灰度变换函数 $s = T(r)$ 可以用来描述灰度变换，其中 $r$ 为输入灰度级，$s$ 为输出灰度级。基本灰度变换是逐像素的操作，不考虑像素之间的关系。

#figure(
  [
    #set text(size: 9pt)
    #set par(leading: 1em)
    #cetz.canvas({
      import cetz.draw: *
      import cetz.plot: *
      import cetz.palette: *
      plot(
        size: (5, 5),
        x-tick-step: none,
        y-tick-step: none,
        x-label: [输入灰度级 $r$],
        y-label: [输出灰度级 $s$],
        {
          let Identity(x) = {
            x
          }
          let Power(x) = {
            calc.pow(x, 2)
          }
          let Root(x) = {
            calc.pow(x, 0.5)
          }
          let Log(x) = {
            calc.log(100 * x + 1, base: 10) / 2
          }
          let InverseLog(x) = {
            (calc.exp(5 * x) - 1) / (calc.pow(calc.e, 5) - 1)
          }
          let Negative(x) = {
            1 - x
          }
          cetz.plot.add(domain: (0, 1), Identity, label: "Identity")
          cetz.plot.add(domain: (0, 1), Power, label: "Power")
          cetz.plot.add(domain: (0, 1), Root, label: "Root")
          cetz.plot.add(domain: (0, 1), Log, label: "Log")
          cetz.plot.add(domain: (0, 1), InverseLog, label: "Inverse Log")
          cetz.plot.add(domain: (0, 1), Negative, label: "Negative")
        },
      )

    })],
  caption: "常见的灰度变换函数",
)

常见的灰度变换函数有：

- 恒等变换
- 幂次变换：$s = c r^gamma$
  - $gamma < 1$ 时，图像变亮，扩展低灰度级
  - $gamma > 1$ 时，图像变暗，扩展高灰度级
  - 应用：显示器的 gamma 校正，即通过 gamma 值让显示器显示的图像更接近真实
- 对数变换：$s = c log(1 + r)$
  - 用于扩展低灰度级，压缩高灰度级
  - 适用于图像的动态范围较大，但细节在低灰度级的图像
  - 一个典型的应用：傅里叶变换的幅度谱

== 直方图处理 Histogram Processing

#definition[*直方图*：指的是图像中各个灰度级的分布情况]

直方图 $h(r_k)$ 是一个函数，表示图像中灰度级 $r_k$ 出现的次数。标准化后的直方图 $p(r_k) = h(r_k) / (M N)$，其中 $M N$ 为图像的总像素数，表示各个灰度级的概率。

直方图均衡化是一种直方图处理方法，通过拉伸直方图来增强图像的对比度。其步骤如下：

1. 计算原始图像的直方图 $p_r(r_k)$
2. 计算累积分布函数 $s_k = sum_{j=0}^{k} p_r(r_j)$
3. 计算映射函数 $s_k = T(r_k) = (L-1) s_k$，$T(r_k)$ 即为直方图均衡化后的灰度级，$L$ 为灰度级数（如 256）
4. 计算均衡化后的图像 $s = T(r)$

这样，直方图均衡化后的图像的直方图会更加均匀，对比度也会更高。

== 空间滤波 Spatial Filtering

#definition[*空间滤波*：指的是对图像的像素进行操作，以改变图像的灰度级]

$
// R = sum_(i=-1, j=-1)^1 sum_(m=-1, n=-1)^1 w(m, n) f(i+m, j+n)
R = sum_(i, j in [-1, 1]) sum_(m, n in [-1, 1]) w(m, n) f(i+m, j+n)
$

其中，$R$ 为输出图像的像素，$w(m, n)$ 为滤波器的权重，$f(i+m, j+n)$ 为输入图像的像素。

== 平滑滤波器 Smooth Filters

#definition[*平滑滤波器*：指的是对图像进行平滑处理的滤波器]

平滑滤波器可以用来去除图像中的噪声，使图像更加平滑。常见的平滑滤波器有：
- 线性滤波器
  - 均值滤波器
  - 加权滤波器
- 非线性滤波器
  - 中值滤波器（统计排序滤波器）

=== 均值滤波器

$
  1 / 9 * mat(1,1,1;1,1,1;1,1,1)
$

$
  R = 1 / 9 sum_(i=1)^9 z_i
$

均值滤波器是一个 "box filter"，就是说它所有的系数都是相同的。它平滑了图像的同时也让边缘细节变得模糊。

=== 加权滤波器

$
  1 / 16 * mat(1,2,1;2,4,2;1,2,1)
$

使用加权平均的方式，让中心像素的权重更大，边缘像素的权重更小。这样可以在平滑的时候减少模糊。

=== 中值滤波器

中值滤波器是一种非线性滤波器，它的输出是输入像素的中值。这种滤波器对于去除椒盐噪声和斑点噪声有很好的效果。

== 锐化滤波器 Sharpening Filters

#definition[*锐化滤波器*：让图像的细节更加清晰的滤波器，或者让模糊的细节更加清晰]

主要在电子显微镜、医学成像、工业检测等领域使用。可以通过空间微分来实现锐化滤波。

=== 理论基础

一阶微分：
$
  (partial f) / (partial x) = f(x+1) - f(x)
$

二阶微分：
$
  (partial^2 f) / (partial x^2) = f(x+1) + f(x-1) - 2f(x)
$

=== 拉普拉斯算子 Laplacian Operator

拉普拉斯算子是一个*二阶微分*算子，可以用来检测图像中的边缘。它的定义如下：

$
  nabla^2 f = (partial^2 f) / (partial x^2) + (partial^2 f) / (partial y^2)\
  (partial^2 f) / (partial x^2) = f(x+1, y) + f(x-1, y) - 2f(x, y)\
  (partial^2 f) / (partial y^2) = f(x, y+1) + f(x, y-1) - 2f(x, y)\
  nabla^2 f = f(x+1, y) + f(x-1, y) + f(x, y+1) + f(x, y-1) - 4f(x, y)
$

写成矩阵形式：
$
  nabla^2 f = mat(0,1,0;1,-4,1;0,1,0) * f
$

这个算子可以用来检测图像中的 $x$ 和 $y$ 方向的边缘。可以扩展成可以检测斜向边缘的算子：
$
  nabla^2 f = mat(1,1,1;1,-8,1;1,1,1) * f
$

取反也是可以的：
#grid(
  columns: (1fr, 1fr),

)[
  $
    nabla^2 f = mat(0,-1,0;-1,4,-1;0,-1,0) * f
  $
][
  $
    nabla^2 f = mat(-1,-1,-1;-1,8,-1;-1,-1,-1) * f
  $
]

对图像进行锐化的时候，要判断一下拉普拉斯算子中心的值是否为正。如果是负的，就要取反。

$
  g(
    x, y
  ) = cases(
  f(x, y) + nabla^2 f(x, y) ",当" nabla^2 f(x, y) > 0,
  f(x, y) - nabla^2 f(x, y) ",当" nabla^2 f(x, y) < 0
)
$

其实这样就变成了：
$
  g(x, y) &= f(x, y) - [f(x+1, y) + f(x-1, y) + f(x, y+1) + f(x, y-1) - 4f(x, y)]\
  &= bold(5)f(x, y) - f(x+1, y) - f(x-1, y) - f(x, y+1) - f(x, y-1)
$
即：
$
  mat(0,-1,0;-1,bold(5),-1;0,-1,0) * f
$

还可以用于unsharp masking 和 high-boost filtering，即在中心像素上加上一个系数 $A (A>=1)$（比如普通的锐化就是直接加上原图，这时候可以认为$A=1$），这样就能从模糊的图像中提取出细节，让图像更加清晰。

=== Sobel 算子

Sobel 算子是一种常用的边缘检测算子，它是一种一阶微分算子，可以用来检测图像中的边缘。它的定义如下：

#grid(
  columns: (1fr, 1fr),

)[
  $
    nabla f = mat(-1,0,1;-2,0,2;-1,0,1) * f
  $
][
  $
    nabla f = mat(-1,-2,-1;0,0,0;1,2,1) * f
  $
]

Sobel 算子可以检测图像中的水平和垂直边缘，可以通过这两个算子的组合来检测图像中的所有边缘。

这学期的实验二是把 Sobel 算子编码到卷积核中，然后用卷积核对图像进行卷积，得到边缘图像。

```python
import torch
import torch.nn as nn
from PIL import Image
import numpy as np

# Sobel 算子
sobel_kernel_x = np.array(
    [[1, 0, -1],
     [2, 0, -2],
     [1, 0, -1]],
    dtype=np.float32
)
sobel_kernel_y = np.array(
    [[1, 2, 1],
     [0, 0, 0],
     [-1, -2, -1]],
    dtype=np.float32
)

conv_kernel_sobel_x = sobel_kernel_x.reshape(1, 1, 3, 3) # i * o * h * w
conv_kernel_sobel_y = sobel_kernel_y.reshape(1, 1, 3, 3)

class Net(nn.Module):
    def __init__(self):
        super(Net, self).__init__()
        self.conv_x = nn.Conv2d(1, 1, 3, padding=1, bias=False)
              # padding是为了保证输出和输入的尺寸一样，它是在输入的周围补0
        self.conv_y = nn.Conv2d(1, 1, 3, padding=1, bias=False)

        self.conv_x.weight.data = torch.from_numpy(conv_kernel_sobel_x)
        self.conv_y.weight.data = torch.from_numpy(conv_kernel_sobel_y)

    def forward(self, img):
        res_x = self.conv_x(img)
        res_y = self.conv_y(img)
        return res_x, res_y


net = Net()

input_path = 'imgs/100_3228.jpg'
output_path = 'outputs/exp2_3_1.jpg'

image = Image.open(input_path).convert('L')
image = torch.from_numpy(image).unsqueeze(0).unsqueeze(0) # 增加两个维度，变成 1 * 1 * H * W

res_x, res_y = net(image)
res_x = np.abs(res_x.detach().numpy().squeeze()) # squeeze()让shape为1的维度去掉
res_y = np.abs(res_y.detach().numpy().squeeze())
res = np.sqrt(res_x ** 2 + res_y ** 2)

# 保存图片
```

== Canny 边缘检测

Canny 边缘检测是一种多步骤的边缘检测算法，由 John F. Canny 于 1986 年提出。他的目标是找到一个最优的边缘检测结果。所谓最优的边缘检测结果，是指：

- 尽可能多地检测到边缘
- 边缘尽可能准确
- 边缘应当只被检测一次，同时尽可能不被检测到假边缘

它的步骤如下：

+ 使用高斯滤波器平滑图像，以减少噪声
+ 计算图像的梯度强度和方向
  - 使用 Sobel 算子分别对图像进行卷积，得到水平和垂直方向的梯度
+ #grid(
    columns: 2,
    column-gutter: 1em,

  )[
    非极大值抑制：对梯度强度图进行处理，以便消除非边缘像素
    - 就是说上一步中得到的梯度方向，如果这个像素的梯度强度不是这个方向上最大的，就把这个像素的梯度强度设为0。比如右边这个例子，梯度方向沿B、C点是水平的，那就可以让 A、B、C 三个点一起看 A 是不是一个极大值，如果是就保留，否则设为0。
  ][
    #image("../assets/2024-06-20-23-33-34.png")
  ]

+ #grid(
    columns: 2,
    column-gutter: 1em,

  )[
    滞后阈值：确定哪些边缘是真实的边缘
    - 这个阶段需要两个阈值，也就是划定一个高阈值和一个低阈值，如果梯度强度超过高阈值，就认为是边缘；如果梯度强度在低阈值和高阈值之间，就要看这个像素是否与高阈值像素相连，如果是就认为是边缘；如果不是就认为不是边缘。
    - 右边这张图中，C、B都在低阈值和高阈值之间，但是 C 与 A 相连，而B不和任何确定的边缘相连，所以只保留 C。
  ][
    #image("../assets/2024-06-20-23-36-15.png")
  ]
  - 如果边缘是长线的话，这一步也能消除一些噪声

