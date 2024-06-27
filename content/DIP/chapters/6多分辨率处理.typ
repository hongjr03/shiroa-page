#import "../template.typ": *
#import "@preview/fletcher:0.5.0" as fletcher: diagram, node, edge
#import fletcher.shapes: house, hexagon, ellipse
#import "@preview/pinit:0.1.4": *
#import "@preview/cetz:0.2.2"
#import "/book.typ": book-page

#show: book-page.with(title: "数字图像处理基础 | DIP")


= 多分辨率处理 Multiresolution Processing

== 图像金字塔 Image Pyramids

构建过程：



#figure(
  [
    #let blob(pos, label, tint: white, ..args) = node(
      pos,
      align(center, label),
      width: 28mm,
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
      blob((0, 0), [第 $j$ 级\ 输入图像], width: auto, tint: red),
      edge("-|>"),
      edge("dddd,rrrrr", "-|>", $+$, label-pos: 0.97, label-side: center),
      blob(
        (2, 0),
        [
          近似滤波器\
          如高斯滤波器
        ],
        tint: orange,
      ),
      edge("-|>"),

      blob((4, 0), [2x下采样], tint: yellow, shape: hexagon),
      edge("-|>"),
      blob((6, 0), [第 $j+1$ 级\ 近似图像], width: auto, tint: red),
      edge((5, 0), "dddd", "-|>", $-$, label-pos: 0.88, label-side: center),
      blob((5, 1.25), [2x上采样], tint: yellow, shape: hexagon),
      blob((5, 2.25), [插值滤波器], tint: orange),
      blob((5, 4), [$+$], shape: circle, width: auto, tint: red),
      edge("-|>"),
      blob((6, 4), [第 $j$ 级\ 预测残差图像], width: auto, tint: red),
    )
  ],
  // caption: "高斯金字塔构建过程",
)

构建高斯金字塔的时候，先对图像进行高斯滤波，然后下采样。PPT上提到下采样也是通过高斯滤波来实现的，因为直接下采样（只拿奇数、偶数位置的像素点）会导致混叠、失真。

接着对每一步结果进行上采样（隔行、隔列补0），然后滤波（也是用的高斯滤波核，但是因为信息量只有$1/4$，所以核的权重$times 4$），再和上一步的结果相减，这样就得到了拉普拉斯金字塔。

#figure(image("../assets/2024-06-22-11-59-37.png", width: 78%))

== 小波变换 Wavelet Transform

#figure([
  #let blob(
    pos,
    label,
    tint: white,
    ..args,
  ) = node(
    pos,
    align(center, label),
    width: auto,
    inset: 6pt,
    // fill: tint.lighten(60%),
    // stroke: 1pt + tint.darken(20%),
    // corner-radius: 5pt,
    ..args,
  )
  #diagram(
    spacing: 8pt,
    cell-size: (8mm, 10mm),
    edge-stroke: 1pt,
    edge-corner-radius: 5pt,
    mark-scale: 70%,
    blob((0, 0), $W_phi (j+1, n)$, width: auto),
    blob((2, -.5), $h_psi (-n)$, shape: rect, stroke: 1pt + black),
    edge("-|>"),
    blob((3.5, -.5), $2↓$, shape: rect, stroke: 1pt + black),
    edge("-|>"),
    blob((5, -.5), $W_psi (j, n)$, width: auto),
    blob((2, .5), $h_phi (-n)$, shape: rect, stroke: 1pt + black),
    edge("-|>"),
    blob((3.5, .5), $2↓$, shape: rect, stroke: 1pt + black),
    edge("-|>"),
    blob((5, .5), $W_phi (j, n)$, width: auto),
    for y in (-.5, .5) {
      edge((0, 0), "r", (1, y), "r", "-|>")
    },
  )])

