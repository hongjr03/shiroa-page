#import "../template.typ": *
#import "@preview/fletcher:0.5.0" as fletcher: diagram, node, edge
#import fletcher.shapes: house, hexagon, ellipse
#import "@preview/pinit:0.1.4": *
#import "@preview/cetz:0.2.2"
#import "/book.typ": book-page

#show: book-page.with(title: "数字图像处理基础 | DIP")


= 图像压缩 Image Compression

== 图像冗余 Image Redundancy

二维灰度矩阵中包含三种冗余：

- 编码冗余：采用固定长度编码普遍存在冗余
- 空间和时间冗余：图像中紧邻的像素之间有很强的相关性，视频中相邻帧之间也有很强的相关性
- 不相关的信息：被视觉系统忽略的信息或与图像用途无关的信息

== 图像压缩模型

#figure(
  [
    #set text(size: 8pt)
    #let blob(pos, label, tint: white, ..args) = node(
      pos,
      align(center, label),
      width: 19mm,
      fill: tint.lighten(60%),
      stroke: 1pt + tint.darken(20%),
      corner-radius: 5pt,
      ..args,
    )
    #diagram(
      spacing: 8pt,
      cell-size: (8mm, 10mm),
      edge-stroke: 1pt,
      edge-corner-radius: 5pt,
      mark-scale: 70%,
      blob((0, 0), [原始图像], width: auto, tint: red),
      edge("-|>"),
      blob(
        (1.75, 0),
        [
          #diagram(
            spacing: 8pt,
            cell-size: (8mm, 10mm),
            edge-stroke: 1pt,
            edge-corner-radius: 5pt,
            mark-scale: 70%,
            blob((0, 0), [映射器\ Mapper\ *可逆*], tint: yellow),
            edge("-|>"),
            blob((1.5, 0), [量化器\ Quantizer\ *不可逆*], tint: yellow),
            edge("-|>"),
            blob((3, 0), [符号编码器\ *编码、压缩*\ *可逆*], tint: yellow),
          )
          #align(horizon)[编码器 Encoder]
        ],
        width: auto,
        tint: orange,
      ),
      edge("-|>", "rr", $\/\/$, label-pos: 0.47, label-side: center),
      blob(
        (4, 0),
        [
          #diagram(
            spacing: 8pt,
            cell-size: (8mm, 10mm),
            edge-stroke: 1pt,
            edge-corner-radius: 5pt,
            mark-scale: 70%,
            blob((0, 0), [符号解码器\ Symbol Decoder], tint: yellow),
            edge("-|>"),
            blob((1.5, 0), [逆映射器\ Inverse Mapper], tint: yellow),
          )
          #align(horizon)[解码器]
        ],
        width: auto,
        tint: orange,
      ),
      edge("-|>"),
      blob((5.25, 0), [重建图像], width: auto, tint: red),
    )
  ],
  caption: "图像压缩模型",
)

- *映射器*：转换为便于去掉空间和时间冗余的形式
- *量化器*：根据预设的保真度准则降低精度，去除不相关的信息
- *符号编码器*：对量化后的数据进行定长或变长编码，压缩数据

通常在编码之前有预处理，比如图像分块。对于 JPEG 标准，图像被分成 $8 times 8$ 的块，然后进行离散余弦变换。而 JPEG2000 不强制要求分块，可以是任意大小的块。

== 无损压缩 Lossless Compression

=== Huffman 编码

变长编码，根据字符出现的频率来分配编码。出现频率高的字符用短编码，出现频率低的字符用长编码。霍夫曼编码是最短的编码。对于固定的 $n$，该编码是最优的。

=== LZW 编码

基于符号的编码，通过维护一个字典来实现。

#definition[
  *LZW 编码*：Lempel-Ziv-Welch 编码，是一种无损压缩算法，用于压缩无损数据。它是一种字典编码，通过在编码过程中动态维护一个字典，将输入的数据编码为更短的数据。
]

== 有损压缩 Lossy Compression

=== JPEG2000 和小波编码

将上面的映射器、量化器、符号编码器替换为小波变换、量化、熵编码。JPEG2000 是一种基于小波的图像压缩标准，可以是有损压缩，也可以是无损压缩，取决于量化的精度。得益于小波变换，它支持渐进式传输和重建。

具体流程步骤：
+ 图像分块：确定块的大小，然后对图像进行分块，不足可以补 0。分块的好处是减少内存占用，同时也可以部分解码。
+ 小波变换：对每个块进行小波变换，得到不同级别的小波系数。
+ 量化：对小波系数进行量化，量化的目的是减少数据量，同时也是有损压缩的关键。当然可以设计无损的量化算法，避免计算的精度损失。
+ 熵编码：对量化后的数据进行熵编码，得到压缩后的数据。
+ 重建：解码的时候，先解码熵编码，然后反量化，最后反小波变换，得到重建的图像。

JPEG2000 因为使用了小波变换，相较于 JPEG（使用离散余弦变换）有更好的压缩效果，不会出现块状失真。

