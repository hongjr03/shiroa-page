#import "../template.typ": *
#import "@preview/fletcher:0.5.0" as fletcher: diagram, node, edge
#import fletcher.shapes: house, hexagon, ellipse
#import "@preview/pinit:0.1.4": *
#import "@preview/cetz:0.2.2"
#import "/book.typ": book-page

#show: book-page.with(title: "数字图像处理基础 | DIP")


= 形态学处理 Morphological Processing

== 形态学操作

=== 腐蚀和膨胀

- 腐蚀：将结构元素放在图像上，只有结构元素完全覆盖图像时，输出为 1，否则为 0。即：$
A minus.circle B = {z | (B)_z subset.eq A}
$
  - 可以被理解为形态学滤波：把小物体过滤掉
- 膨胀：将结构元素放在图像上，只要结构元素和图像有交集，输出为 1，否则为 0。即：$
A plus.circle B = {z | (B)_z sect A eq.not diameter}
$

=== 开操作和闭操作

- 开操作：平滑边缘，断开窄的连接，去除细的突出
  - 先腐蚀再膨胀 $
  A circle.stroked.tiny B = (A minus.circle B) plus.circle B
  $
- 闭操作：连接物体，填充小的空洞，平滑物体边缘
  - 先膨胀再腐蚀 $
  A circle.filled.tiny B = (A plus.circle B) minus.circle B
  $

先开后闭可以去除小的物体，先闭后开可以去除小的空洞。

== 邻接性

=== $m$-邻接

#grid(
  columns: (1fr, 1fr, 1fr),

)[
  #figure(
    table(
      columns: (2em, 2em, 2em),
      rows: (2em, 2em, 2em),
      align: center + horizon,
      [], table.cell(fill: yellow)[], [],
      table.cell(fill: yellow)[], [A], table.cell(fill: yellow)[],
      [], table.cell(fill: yellow)[], [],
    ),
    caption: "4-邻接",
    kind: {
      image
    },
  )
][
  #figure(
    table(
      columns: (2em, 2em, 2em),
      rows: (2em, 2em, 2em),
      align: center + horizon,
      table.cell(fill: yellow)[], table.cell(fill: yellow)[], table.cell(fill: yellow)[],
      table.cell(fill: yellow)[], [A], table.cell(fill: yellow)[],
      table.cell(fill: yellow)[], table.cell(fill: yellow)[], table.cell(fill: yellow)[],
    ),
    caption: "8-邻接",
    kind: {
      image
    },
  )
][
  #figure(
    table(
      columns: (2em, 2em, 2em),
      rows: (2em, 2em, 2em),
      align: center + horizon,
      [B], [], [],
      [C], [A], [],
      [], [], [D],
    ),
    caption: "",
    kind: {
      image
    },
  )<adjacency_example>
]

@adjacency_example 中，AB 为 8-邻接，AC、BC 均为 4-邻接。由于 C 的存在，AB*不*为 $m$-邻接。但是 AD 是 $m$ 邻接的。

#note_block[
  4-邻接必有 $m$-邻接和 8-邻接；8-邻接需要判断一下 $m$-邻接。
]

$m$-邻接是为了消除歧义。


#note_block[
  尝试使用形态学操作的方法提取图片morphology.jpg中的国旗图案。
  ```py
  #task2.py
  import cv2
  import numpy as np
  import matplotlib.pyplot as plt

  image = cv2.imread('imgs/morphology.jpg')

  gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

  _, binary = cv2.threshold(gray, 158, 255, cv2.THRESH_BINARY_INV)

  # show binary image
  cv2.imwrite('outputs/exp5_2_binary.jpg', binary)

  kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (17, 17))

  morph = cv2.morphologyEx(binary, cv2.MORPH_CLOSE, kernel)
  morph = cv2.morphologyEx(morph, cv2.MORPH_OPEN, kernel)

  cv2.imwrite('outputs/exp5_2_morph.jpg', morph)


  # 寻找轮廓
  contours, _ = cv2.findContours(morph, cv2.RETR_LIST, cv2.CHAIN_APPROX_SIMPLE)

  contoured_image = cv2.drawContours(np.zeros_like(image), contours, -1, (0, 255, 0), 2)
  cv2.imwrite('outputs/exp5_2_contours.jpg', contoured_image)

  upper = 1.1
  lower = 0.9

  contour_image = np.zeros_like(image)

  i = 1
  for contour in contours:
      x, y, w, h = cv2.boundingRect(contour)
      if ((lower * 48 / 32 <= w / h <= upper * 48 / 32)
              and (lower * 48 * 32 <= w * h <= upper * 48 * 32)):
          # 保存框内的图像
          cv2.imwrite(f'outputs/exp5_2_{i}.jpg', image[y:y + h, x:x + w])
          i += 1
          # 将框内的图像 crop 出来，放到新的图像上
          contour_image[y:y + h, x:x + w] \
              = image[y:y + h, x:x + w]

  print(i)

  cv2.imwrite('outputs/exp5_2_0.jpg', contour_image)
  ```
]

