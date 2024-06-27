
#import "../template.typ": *
#import "@preview/pinit:0.1.4": *
#import "@preview/fletcher:0.5.0" as fletcher: diagram, node, edge

#import "/book.typ": book-page

#show: book-page.with(title: "树和二叉树 | DSA")

= 树和二叉树
<树和二叉树>

== 树的定义和基本术语
<树的定义和基本术语>

#definition[
  *树*：树是 $n(n >= 0)$ 个结点的有限集合。当 $n = 0$ 时，称为空树；当 $n > 0$ 时，树具有以下性质：
  - 有且仅有一个特定的称为根的结点
  - 当 $n > 1$ 时，其余结点可分为 $m(m > 0)$ 个互不相交的有限集合 $T_1, T_2, dots, T_m$，其中每一个集合本身又是一棵树，称为根的子树。
]<树的定义>

对比线性结构和树形结构：
#table(
  columns: (1fr, 1fr),
  rows: 2em,
  align: center + horizon,
  table.header([*线性结构*], [*树形结构*]),
  [第一个数据元素，无前驱], [根结点，无前驱],
  [最后一个数据元素，无后继], [多个叶子结点，无后继],
  [其他数据元素，一个前驱、一个后继], [其他结点，一个双亲、多个孩子],
)

=== 基本术语

- *结点*：数据元素+若干指向子树的分支
- *结点的度*：结点的*子树*个数（这里和离散数学中的度有所不同）
- *树的度*：树中结点的最大度
- *叶子结点*：度为 0 的结点
- *分支结点*：度不为 0 的结点
- （从根结点到某个结点的）*路径*：由从根到该结点所经分支和结点构成
- *层次*：根结点的层次为 1，其余结点的层次等于其双亲结点的层次加 1
- *树的深度*：树中结点的最大层次
- *森林*：$m(m > 0)$ 棵互不相交的树的集合 #note_block[
    任何非空树是一个二元组 $"Tree" = ("root", F)$，其中 $"root"$ 是树的根结点，$F$ 是子树森林。
  ]
- *有向树*：
  + 有确定的根结点
  + 树根和子树根之间为有向关系
- *有序树*：树中结点的各子树看成是有序的，即子树之间有次序关系
- *无序树*：子树之间无次序关系

== 二叉树

#definition[
  *二叉树*：二叉树或为空树，或是由一个根结点加上两棵分别称为左子树和右子树的、互不交的二叉树组成。
]

#note_block[
  度为 2 的树不一定是二叉树。
]

#block(breakable: false)[
  #import fletcher.shapes: house, hexagon, ellipse

  #let blob(pos, label, tint: white, ..args) = node(
    pos,
    align(center, label),
    width: auto,
    fill: tint.lighten(60%),
    stroke: 1pt + tint.darken(20%),
    corner-radius: 5pt,
    shape: circle,
    ..args,
  )

  #set figure(supplement: none)
  二叉树的五种形态：
  #grid(
    columns: (0.8fr, 0.8fr, 1fr, 1fr, 1fr),

  )[
    #figure($diameter$, caption: "空树")
  ][
    #figure(diagram(blob((0, 0), "N")), caption: "只含根结点")
  ][
    #figure(diagram(blob((0, 0), "N"), edge(), blob((-0.5, 0.5), "L")), caption: "右子树为空树")
  ][
    #figure(diagram(blob((0, 0), "N"), edge(), blob((0.5, 0.5), "R")), caption: "左子树为空树")
  ][
    #figure(
      diagram(blob((0, 0), "N"), edge(), blob((-0.5, 0.5), "L"), edge((0, 0), (0.5, 0.5)), blob((0.5, 0.5), "R")),
      caption: "左右子树均不为空",
    )
  ]
]

=== 二叉树的性质

+ 在二叉树的第 $i$ 层上至多有 $2^(i-1)$ 个结点（$i >= 1$）。
+ 深度为 $k$ 的二叉树至多有 $2^k - 1$ 个结点（$k >= 1$）。
+ 对任何一棵非空二叉树，若叶子结点数为 $n_0$，度为 2 的结点数为 $n_2$，则 $n_0 = n_2 + 1$。
+ 具有 $n$ 个结点的完全二叉树的深度为 $floor(log_2n) + 1$。#definition[
    *满二叉树*：每层结点都达到最大值的二叉树。
  ] #definition[
    *完全二叉树*：树中所含的 $n$ 个结点和满二叉树中编号为 $1$ 至 $n$ 的结点一一对应。
  ] #note_block[
    完全二叉树不一定是满二叉树，但是满二叉树一定是完全二叉树。

    判断一棵树是否是完全二叉树：
    - 从根结点开始，按层序编号
    - 若某个结点有右孩子而无左孩子，则不是完全二叉树
    - 若某个结点不是左右孩子都有，则其后的结点都是叶子结点
  ]
+ 一棵有 $n$ 个结点的完全二叉树，按层序编号，对任一结点 $i$ 有：
  - 若 $i = 1$，则 $i$ 是根，无双亲；否则其双亲是 $floor(i/2)$。
  - 若 $2i > n$，则 $i$ 无左孩子；否则左孩子是 $2i$。
  - 若 $2i + 1 > n$，则 $i$ 无右孩子；否则右孩子是 $2i + 1$。

== 二叉树的存储结构

=== 顺序存储结构

简单来说就是用数组存储二叉树的结点，按照完全二叉树的结构存储。

根节点存储在数组下标为 0 的位置，然后每个结点的左孩子存储在 $2i + 1$ 的位置，右孩子存储在 $2i + 2$ 的位置，$i$ 表示该结点在数组中的下标。同样的，如果知道一个结点的下标，可以通过 $floor((i-1)/2)$ 找到其双亲结点。

=== 链式存储结构

==== 二叉链表

结点结构：

#table(columns: ((5em, 4em, 5em)), rows: 2em, align: center + horizon, [lchild], [data], [rchild])

#figure(image("../assets/2024-06-25-16-13-50.png", width: 80%), caption: "二叉链表")

==== 三叉链表

比二叉链表多了一个指向双亲结点的指针。

#table(columns: ((5em, 5em, 4em, 5em)), rows: 2em, align: center + horizon, [parent], [lchild], [data], [rchild])

#figure(image("../assets/2024-06-25-16-15-02.png", width: 80%), caption: "三叉链表")

== 二叉树的遍历

=== 先序遍历

先访问根结点，然后依次先序遍历左子树和右子树。

#note_block[
  若二叉树为空树，则空操作；否则，

  + 访问根结点；
  + 先序遍历左子树；（递归）
  + 先序遍历右子树。（递归）
]

非递归实现：

```c
void PreOrder(Bitree T) {
    Stack S;
    InitStack(S);
    Bitree p = T;
    while (p || !StackEmpty(S)) {
        if (p) {
            visit(p->data);
            Push(S, p);
            p = p->Lchild;
        } else {
            Pop(S, p);
            p = p->Rchild;
        }
    }
}
```

=== 中序遍历

先中序遍历左子树，然后访问根结点，最后中序遍历右子树。

#note_block[
  若二叉树为空树，则空操作；否则，

  + 中序遍历左子树；（递归）
  + 访问根结点；
  + 中序遍历右子树。（递归）
]

非递归实现：

```c
void InOrder(Bitree T) {
    Stack S;
    InitStack(S);
    Bitree p = T;
    while (p || !StackEmpty(S)) {
        if (p) {
            Push(S, p);
            p = p->Lchild;
        } else {
            Pop(S, p);
            visit(p->data);
            p = p->Rchild;
        }
    }
}
```

=== 后序遍历

先后序遍历左子树，然后后序遍历右子树，最后访问根结点。

#note_block[
  若二叉树为空树，则空操作；否则，

  + 后序遍历左子树；（递归）
  + 后序遍历右子树；（递归）
  + 访问根结点；
]

非递归实现：

```c
void PostOrder(Bitree T) {
    Stack S;
    InitStack(S);
    Bitree p = T;
    Bitree r = NULL;
    while (p || !StackEmpty(S)) {
        if (p) {
            Push(S, p);
            p = p->Lchild;
        } else {
            GetTop(S, p);
            if (p->Rchild && p->Rchild != r) {
                p = p->Rchild;
            } else {
                Pop(S, p);
                visit(p->data);
                r = p;
                p = NULL;
            }
        }
    }
}
```

== 线索二叉树

结点结构：

#table(columns: (
    (5em, 4em, 5em, 4em, 5em)
  ), rows: 2em, align: center + horizon, [lchild], [ltag], [data], [rtag], [rchild])

ltag 和 rtag 用来标记是否为线索，即指向前驱和后继的指针。如果为 0，则表示指向孩子结点；如果为 1，则表示指向前驱或后继。

#image("../assets/Threaded_tree.svg", width: 37%)

== 树和森林

=== 孩子兄弟表示法

#definition[
  *孩子兄弟表示法*：以二叉链表作为树的存储结构，称为孩子兄弟表示法。
]

结点结构：

#table(columns: ((5em, 5em, 5em)), rows: 2em, align: center + horizon, [firstchild], [data], [nextsibling])

#image("../assets/2024-06-25-16-37-45.png")

=== 树的遍历

==== 先根遍历

若树不空，则先访问根结点，然后依次先根遍历各棵子树。

==== 后根遍历

若树不空，则依次后根遍历各棵子树，然后访问根结点。

==== 按层次遍历

若树不空，则从树的第一层（根结点）开始，从上而下、从左至右依次访问各结点。

==== 应用

*求树深*：

```C
int TreeDepth(CSTree T) {
    if (!T) return 0;
    else {
        h1 = TreeDepth(T->firstchild);
        h2 = TreeDepth(T->nextsibling);
        return (max(h1 + 1, h2));
    }
}// TreeDepth
```

*输出所有根到叶子结点的路径*：

```C
void AllPath(Bitree T, Stack &S) {
    /// 输出二叉树上从根到所有叶子结点的路径
    if (T) {
        Push(S, T->data);
        if (!T->Lchild && !T->Rchild) PrintStack(S);
        else {
            AllPath(T->Lchild, S);
            AllPath(T->Rchild, S);
        }
        Pop(S);
    }// if(T)
}    // AllPath
```

*输出森林中所有根到叶子结点的路径*：

```C
void OutPath(Bitree T, Stack &S) {
    // 输出森林中所有从根到叶的路径
    while (!T) {
        Push(S, T->data);
        if (!T->firstchild) Printstack(s);
        else
            OutPath(T->firstchild, s);
        Pop(S);
        T = T->nextsibling;
    }// while
}    // OutPath
```

=== 森林的遍历

树的遍历和二叉树的遍历存在对应关系：

#table(
  columns: (1fr, 1fr, 1fr),
  rows: 2em,
  align: center + horizon,
  table.header([*树*], [*森林*], [*二叉树*]),
  [先根遍历], [先序遍历], [先序遍历],
  [后根遍历], [中序遍历], [中序遍历],
)

==== 先序遍历森林

若森林不空，则可按下述规则遍历之：

+ 访问森林中第一棵树的根结点；
+ 先序遍历森林中第一棵树的子树森林；
+ 先序遍历森林中（除第一棵树之外）其余树构成的森林。

即依次从左至右对森林中的每一棵树进行先根遍历。

==== 中序遍历森林

若森林不空，则可按下述规则遍历之：

+ 中序遍历森林中第一棵树的子树森林；
+ 访问森林中第一棵树的根结点；
+ 中序遍历森林中（除第一棵树之外）其余树构成的森林。

即依次从左至右对森林中的每一棵树进行*后根遍历*。

== 哈夫曼树

#definition[
  *带权路径长度*（*WPL*）：设 $T$ 是一棵有 $n$ 个叶子结点的二叉树，每个叶子结点 $w_i$ 的权值为 $w_i$，从根结点到每个叶子结点 $w_i$ 的路径长度为 $l_i$，则 $T$ 的带权路径长度为 $
    "WPL"(T) = sum_(i=1)^(n) w_i times l_i
  $
]

#definition[
  *哈夫曼树*：带权路径长度最短的二叉树称为哈夫曼树。又称*最优二叉树*。
]

#note_block[根节点路径长度为 0，左子树路径长度加 1，右子树路径长度加 1。]

*构建*哈夫曼树的算法：

1. 从 $n$ 个权值 $w_1, w_2, dots, w_n$ 的叶子结点出发，构造 $n$ 棵只有一个结点的二叉树。
2. 在 $n$ 棵树中选取两棵根结点的权值最小的树作为左右子树构造一棵新的二叉树，且新的二叉树的根结点的权值为其左右子树根结点的权值之和。#note_block[
    使用最小堆可以快速找到最小的两个树。
  ]

3. 从 $n$ 棵树中删除选取的两棵树，并将新构造的二叉树加入到森林中。
4. 重复 2 和 3，直到森林中只有一棵树为止。

而哈夫曼编码就是根据哈夫曼树的路径来编码，路径左边为 0，右边为 1。

