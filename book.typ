
#import "@preview/shiroa:0.1.0": *

#show: book

#book-meta(
  title: "shiroa-page",
  repository: "https://github.com/hongjr03/shiroa-page",
  repository-edit: "https://github.com/hongjr03/shiroa-page/edit/main/{path}",
  language: "zh",
  summary: [
    #prefix-chapter("main.typ")[Hello, shiroa]
    - #chapter("24spring.typ", section: none)[2024 春季学期]
    
    = 数字图像处理 | DIP
    - #chapter("DIP/chapters/1导论.typ", section: "1")[导论]
    - #chapter("DIP/chapters/2数字图像处理基础.typ", section: "2")[数字图像处理基础]
    - #chapter("DIP/chapters/3空间域图像增强.typ", section: "3")[空间域图像增强]
    - #chapter("DIP/chapters/4频率域图像增强.typ", section: "4")[频率域图像增强]
    - #chapter("DIP/chapters/5图像复原.typ", section: "5")[图像复原]
    - #chapter("DIP/chapters/6多分辨率处理.typ", section: "6")[多分辨率处理]
    - #chapter("DIP/chapters/7图像压缩.typ", section: "7")[图像压缩]
    - #chapter("DIP/chapters/8形态学处理.typ", section: "8")[形态学处理]
    - #chapter("DIP/chapters/9图像分割.typ", section: "9")[图像分割]
    - #chapter("DIP/chapters/10特征提取和模式识别.typ", section: "10")[特征提取和模式识别]

    = 数据结构与算法 | DSA
    - #chapter("DSA/chapters/1绪论.typ", section: "1")[绪论]
    - #chapter("DSA/chapters/2线性表.typ", section: "2")[线性表]
    - #chapter("DSA/chapters/3栈和队列.typ", section: "3")[栈和队列]
    - #chapter("DSA/chapters/4串.typ", section: "4")[串]
    - #chapter("DSA/chapters/5数组和广义表.typ", section: "5")[数组和广义表]
    - #chapter("DSA/chapters/6树和二叉树.typ", section: "6")[树和二叉树]
    - #chapter("DSA/chapters/7图.typ", section: "7")[图]
    - #chapter("DSA/chapters/8查找.typ", section: "8")[查找]
    - #chapter("DSA/chapters/9排序.typ", section: "9")[排序]
    - #chapter("DSA/chapters/10Exercise.typ", section: "10")[Exercise]

    = 移动软件开发 | WXAPP
    - #chapter("WXAPP/lab1/main.typ", section: "1")[实验 1：第一个微信小程序]
    - #chapter("WXAPP/lab2/main.typ", section: "2")[实验 2：天气查询小程序]
  ],
)

#build-meta(dest-dir: "docs")

#get-book-meta()

// re-export page template
#import "/templates/page.typ": project, heading-reference
#let book-page = project
#let cross-link = cross-link
#let heading-reference = heading-reference