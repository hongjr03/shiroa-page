#import "../template.typ": *
#import "@preview/fletcher:0.5.0" as fletcher: diagram, node, edge
#import fletcher.shapes: house, hexagon, ellipse
#import "@preview/pinit:0.1.4": *
#import "@preview/cetz:0.2.2"
#import "/book.typ": book-page

#show: book-page.with(title: "数字图像处理基础 | DIP")


= 频率域图像增强 Image Enhancement in the Frequency Domain

二维离散傅里叶变换（2D DFT）：

$
  F(u, v) = 1 / (M N) sum_(x=0)^(M-1) sum_(y=0)^(N-1) f(x, y) e^(-j 2 pi((u x)/M + (v y)/N))
$

含义就是将 $(x, y)$ 空间转换到 $(u, v)$ 空间，$F(u, v)$ 是频率域的图像，$f(x, y)$ 是空间域的图像。

二维离散傅里叶逆变换（2D IDFT）：

$
  f(x, y) = sum_(u=0)^(M-1) sum_(v=0)^(N-1) F(u, v) e^(j 2 pi((u x)/M + (v y)/N))
$

*例*：
#note_block[
  下图是一幅二值图像（$256 times 256$），每条黑色条纹和白条纹都是 2 个像素宽，求此图像的傅里叶谱（将 $(0,0)$ 点移到中心上）中亮点的位置和亮度值。

  #figure(
    [
      #image("../assets/2024-06-22-11-36-20.png")
      // #let repeater(times) = range(times).map(i => 2pt)
      // #grid(
      //   columns: repeater(128),
      //   rows: repeater(128),
      //   // gutter: pt,
      //   align: center + horizon,
      //   fill: (x, _) => if calc.even(x) {
      //     black
      //   } else {
      //     white
      //   },
      // )
    ],
    caption: "二值图像",
    kind: {
      image
    },
  )

  分析：$y$ 方向没有变化，所以 $v = 0$；$x$ 方向上，每个黑白条纹都是 2 个像素宽，所以频率就是最大频率的一半。在图像上就是 $(-64, 0)$ 和 $(64, 0)$ 两个点，直流分量为 $(0, 0)$ 点。直流分量强度是图像强度的均值，也就是一半；剩下两个点强度相等，为原图像的 $1/4$。
]



== 频率域图像滤波 Filtering in the Frequency Domain

#definition[
  *卷积定理*：在频率域中，卷积变成了乘法。
]

即 $
f(x, y) * h(x, y) = F(u, v) H(u, v)
$

如果希望通过先做频域乘积、再对结果进行DFT反变换，来实现空域卷积，则需要保证信号无缠绕。可通过将原始数字信号通过补零延拓其矩阵大小。*要让卷积定理和直接卷积一致，需要0填充。*

比如，$f(x)$有$A$个样本、$g(x)$有$B$个样本，那么卷积前就需要分别对样本后面补 $0$，使其长度为 $P$。缠绕错误可以避免，如果 $
P >= A + B - 1
$。对于二维图像卷积，就要让长宽的最小值都大于原图像+滤波器的长宽$-1$。

#grid(
  columns: (1fr, 1fr),

)[#image("../assets/2024-06-21-23-09-26.png")][#image("../assets/2024-06-21-23-10-06.png")]

=== 频率域滤波流程

+ 给定一副大小为 $M times N$ 的输入图像 $f(x,y)$ ，选择填充参数 $P$ 和 $Q$。典型地，我们选择 $P=2M$ 和 $Q=2N$。
+ 对 $f(x,y)$ 添加必要数量的 $0$，形成大小为 $P times Q$ 的填充后图像 $f_p(x,y)$。
+ 用 $(-1)^(x+y)$ 乘以 $f_p(x,y)$ 移到其变换的中心。
+ 计算来自步骤3的图像的DFT，得到 $F(u,v)$。
+ 生成一个实对称滤波器函数 $H(u,v)$，大小为 $P times Q$，且中心位于 $(P/2, Q/2)$。用阵列相乘形成乘积 $G(u,v) = H(u,v)F(u,v)$。
+ 得到处理后的图像 $g_p(x,y) = {"real"[cal(F)^(-1)(G(u,v))]}bold((-1)^(x+y))$。注意 $(-1)^(x+y)$ 用来移动 $g_p(x,y)$ 的中心。
  - 这里本应该只有实部，但是由于计算机的误差，可能会有虚部，所以取实部。
+ 通过从 $g_p(x,y)$ 的左上角提取 $M times N$ 区域来得到 $g(x,y)$。

== 频率域平滑滤波器 Smoothing Frequency Domain Filters

=== 理想低通滤波器 Ideal Lowpass Filters

直接截断频率，不考虑过渡带。

$
  H(u, v) = cases(
  1 ",当" D(u, v) <= D_0,
  0 ",当" D(u, v) > D_0
), D(u, v) = sqrt((u-M/2)^2 + (v-N/2)^2)
$

缺点：*明显的振铃效应*

=== 巴特沃斯低通滤波器 Butterworth Lowpass Filters

$
  H(u, v) = 1 / (1 + (D(u, v) slash D_0)^(2n))
$

#figure(
  [
    #set text(size: 9pt)
    #set par(leading: 1em)
    #cetz.canvas({
      import cetz.draw: *
      import cetz.plot
      import cetz.palette: *
      plot.plot(
        size: (10, 5),
        x-tick-step: none,
        y-tick-step: none,
        x-label: [频率 $D(u, v)$],
        y-label: [增益 $H(u, v)$],
        name: "Butterworth",
        {
          let Butterworth1(x) = {
            1 / (1 + calc.pow(x / 100, 1))
          }
          let Butterworth2(x) = {
            1 / (1 + calc.pow(x / 100, 2))
          }
          let Butterworth3(x) = {
            1 / (1 + calc.pow(x / 100, 3))
          }
          let Butterworth4(x) = {
            1 / (1 + calc.pow(x / 100, 4))
          }
          plot.add(domain: (0, 400), Butterworth1)
          plot.add-anchor("pt1", (20, 0.84))
          plot.add(domain: (0, 400), Butterworth2)
          plot.add-anchor("pt2", (40, 0.87))
          plot.add(domain: (0, 400), Butterworth3)
          plot.add-anchor("pt3", (60, 0.83))
          plot.add(domain: (0, 400), Butterworth4)
          plot.add-anchor("pt4", (80, 0.73))
        },
      )
      line("Butterworth.pt1", ((), "|-", (0, 2.5)), mark: (start: ">"), name: "line")
      content("line.end", $n=1$, anchor: "north", padding: .1)
      line("Butterworth.pt2", ((), "|-", (0, 2)), mark: (start: ">"), name: "line")
      content("line.end", $n=2$, anchor: "north", padding: .1)
      line("Butterworth.pt3", ((), "|-", (0, 1.5)), mark: (start: ">"), name: "line")
      content("line.end", $n=3$, anchor: "north", padding: .1)
      line("Butterworth.pt4", ((), "|-", (0, 1)), mark: (start: ">"), name: "line")
      content("line.end", $n=4$, anchor: "north", padding: .1)
    })],
  caption: "不同阶数的巴特沃斯低通滤波器",
)

显然，阶数越低，过渡越平滑。所以阶数高的时候还是会有振铃效应。

=== 高斯低通滤波器 Gaussian Lowpass Filters

$
  H(u, v) = e^(-D(u, v)^2 / (2D_0^2))
$

#figure(
  [
    #set text(size: 9pt)
    #set par(leading: 1em)
    #cetz.canvas({
      import cetz.draw: *
      import cetz.plot
      import cetz.palette: *
      plot.plot(
        size: (10, 5),
        x-tick-step: none,
        y-tick-step: none,
        x-label: [频率 $D(u, v)$],
        y-label: [增益 $H(u, v)$],
        name: "Gaussian",
        {
          let Gaussian1(x) = {
            calc.exp(-calc.pow(x, 2) / (2 * 10 * 10))
          }
          let Gaussian2(x) = {
            calc.exp(-calc.pow(x, 2) / (2 * 20 * 20))
          }
          let Gaussian3(x) = {
            calc.exp(-calc.pow(x, 2) / (2 * 40 * 40))
          }
          let Gaussian4(x) = {
            calc.exp(-calc.pow(x, 2) / (2 * 100 * 100))
          }
          plot.add(domain: (0, 300), Gaussian1)
          plot.add-anchor("pt1", (7, 0.8))
          plot.add(domain: (0, 300), Gaussian2)
          plot.add-anchor("pt2", (19, 0.6))
          plot.add(domain: (0, 300), Gaussian3)
          plot.add-anchor("pt3", (54, 0.4))
          plot.add(domain: (0, 300), Gaussian4)
          plot.add-anchor("pt4", (180, 0.2))
        },
      )
      line("Gaussian.pt1", ((4, 0), "|-", ()), mark: (start: ">"), name: "line")
      content("line.end", $n=1$, anchor: "west", padding: .1)
      line("Gaussian.pt2", ((5, 0), "|-", ()), mark: (start: ">"), name: "line")
      content("line.end", $n=2$, anchor: "west", padding: .1)
      line("Gaussian.pt3", ((6, 0), "|-", ()), mark: (start: ">"), name: "line")
      content("line.end", $n=3$, anchor: "west", padding: .1)
      line("Gaussian.pt4", ((7, 0), "|-", ()), mark: (start: ">"), name: "line")
      content("line.end", $n=4$, anchor: "west", padding: .1)
    })],
  caption: "不同方差的高斯低通滤波器",
)

显然，方差越大，过渡越平滑。但无论如何，高斯低通滤波器都*不会有振铃效应*。

== 锐化频率域滤波器 Sharpening Frequency Domain Filters

对于理想高通滤波器、巴特沃斯高通滤波器和高斯高通滤波器，直接将低通滤波器的增益函数取反即可。

即
$
  H(u, v) = 1 - H_("lp")(u, v)
$

=== 同态滤波器 Homomorphic Filters

照射-反射模型：$
I(x, y) = R(x, y) * L(x, y), 0 < R(x, y) < 1, L(x, y) > 0
$

其中，$I(x, y)$ 为图像，$R(x, y)$ 为反射分量，$L(x, y)$ 为照射分量。取对数后有：$
z(x, y) = log(I(x, y)) = log(R(x, y)) + log(L(x, y))
$

对 $z(x, y)$ 进行傅里叶变换，有：$
cal(F)(z(x, y)) = cal(F)(log(R(x, y))) + cal(F)(log(L(x, y)))
$

即：$
Z(u, v) = F_i(u, v) + F_r(u, v)
$

再对 $Z(u, v)$ 进行滤波，有：$
S(u, v) &= H(u, v)Z(u, v)\
&= H(u, v)F_i(u, v) + H(u, v)F_r(u, v)
$

对 $S(u, v)$ 进行逆傅里叶变换，有：$
s(x, y) &= cal(F)^(-1)(S(u, v))\
&= i'(x, y) + r'(x, y)
$

而需要的增强图像 $g(x,y)$ 为：$
g(x, y) = e^(s(x, y)) = e^(i'(x, y))e^(r'(x, y))
$

照射分量较为稳定，反射分量差异较大。所以一般认为照度分量 $L(x, y)$ 是低频分量，反射分量 $R(x, y)$ 是高频分量。这样，设计特定的 $H(u, v)$ 就可以实现对图像的照度和反射的分别增强。

#figure(image("../assets/2024-06-22-00-11-58.png"))

== 选择性滤波

同上，也是基本的那三种。只是 $D_0$ 变成了距离 $D - D_0$。

