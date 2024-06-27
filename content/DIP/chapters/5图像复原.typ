#import "../template.typ": *
#import "@preview/fletcher:0.5.0" as fletcher: diagram, node, edge
#import fletcher.shapes: house, hexagon, ellipse
#import "@preview/pinit:0.1.4": *
#import "@preview/cetz:0.2.2"
#import "/book.typ": book-page

#show: book-page.with(title: "数字图像处理基础 | DIP")

= 图像复原 Image Restoration

#definition[
  *图像复原*：指的是从已知的图像中恢复原始图像的过程。
]

和图像增强对比：

#definition[
  *图像增强*：指的是通过增加图像的对比度、亮度等来改善图像的视觉效果。
]

图像复原是客观地恢复原始图像，而图像增强是主观地改善图像的视觉效果。

== 图像退化模型 Image Degradation Model

图像退化模型是指图像在传输、采集、处理等过程中受到的影响。一般来说，图像退化模型可以表示为：

$
  g(x, y) = h(x, y) * f(x, y) + eta(x, y)
$

其中，$g(x, y)$ 为退化图像，$f(x, y)$ 为原始图像，$h(x, y)$ 为退化函数，$eta(x, y)$ 为噪声。

== 噪声模型 Noise Models

噪声来源：
- 图像获取：环境条件（光照）、传感器质量
- 图像传输：无线信号被干扰

刻画噪声：
- 空间域和频率域特点
  - 白噪声：傅里叶变换后为常数
- 噪声是否和图像内容相关

=== 噪声的概率密度函数

- #grid(
    columns: (6fr, 4fr),

  )[高斯噪声：$
  p(z) = 1 / (sqrt(2 pi) sigma) e^(-(z - macron(z))^2 / (2 sigma^2))
$
    - 电路噪声，传感器噪声
    - 期望值 $E(z) = macron(z)$，标准差 $sigma$
    - 去除：均值滤波、几何均值滤波][
    #figure(
      [
        #set text(size: 9pt)
        #set par(leading: 1em)
        #cetz.canvas({
          import cetz.draw: *
          import cetz.plot
          import cetz.palette: *
          plot.plot(
            size: (5, 4),
            x-tick-step: none,
            y-tick-step: none,
            x-label: [灰度级 $z$],
            y-label: [$p(z)$],
            axis-style: "left",
            name: "Gaussian",
            {
              let Gaussian(x) = {
                calc.exp(-calc.pow(x - 32, 2) / (2 * 10 * 10)) / (calc.sqrt(2 * calc.pi) * 20)
              }
              plot.add(domain: (0, 64), Gaussian)
              plot.add-vline(32)
            },
          )
        })],
      caption: "高斯噪声概率密度函数",
    )
  ]
- #grid(
    columns: (6fr, 4fr),

  )[Rayleigh 噪声：$
  p(z) = cases(
    2/b (z - a) e^(-(z - a)^2 / b) ",当" z >= a,
    0 ",其他"
  )
$
    - 范围成像
    - 期望值 $E(z) = a + sqrt(pi b / 4)$，方差 $sigma^2 = b(4 - pi) / 4$][
    #figure(
      [
        #set text(size: 9pt)
        #set par(leading: 1em)
        #cetz.canvas({
          import cetz.draw: *
          import cetz.plot
          import cetz.palette: *
          plot.plot(
            size: (5, 4),
            x-tick-step: none,
            y-tick-step: none,
            x-label: [灰度级 $z$],
            y-label: [$p(z)$],
            axis-style: "left",
            name: "Rayleigh",
            {
              let Rayleigh(x) = {
                if x >= 4 {
                  2 / 20 * (x - 4) * calc.exp(-calc.pow(x - 4, 2) / 20)
                } else {
                  0
                }
              }
              plot.add(domain: (0, 20), Rayleigh)
              // plot.add-vline(32)
            },
          )
        })],
      caption: "Rayleigh 噪声概率密度函数",
    )
  ]
- #grid(
    columns: (6fr, 4fr),

  )[Gamma 噪声：$
  p(z) = cases(
    (a^b z^(b - 1))/ (b-1)! e^(-a z)  ",当" z >= 0,
    0 ",其他"
  ), a > 0, b "为正整数"
$
    - 激光成像
    - 期望值 $E(z) = a / b$，方差 $sigma^2 = b / a^2$
    - $a = 1$时，Gamma 分布就是指数分布][#figure(
      [
        #set text(size: 9pt)
        #set par(leading: 1em)
        #cetz.canvas({
          import cetz.draw: *
          import cetz.plot
          import cetz.palette: *
          plot.plot(
            size: (5, 4),
            x-tick-step: none,
            y-tick-step: none,
            y-max: 0.5,
            x-label: [灰度级 $z$],
            y-label: [$p(z)$],
            axis-style: "left",
            name: "Gamma",
            {
              let Gamma(x) = {
                if x >= 0 {
                  calc.pow(2, 4) * calc.pow(x, 4 - 1) * calc.exp(-2 * x) / (3 * 2 * 1)
                } else {
                  0
                }
              }
              plot.add(domain: (0, 5), Gamma)
              let Exponential(x) = {
                if x >= 0 {
                  calc.pow(4, 1) * calc.exp(-4 * x)
                } else {
                  0
                }
              }
              plot.add(domain: (0, 5), Exponential)
              plot.add-anchor("pt1", (0.5, 0.5))
            },
          )
          content("Gamma.pt1", "指数分布", anchor: "west", padding: .1)
        })],
      caption: "Gamma 噪声概率密度函数",
    )]

- #grid(
    columns: (6fr, 4fr),

  )[均匀噪声：$
  p(z) = 1 / (b - a), a <= z <= b
$
    - 仿真生成随机数
    - 期望值 $E(z) = (a + b) / 2$，方差 $sigma^2 = (b - a)^2 / 12$][#figure(
      [
        #set text(size: 9pt)
        #set par(leading: 1em)
        #cetz.canvas({
          import cetz.draw: *
          import cetz.plot
          import cetz.palette: *
          plot.plot(
            size: (5, 4),
            x-tick-step: none,
            y-tick-step: none,
            x-label: [灰度级 $z$],
            y-label: [$p(z)$],
            axis-style: "left",
            name: "Uniform",
            {
              let Uniform(x) = {
                if x >= 3 and x <= 7 {
                  1 / 10
                } else {
                  0
                }
              }
              plot.add(domain: (0, 10), Uniform)
              // plot.add-vline(32)
            },
          )
        })],
      caption: "均匀噪声概率密度函数",
    )]
- 脉冲（椒盐）噪声：$
  p(z) = cases(
    P_a ",当" z = a,
    P_b ",当" z = b,
    0 ",其他"
  )
$
  - 快速过渡，错误开关
  - 白色的点和黑色的点，所以叫椒盐噪声，$P$ 可正可负
  - 胡椒噪声可以用 $Q > 0$ 的逆谐波均值滤波器去除，盐噪声可以用 $Q < 0$ 的逆谐波均值滤波器去除；或者最大最小值滤波器
  - 用中值滤波可以去除椒盐噪声，但是滤波太多遍会丢失很多细节

=== 周期性噪声

傅里叶变换之后可以识别周期噪声。周期性噪声以能量脉冲出现，利用选择性滤波器去掉噪声。

*选择性滤波器*：

- 带阻滤波器：去除特定频率的噪声
- 带通滤波器：保留特定频率的信号


