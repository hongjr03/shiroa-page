
#import "@preview/shiroa:0.1.0": *

#show: book

#book-meta(
  title: "shiroa-page",
  repository: "https://github.com/hongjr03/shiroa-page",
  repository-edit: "https://github.com/hongjr03/shiroa-page/edit/main/{path}",
  language: "zh",
  summary: [
    #prefix-chapter("main.typ")[Hello, shiroa]
    = 2024 春季学期
    - 数字图像处理 | DIP
      - #chapter("content/DIP/chapters/1导论.typ")[导论]
      - #chapter("content/DIP/chapters/2数字图像处理基础.typ")[数字图像处理基础]
      - #chapter("content/DIP/chapters/3空间域图像增强.typ")[空间域图像增强]
      - #chapter("content/DIP/chapters/4频率域图像增强.typ")[频率域图像增强]
      - #chapter("content/DIP/chapters/5图像复原.typ")[图像复原]
      - #chapter("content/DIP/chapters/6多分辨率处理.typ")[多分辨率处理]
      - #chapter("content/DIP/chapters/7图像压缩.typ")[图像压缩]
      - #chapter("content/DIP/chapters/8形态学处理.typ")[形态学处理]
      - #chapter("content/DIP/chapters/9图像分割.typ")[图像分割]
      - #chapter("content/DIP/chapters/10特征提取和模式识别.typ")[特征提取和模式识别]

    - 数据结构与算法 | DSA
      - #chapter("content/DSA/chapters/1绪论.typ")[绪论]
      - #chapter("content/DSA/chapters/2线性表.typ")[线性表]
      - #chapter("content/DSA/chapters/3栈和队列.typ")[栈和队列]
      - #chapter("content/DSA/chapters/4串.typ")[串]
      - #chapter("content/DSA/chapters/5数组和广义表.typ")[数组和广义表]
      - #chapter("content/DSA/chapters/6树和二叉树.typ")[树和二叉树]
      - #chapter("content/DSA/chapters/7图.typ")[图]
      - #chapter("content/DSA/chapters/8查找.typ")[查找]
      - #chapter("content/DSA/chapters/9排序.typ")[排序]
      - #chapter("content/DSA/chapters/10Exercise.typ")[Exercise]
  ],
)

#build-meta(dest-dir: "docs")

#get-book-meta()

// re-export page template
#import "/templates/page.typ": project, heading-reference
#let book-page = project
#let cross-link = cross-link
#let heading-reference = heading-reference