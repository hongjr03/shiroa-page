
#import "../template.typ": *
#import "@preview/pinit:0.1.4": *
#import "@preview/fletcher:0.5.0" as fletcher: diagram, node, edge

#import "/book.typ": book-page

#show: book-page.with(title: "练习 | DSA")

= Exercise

== 绪论

1. 多叉路口交通灯的管理问题，采用（~*D*~）关系的数据结构。#rel("逻辑结构") \ A. 集合\ B. 线性\ C. 树形\ D. 图状

2. （~*D*~）是相互之间存在一种或多种特定关系的数据元素的集合。#rel("基本概念") \ A. 数据\ B. 数据元素\ C. 数据对象\ D. 数据结构

3. 一个算法必须总是（对任何合法的输入值）在执行有穷步之后结束，是指算法的（~*A*~）特性。#rel("算法的特性") \ A. 有穷性\ B. 可行性\ C. 确定性\ D. 正确性

4. 下列算法的执行频度为（~*C*~）。
  ```c
  for (l = 1; l <= n; ++l)
    for (j = 1; j <= n; ++j) {
        c[l][j] = 0;
    }
  ```
  #rel("算法复杂性分析") \ A. $O(n)$\ B. $O(n^3)$\ C. $O(n^2)$\ D. $O(n log n)$

5. 机器人和人对弈问题中，棋盘格局之间的关系为（~*B*~）。#rel("逻辑结构") \ A. 集合\ B. 线性结构\ C. 树形结构\ D. 图状结构

6. （~*C*~）是性质相同的数据元素的集合，是数据的一个子集。#rel("基本概念") \ A. 数据\ B. 数据元素\ C. 数据对象\ D. 数据结构

7. 下列算法的执行频度为（~*B*~）。 #rel("算法复杂性分析")
  ```c
  for (l = 1; l <= n; ++l)
      for (j = 1; j <= n; ++j) {
          c[l][j] = 0;
          for (k = 1; k <= n; ++k) {
              c[l][j] += a[l][k] * b[k][j];
          }
      }

  ```\ A. $O(n)$\ B. $O(n^3)$\ C. $O(n^2)$\ D. $O(n log n)$

8. 设有 $n$ 件物品，重量分别为 $w_1, w_2, w_3, dots, w_n$ 和一个能装载总重量为 $T$ 的背包。能否从 $n$ 件物品中选择若干件恰好使它们的重量之和等于 $T$。若能，则背包问题有解，否则无解。请写出求解此问题的递归算法。

  ```cpp
  bool choose[n] = {false};
  int w[n] = {w_1, w_2, w_3, ..., w_n};

  bool knapsack(int i, int T) {
      if (T == 0) return true;
      if (i < 1) return false;
      if (w[i] > T) return knapsack(i - 1, T);
      if (knapsack(i - 1, T - w[i])) {
          choose[i] = true;
          return true;
      } else {
          choose[i] = false;
          return knapsack(i - 1, T);
      }
  }
  ```

9. 补充课后题 1.1、1.8。


== 线性表

1. 链表中逻辑上相邻的元素的物理地址（~*B*~）相邻。#rel("线性表的链式表示和实现") \ A. 必定\ B. 不一定\ C. 一定不\ D. 其它

2. 顺序表中逻辑上相邻的元素的物理地址（~*A*~）相邻。#rel("线性表的顺序表示和实现") \ A. 必定\ B. 有可能\ C. 一定不\ D. 其它

3. 在顺序表中插入或删除一个元素，需要平均移动 #underline[~*n/2*~] 个元素，具体移动的元素个数与插入或删除的位置有关。#rel("线性表的顺序表示和实现")

4. 用链式存储时，结点的存储位置（~*B*~）。#rel("线性表的链式表示和实现") \ A. 必须是不连续的\ B. 连续与否均可\ C. 必须是连续的\ D. 和头结点的存储地址相连续

5. 在单链表中，要访问某个结点，只要知道该结点的指针即可；因此，单链表是一种随机存取结构。（~*错*~）#rel("线性表的链式表示和实现")

6. 补充课后题 2.1、2.2、2.3、2.4、2.6、2.11、2.12。


== 栈和队列

1. 操作系统中的作业调度采用（~*C*~）结构。#rel("栈和队列") \ A. 顺序表\ B. 栈\ C. 队列\ D. 图

2. 数制转换采用（~*B*~）结构。#rel("栈和队列") \ A. 顺序表\ B. 栈\ C. 队列\ D. 图

3. 栈结构中数据元素之间呈 #underline[~*后进先出*~] 关系。#rel("栈和队列")

4. 设计一个判别表达式中左、右括号是否配对的算法，采用（~*B*~）数据结构最佳。#rel("栈和队列") \ A. 线性表的顺序存储结构\ B. 栈\ C. 队列\ D. 线性表的链式存储结构

5. 补充课后题 3.1、3.2、3.5、3.6、3.17。

== 串

1. （~*D*~）是由零个或多个字符组成的有限序列。#rel("串的基本概念") \ A. 数组\ B. 文本\ C. 线性表\ D. 字符串

2. 设 s = 'I AM A STUDENT'，t = 'GOOD'，q = 'WORKER'，则 Concat(Substring(s, 6, 2), Concat(t, q)) 的值为（~*A*~）。#rel("串的基本操作") \ A.
  `A GOODWORKER`\ B. `ST GOODSTUDENT`\ C. `A GOOD STUDENT`\ D. `A GOOD WORKER`

3. 在汇编和语言的编译程序中，源程序及目标程序都是（~*D*~）数据。\ A. 数组\ B. 文本\ C. 数值\ D. 字符串

4. 设 s = 'I AM A STUDENT'，t = 'GOOD'，q = 'WORKER'，则 Concat(Substring(s, 6, 2), Concat(t, SubString(s, 7, 8))) 的值为（~*C*~）。#rel("串的基本操作") \ A.
  `A GOODSTUDENT`\ B. `ST GOODSTUDENT`\ C. `A GOOD STUDENT`\ D. `TU GOODDENT`

5. 补充课后题 4.3、4.4。

== 数组和广义表

1. 广义表是（~*B*~）的推广。#rel("数组和广义表") \ A. 数组\ B. 线性表\ C. 队列\ D. 树

2. 线性表可以看成是广义表的特例，如果广义表中的每个元素都是原子，则广义表便成为线性表。（~*对*~）#rel("数组和广义表")

3. 广义表中原子个数即为广义表的长度。（~*错*~）#rel("数组和广义表")

4. 补充课后题 5.1、5.2、5.10、5.11、5.12、5.13、5.19（复杂度）、5.38。

== 树和二叉树

1. 有一非空树，其度为 $5$，已知度为 $i$ 的节点数有 $i$ 个，其中 $1<=i<=5$，证明其终端节点个数为 $41$。

2. 已知一棵 $3$ 阶 B-树如图所示，画出插入关键字 33，97 后得到的 B-树。

  #import fletcher.shapes: house, hexagon, ellipse

  #let blob(pos, label, tint: white, ..args) = node(
    pos,
    align(center, label),
    width: auto,
    fill: tint.lighten(60%),
    stroke: 1pt + tint.darken(20%),
    corner-radius: 5pt,
    shape: ellipse,
    ..args,
  )

  #figure(
    diagram(
      spacing: 8pt,
      cell-size: (8mm, 10mm),
      edge-stroke: 1pt,
      edge-corner-radius: 5pt,
      mark-scale: 70%,
      blob((0, -1), "43"),
      edge(bend: -30deg),
      edge("drr", bend: 30deg),
      blob((-2, 0), "20"),
      edge(bend: -30deg),
      blob((-3, 1), "16"),
      edge((-2, 0), (-1, 1), bend: 30deg),
      blob((-1, 1), "35, 41"),
      blob((2, 0), "50, 60"),
      edge(bend: -30deg),
      blob((1, 1), "48"),
      edge((2, 0), (2, 1), bend: 30deg),
      blob((2, 1), "57"),
      edge((2, 0), (3, 1), bend: 30deg),
      blob((3, 1), "66, 88"),
    ),
  )

3. 对某二叉树进行前序遍历的结果为 abdefc，中序遍历的结果为 dbfeac，则后序遍历的结果为 #underline[~~~~~~~~~~~~~~~~~~~~~~~~~] 。

4. 深度为 $k$ 的二叉树至多有 $underline(2^k-1)$ 个结点。

5. 树中某一结点的度是该结点的 #underline[~~~~~~~~~~~~~~]。

6. 一棵二叉树中度为 $1$ 的结点个数为 $8$，度为 $2$ 的结点个数为 $10$，该二叉树共有 #underline[~~~~~~~~~~~~~~] 个结点。

7. 已知森林对应的二叉树如下图所示，画出原来的森林，并写出该森林按前序和中序遍历的结果。

  #figure(
    diagram(
      spacing: 8pt,
      cell-size: (8mm, 10mm),
      edge-stroke: 1pt,
      edge-corner-radius: 5pt,
      blob((0, 0), "a"),
      edge(),
      blob((-2, 1), "b"),
      edge(),
      blob((-3, 2), "d"),
      edge((-2, 1), (-1, 2)),
      blob((-1, 2), "e"),
      edge((0, 0), (2, 1)),
      blob((2, 1), "c"),
      edge((2, 1), (1, 2)),
      blob((1, 2), "f"),
      edge((2, 1), (3, 2)),
      blob((3, 2), "g"),
    ),
    caption: "二叉树",
  )

8. 对关键字 may，mar，apr，jul，aug，sep，oct，nov，feb，jan，dec，jun 依次输入，构建二叉排序树。

9. 已知某系统在通信联络中只可能出现 10 种字符，其出现概率分别为 $0.03$，$0.19$，$0.07$，$0.12$，$0.15$，$0.10$，$0.05$，$0.08$，$0.11$，$0.10$。请构建哈夫曼树并设计编码。

10. 在一非空二叉树的中序遍历序列中，根节点右边的部分（~*A*~）。\ A. 只有右子树上所有的结点\ B. 只有右子树上的部分结点\ C. 只有左子树上的部分结点\ D. 只有左子树上所有的结点

11. 深度为 $5$ 的二叉树至多有（~*C*~）个结点。\ A. $16$ 个\ B. $32$ 个\ C. $31$ 个\ D. $10$ 个

12. 已知一棵二叉树的前序序列和中序序列分别为 ABCDEFGHIJ 和 BCDAFEHJIG，求该二叉树的后序序列并给出该二叉树对应的森林。

13. 线索二叉树比二叉树较为容易添加结点。（~*错*~）#note_block[
    原因：线索二叉树的结点添加操作需要考虑结点的前驱和后继，因此比二叉树的结点添加操作复杂。
  ]

14. 二叉树只有在二叉树只有一个根的情况下三种遍历结果相同。（~*错*~）#note_block[
    空树也是二叉树。
  ]

15. 对于输入关键字序列 48，70，65，33，24，56，12，92，建一棵平衡二叉树，画出过程（至少每次调整有一张，标出最小不平衡子树的根）。

16. 已知树的先根访问序列为 GFKDAIEBCHJ，后根次序访问序列为 DIAEKFCJHBG。画出满足上述访问序列对应的树及所对应的二叉树。

17. 设二叉排序树已经以二叉链表的形式存储，使用递归方法，求各结点的平衡因子并输出。\
  *要求*：\
  + 用文字写出实现上述过程的基本思想；
  + 写出算法。

  ```c
  int calculateBalanceFactors(TreeNode *node) {
      if (node == NULL) {
          return 0;
      }
      int leftHeight = calculateBalanceFactors(node->left);
      int rightHeight = calculateBalanceFactors(node->right);
      node->balanceFactor = leftHeight - rightHeight;
      printf(
              "Node value: %d, Balance Factor: %d\n",
              node->val,
              node->balanceFactor
      );
      return (leftHeight > rightHeight ? leftHeight : rightHeight) + 1;
  }
  ```

18. 补充课后题 6.1、6.2、6.3、6.5、6.6、6.13、6.19、6.20、6.21、6.22、6.23、6.24、6.26、6.27、6.28、6.29。

== 图

1. 对于下图所示的 AOE 网络，计算各事件顶点的 $v e(i)$ 和 $v l(i)$ 值，并标出关键路径。

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

  #diagram(
    blob((0, 2), "a"),
    edge("urr", "-|>", label: "6"),
    edge("drr", "-|>", label: "4"),
    edge("ddrr", label: "5"),
    blob((2, 1), "b"),
    edge("drr", "-|>", label: "1"),
    blob((2, 3), "c"),
    edge("urr", "-|>", label: "1"),
    blob((4, 2), "e"),
    edge("urr", "-|>", label: "8"),
    edge("drr", "-|>", label: "7"),
    blob((2, 4), "d"),
    edge("rr", "-|>", label: "2"),
    blob((4, 4), "f"),
    edge("urr", "-|>", label: "4"),
    blob((6, 1), "g"),
    edge("drr", "-|>", label: "2"),
    blob((6, 3), "h"),
    edge("urr", "-|>", label: "2"),
    blob((8, 2), "k"),
  )

2. 已知以二维数组表示的有向图的邻接矩阵如下图所示，完成如下要求：
  + 画出该有向图；
  + 画出邻接表。

    #table(
      columns: (2em, 2em, 2em, 2em, 2em, 2em, 2em, 2em),
      rows: (2em, 2em, 2em, 2em, 2em, 2em, 2em, 2em),
      stroke: (x, y) => {
        if x == 0 {
          (right: 1pt)
        }
        if y == 0 {
          (bottom: 1pt)
        }
      },
      table.header([], [1], [2], [3], [4], [5], [6], [7]),
      [1], [0], [1], [1], [1], [0], [0], [0],
      [2], [0], [0], [1], [0], [0], [1], [0],
      [3], [0], [0], [0], [1], [1], [1], [0],
      [4], [0], [0], [0], [0], [1], [0], [0],
      [5], [0], [0], [0], [0], [0], [1], [1],
      [6], [1], [1], [0], [0], [0], [0], [1],
      [7], [0], [0], [0], [0], [0], [0], [0],
    )

3. $n$ 个顶点的连通图至少有 #underline[~~~~~~~~~~~~~~] 条边。

4. 设无向图的顶点个数为 $n$，则该图最多有 #underline[~~~~~~~~~~~~~~] 条边。

5. 画出该无向图的邻接表，并按普利姆算法画出由顶点 1 开始的最小生成树。（要求体现出每条边被加入的顺序）

  #diagram(
    blob((0, 2), "1"),
    edge("urr", "-|>", label: "1"),
    edge("rr", "-|>", label: "2"),
    edge("drr", "-|>", label: "3"),
    blob((2, 1), "2"),
    edge("drr", "-|>", label: "4"),
    blob((2, 2), "3"),
    edge("d", "-|>", label: "1"),
    edge("rr", "-|>", label: "5"),
    blob((2, 3), "4"),
    edge("urr", "-|>", label: "2"),
    blob((4, 2), "5"),
  )

6. 在一个有向图中，所有顶点的入度之和等于所有顶点的出度之和的（~*B*~）。\ A. $1/2$\ B. $1$ 倍\ C. $2$ 倍\ D. $4$ 倍

7. 具有 6 个顶点的无向连通图至少应该有 #underline[~~~~~~~~~~~~~~] 条边。

8. 下图是带权有向图 $G$ 的邻接矩阵表示，给出按 Floyd 算法求所有顶点对之间的最短路径的过程（只要求距离变化矩阵序列）。

  #table(
    columns: (2em, 2em, 2em, 2em, 2em),
    rows: (2em, 2em, 2em, 2em, 2em),
    stroke: (x, y) => {
      if x == 0 {
        (right: 1pt)
      }
      if y == 0 {
        (bottom: 1pt)
      }
    },
    table.header([], [$v_1$], [$v_2$], [$v_3$], [$v_4$]),
    [$v_1$], [0], [1], [$oo$], [4],
    [$v_2$], [$oo$], [0], [9], [2],
    [$v_3$], [3], [5], [0], [8],
    [$v_4$], [$oo$], [$oo$], [6], [0],
  )

9. 普利姆算法适合用于稠密图。（~*对*~）

10. 补充课后题 7.1、7.7、7.9、7.10、7.11、7.22、7.23，着重记 DFS、BFS、迪杰斯特拉算法。

== 查找

1. 设有一组关键字 ${9, 01, 23, 14, 55, 20, 84, 27}$，采用哈希函数 $H("key") = "key" mod 7$，表长为 $10$，用开放定址法的二次探测再散列方法 $H_1(i) = (H("key") + i^2) mod 10$，$i = 1, 2, 3, dots$，构造哈希表，指出有哪些同义词并计算查找成功的平均查找长度。

2. 设有一组关键字 ${22, 41, 53, 46, 30, 13, 01, 67}$，采用哈希函数 $H("key") = 3 * "key" mod 11$，表长为 $10$。
  1. 用线性探测再散列法构造哈希表；
  2. 求在等查找概率下的平均查找长度。

3. 哈希表的查找效率主要取决于哈希表造表时选取的哈希函数和处理冲突的方法。（~*错*~）

4. 设有一组关键字 ${01, 25, 20, 31, 63, 65, 70, 74, 79, 82}$，如果进行折半查找，则查找到每个关键字所需要的比较次数分别是多少？并求出在等查找概率下的ASL。