#import "../template.typ": *
#import "@preview/fletcher:0.5.0" as fletcher: diagram, node, edge
#import fletcher.shapes: house, hexagon, ellipse
#import "@preview/pinit:0.1.4": *
#import "@preview/cetz:0.2.2"
#import "/book.typ": book-page

#show: book-page.with(title: "数字图像处理基础 | DIP")


= 图像分割 Image Segmentation

== 分水岭算法 Watershed Algorithm

将图像的灰度值视为地形的高度，然后将水注入到每个局部最小值的区域，当水位线相遇时，就会形成分割线。

== 霍夫变换 Hough Transform

霍夫变换是一种检测图像中直线、圆等形状的方法。原理是将直线表示为极坐标形式，然后在极坐标空间中找到交点。

#grid(
  columns: (1fr, 1fr),

)[
  #figure(
    [
      #set text(size: 9pt)
      #set par(leading: 1em)
      #cetz.canvas({
        import cetz.draw: *
        import cetz.plot
        // import cetz.palette: *
        plot.plot(
          size: (5, 5),
          x-min: 0,
          x-max: 10,
          y-min: 0,
          y-max: 120,
          x-tick-step: none,
          y-tick-step: none,
          x-label: $x$,
          y-label: $y$,
          axis-style: "left",
          name: "Hough",
          {
            let line(x) = {
              10 * x + 20
            }
            plot.add(domain: (0, 10), line)
            plot.add-anchor("pt1", (2, 40))
            plot.add-anchor("pt2", (8, 100))
            plot.add-anchor("end", (10, 120))
          },
        )
        circle("Hough.pt1", radius: 2pt, fill: red)
        content("Hough.pt1", $(x_1,y_1)$, anchor: "west", padding: .1)
        circle("Hough.pt2", radius: 2pt, fill: red)
        content("Hough.pt2", $(x_2,y_2)$, anchor: "west", padding: .1)
        content("Hough.end", $y = a_0 x + b_0$, anchor: "west", padding: .1)
      })],
    caption: [$x-y$ 平面],
  )
][
  #figure(
    [
      #set text(size: 9pt)
      #set par(leading: 1em)
      #cetz.canvas({
        import cetz.draw: *
        import cetz.plot
        // import cetz.palette: *
        plot.plot(
          size: (5, 5),
          x-min: 0,
          x-max: 20,
          y-min: 0,
          y-max: 100,
          x-tick-step: none,
          y-tick-step: none,
          x-label: $a$,
          y-label: $b$,
          axis-style: "left",
          name: "Hough",
          {
            let line1(a) = {
              -2 * a + 40
            }
            let line2(a) = {
              -8 * a + 100
            }
            plot.add(domain: (0, 20), line1)
            plot.add-anchor("end1", (18, 8))
            plot.add(domain: (0, 20), line2)
            plot.add-anchor("end2", (6, 55))
            plot.add-anchor("p", (10, 20))
          },
        )
        circle("Hough.p", radius: 2pt, fill: red)
        content("Hough.p", $(a_0, b_0)$, anchor: "south-west", padding: .1)
        content("Hough.end1", $b = -x_1 a + y_1$, anchor: "west", padding: .1)
        content("Hough.end2", $b = -x_2 a + y_2$, anchor: "west", padding: .1)
      })],
    caption: [$a-b$ 平面],
  )
]

这样提取出轮廓之后，阈值处理后对每两个点之间进行霍夫变换，就可以得到每条直线的参数。在 $a-b$ 平面上，直线的交点就是直线的参数，找到直线经过最多的点，就是最终的直线。

但 $a-b$ 平面是无界的，所以一般用法向量来表示直线，然后变换到 $theta-rho$ 空间。

#grid(
  columns: (1fr, 1fr),

)[
  #figure(
    [
      #set text(size: 9pt)
      #set par(leading: 1em)
      #cetz.canvas({
        import cetz.draw: *
        import cetz.plot
        // import cetz.palette: *
        plot.plot(
          size: (5, 5),
          x-min: 0,
          x-max: 10,
          y-min: 0,
          y-max: 10,
          x-tick-step: none,
          y-tick-step: none,
          x-label: $x$,
          y-label: $y$,
          axis-style: "left",
          name: "Hough",
          {
            let line(x) = {
              -x + 10
            }
            let line1(x) = {
              x
            }
            plot.add(domain: (0, 10), line)
            plot.add-anchor("pt1", (3, 7))
            plot.add-anchor("pt2", (7, 3))
            plot.add-anchor("end", (9, 1))
            plot.add(domain: (0, 5), line1)
          },
        )
        circle("Hough.pt1", radius: 2pt, fill: red)
        content("Hough.pt1", $(x_1,y_1)$, anchor: "west", padding: .1)
        circle("Hough.pt2", radius: 2pt, fill: red)
        content("Hough.pt2", $(x_2,y_2)$, anchor: "west", padding: .1)
        content("Hough.end", $y = a x + b$, anchor: "west", padding: .1)
        arc((1, 0), start: 0deg, stop: 45deg)
        content((0.75, 0.5), $theta_0$, anchor: "west", padding: .3)
        content((1.25, 1.25), $rho_0$, anchor: "south", padding: .1)
      })],
    caption: [$x-y$ 平面],
  )
][
  #figure(
    [
      #set text(size: 9pt)
      #set par(leading: 1em)
      #cetz.canvas({
        import cetz.draw: *
        import cetz.plot
        // import cetz.palette: *
        plot.plot(
          size: (5, 5),
          x-min: 0,
          x-max: calc.pi,
          y-min: 0,
          y-max: 10,
          x-tick-step: calc.pi/4,
          y-tick-step: none,
          x-label: $theta$,
          y-label: $rho$,
          axis-style: "left",
          name: "Hough",
          {
            let line1(theta) = {
              3 * calc.cos(theta) + 7 * calc.sin(theta)
            }
            let line2(theta) = {
              7 * calc.cos(theta) + 3 * calc.sin(theta)
            }
            plot.add(domain: (0, calc.pi), line1)
            plot.add-anchor("end1", (2.2, 4))
            plot.add(domain: (0, calc.pi), line2)
            plot.add-anchor("end2", (1.8, 2))
            plot.add-anchor("p", (0.78, 7.05))
          },
        )
        circle("Hough.p", radius: 2pt, fill: red)
        content("Hough.p", $(theta_0, rho_0)$, anchor: "south", padding: .4)
        content("Hough.end1", $rho = x cos(theta) + y sin(theta)$, anchor: "west", padding: .1)
        content("Hough.end2", $rho = x cos(theta) - y sin(theta)$, anchor: "west", padding: .1)
      })],
    caption: [$theta-rho$ 平面],
  )
]

这样就可以只观察一个周期内的图像，还是找交点。如果要用于边缘连接，那就可以在找到的直线上逐个像素进行判断，如果距离小于某个阈值，就给它们连线。


