#import "../template.typ": *
#import "@preview/fletcher:0.5.0" as fletcher: diagram, node, edge
#import fletcher.shapes: house, hexagon, ellipse
#import "@preview/pinit:0.1.4": *
#import "@preview/cetz:0.2.2"
#import "/book.typ": book-page

#show: book-page.with(title: "数字图像处理基础 | DIP")

= 特征提取和模式识别 Feature Extraction and Pattern Recognition

== 特征提取 Feature Extraction

=== PCA 主成分分析 Principal Component Analysis



== 基于决策论方法的识别

$bold(x)=(x_1,x_2,...,x_n)^T$ 表示 $n$ 维的模式向量，存在 $W$ 个模式类 $omega_1, omega_2, ..., omega_W$。为每个模式类 $omega_i$ 构造一个决策函数 $d_i (dot)$。如果 $bold(x) in omega_i$，那么 $d_i (bold(x))$ 的值应该大于其他类的决策函数值。

每个类之间的决策边界即 $d_i (bold(x)) = d_j (bold(x)) <=> d_i (bold(x)) - d_j (bold(x)) = 0$。定义 $d_(i j) (bold(x)) = d_i (bold(x)) - d_j (bold(x))$，那么 $d_(i j) (bold(x)) > 0$ 则属于 $omega_i$ 类，否则属于 $omega_j$ 类。

== 匹配

匹配是指将输入的模式向量 $bold(x)$ 与已知的模式类 $omega_i$ 进行比较，找到最接近的模式类。

=== 最小距离分类器 / 最近邻分类器 / NN 分类器 Nearest Neighbor Classifier

1. 把原型定义为每个类的平均值$
bold(m)_j = 1 / N_j sum_(bold(x) in omega_j) bold(x), N_j "为类" omega_j "的样本数"
$
2. 利用欧式距离（$||bold(a)|| = (a^T a)^(1/2)$）来计算距离$
D_j(bold(x)) = ||bold(x) - bold(m)_j||
$
  - 等价的计算方式：$
  d_j(bold(x)) = bold(x)^T bold(m)_j - 1/2 bold(m)_j^T bold(m)_j
  $
3. 如果 $D_j(bold(x))$ 最小，则 $bold(x) in omega_j$
  - 在等价的计算方式中，求的是 $d_j(bold(x))$ 最大

$omega_i$ 和 $omega_j$ 之间的决策边界是 $d_(i j) (bold(x)) = 0$，即 $
d_(i j) (bold(x)) &= d_i (bold(x)) - d_j (bold(x)) \
&= bold(x)^T (bold(m)_i - bold(m)_j) - 1/2 (bold(m)_i - bold(m)_j)^T (bold(m)_i + bold(m)_j) = 0
$

#grid(
  columns: (1fr, 0.4fr),
  column-gutter: 1em,

)[
  它是连接 $bold(m)_i$ 和 $bold(m)_j$ 线段的垂直平分线，如果 $n=2$。$n=3$ 时对应平面，$n>3$ 时对应超平面。

  这种分类器要求类别均值之间间距大、同时类内分散程度小。像右图的 Class 2 就无法很好区分。
][
  #image("../assets/2024-06-22-15-17-28.png")
]

=== 最佳统计分类器 / Bayes 分类器

看不懂。