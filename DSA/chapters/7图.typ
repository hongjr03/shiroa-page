
#import "../template.typ": *
#import "@preview/pinit:0.1.4": *
#import "@preview/fletcher:0.5.0" as fletcher: diagram, node, edge

#import "/book.typ": book-page

#show: book-page.with(title: "图 | DSA")

= 图
<图>

== 图的定义和术语
<图的定义和术语>

#definition[
  *图*：有向图是由一个顶点集 $V$ 和一个弧集 $R$ 组成的二元组 $G = (V, R)$。无向图是由一个顶点集 $V$ 和一个边集 $E$ 组成的二元组 $G = (V, E)$。
]

*术语*：

- *网*：带权的图
- *子图*：$G = (V', E')$ 是 $G = (V, E)$ 的子图，当 $V' subset.eq V$ 且 $E' subset.eq E$。
- *完全图*：每两个顶点之间都有边的图，无向图中有 $n(n-1)/2$ 条边，有向图中有 $n(n-1)$ 条边。
- *稀疏图*：边数小于 $n log n$ 的图。
- *稠密图*：不是稀疏图的图。
- *邻接*：两个顶点之间有边，两个顶点互为邻接点。
- *关联*：边与顶点之间有关系，关联的边的数目称为顶点的*度*。
- *连通图*：无向图中任意两个顶点之间都有路径。
- *连通分量*：非连通图中的极大连通子图。
- *强连通图*：有向图中任意两个顶点之间都有路径。
- *强连通分量*：非强连通图中的极大强连通子图。
- *生成树*：连通图的生成树是一个极小连通子图，包含图中所有顶点，但只有足以构成一棵树的 $n-1$ 条边。
- *生成森林*：非连通图的生成森林是它的各连通分量的生成树的集合。

== 图的存储结构

=== 邻接矩阵

#definition[
  *邻接矩阵*：对于一个有 $n$ 个顶点的图，可以用一个 $n times n$ 的矩阵来表示，矩阵的元素 $a_(i j)$ 表示顶点 $v_i$ 和顶点 $v_j$ 之间是否有边，以及边的权值。
]

对于无向图，邻接矩阵是对称的；对于有向图，邻接矩阵不一定对称。

=== 邻接表

弧结点结构：

#table(
  columns: (5em, 5em, 5em),
  rows: 2em,
  align: center + horizon,
  [adjvex], [nextarc], [info],
)

```c
typedef struct ArcNode {
    int adjvex;             // 该弧所指向的顶点的位置
    struct ArcNode *nextarc;// 指向下一条弧的指针
    InfoType *info;         // 该弧相关信息的指针
} ArcNode;
```

顶点结点结构：

#table(
  columns: (5em, 5em),
  rows: 2em,
  align: center + horizon,
  [data], [firstarc],
)

```c
typedef struct VNode {
    VertexType data;  // 顶点信息
    ArcNode *firstarc;// 指向第一条依附该顶点的弧
} VNode, AdjList[MAX_VERTEX_NUM];
```

图的结构：

```c
typedef struct {
    AdjList vertices;
    int vexnum, arcnum;//图的当前顶点数和弧数
    int kind;          // 图的种类标志
} ALGraph;
```

#grid(
  columns: 2,

)[#image("../assets/2024-06-25-19-00-40.png")][#image("../assets/2024-06-25-19-01-06.png")][#image("../assets/2024-06-25-19-01-33.png")]

== 图的遍历

=== 深度优先搜索 DFS

#definition[
  *深度优先搜索*：从图中某个顶点 $v$ 出发，访问此顶点，然后从 $v$ 的未被访问的邻接点 $w$ 出发深度优先搜索 $w$ 的邻接点，直至图中所有和 $v$ 有路径相通的顶点都被访问到。
]

基本思想：模仿树的先序遍历，从一个顶点出发，沿着一条路径访问到最深的顶点，然后回溯，访问其他路径。

如何判别 $V$ 的邻接点是否被访问？
#note_block[
  为了避免重复访问，可以设置一个访问标志数组 `visited`，每次访问一个顶点时，将其标志位置为已访问。
]

```c
void DFS(Graph G, int v) {
    // 从顶点v出发，深度优先遍历图 G
    visited[v] = TRUE;
    VisitFunc(v);//访问第v个顶点
    for (w = FirstAdjVex(G, v); w != 0; w = NextAdjVex(G, v, w))
        if (!visited[w]) DFS(G, w);
        // 对v的尚未访问的邻接顶点w递归调用DFS
}// DFS

void DFSTraverse(Graph G, Status (*Visit)(int v)) {
    // 对图 G 作深度优先遍历。
    VisitFunc = Visit;
    for (v = 0; v < G.vexnum; ++v)
        visited[v] = FALSE;// 访问标志数组初始化
    for (v = 0; v < G.vexnum; ++v)
        if (!visited[v]) DFS(G, v);
    // 对尚未访问的顶点调用DFS
}
```

非递归算法：

```C
void DFS(Graph G, int v) {//从v出发深度优先搜索图G
    int w;
    InitStack(S);//初始化栈
    Push(S, v);
    visited[v] = TRUE;
    while (!StackEmpty(S)) {
        Pop(S, v);
        visit(w);
        w = FirstAdjVertex(G, v);//求v的第一个邻接点
        while (w != -1) {
            if (!visited[w]) {
                Push(S, w);
                visited[w] = TRUE;
            }
            w = NextAdjVertex(G, v, w);
            //求v相对于w的下一个邻接点
        }//end while
    }    //end while
}        //DFS
```

遍历顺序取决于邻接表中顶点的顺序。

=== 广度优先搜索 BFS

#definition[
  *广度优先搜索*：从图中某个顶点 $v$ 出发，访问此顶点，然后访问 $v$ 的所有邻接点，再依次访问邻接点的邻接点，直至图中所有和 $v$ 有路径相通的顶点都被访问到。
]

基本思想：模仿树的层次遍历，从一个顶点出发，依次访问其邻接点，然后再访问邻接点的邻接点。

#image("../assets/2024-06-25-19-13-30.png")

```c
void BFSTraverse(Graph G, Status (*Visit)(int v)) {
    //按广度优先非递归遍历图G，使用辅助队列Q和
    //访问标志数组visited
    for (v = 0; v < G.vexnum; ++v)
        visited[v] = FALSE;//初始化访问标志
    InitQueue(Q);          // 置空的辅助队列Q
    for (v = 0; v < G.vexnum; ++v)
        if (!visited[v]) {// v 尚未访问
            visited[u] = TRUE;
            Visit(u);     // 访问u
            EnQueue(Q, v);// v入队列
            while (!QueueEmpty(Q)) {
                DeQueue(Q, u);
                // 队头元素出队并置为u
                for (w = FirstAdjVex(G, u); w >= 0;
                     w = NextAdjVex(G, u, w))
                    if (!visited[w]) {//W为u的尚未访问的邻接顶点
                        visited[w] = TRUE;
                        Visit(w);
                        EnQueue(Q, w);// 访问的顶点w入队列
                    }                 // if
            }                         // while
        }
}// BFSTraverse
```

== 最小生成树

#definition[
  *最小生成树*：带权图中，权值之和最小的生成树称为最小生成树。
]

两种常用的算法：

- *Prim 算法*：从一个顶点出发，每次选择与当前顶点*集合*相邻的最短边，直到所有顶点都被包含在最小生成树中。（归并*顶点*，适用于稠密网）
- *Kruskal 算法*：按照边的权值从小到大的顺序选择 $n-1$ 条边，并保证这 $n-1$ 条边不构成回路，如此重复，直至加上 $n-1$ 条边为止。。（归并*边*，适用于稀疏网）

== 有向无环图及其应用

#definition[
  *有向无环图*：无回路的有向图称为有向无环图。
]

=== 拓扑排序

#definition[
  *拓扑排序*：将有向无环图中的所有顶点排成一个线性序列，使得图中任意一条边 $(v_i, v_j)$，$v_i$ 在序列中出现在 $v_j$ 之前。
]

拓扑排序的算法：

1. 从有向图中选择一个没有前驱的顶点并输出。（入度为 $0$）
2. 从图中删除该顶点和所有以它为*尾*的弧。（弧头的入度减一）

=== 关键路径

#note_block[
  *问题*：

  假设以有向网表示一个施工流图，其中，*顶点表示事件*，弧表示活动，弧上的权值表示活动的持续时间。该网络称之为AOE网络。

  假设以该AOE网络表示一个施工流图，则有待研究的问题是：

  + 完成整项工程至少需要多少时间？
  + 哪些工程是影响整个工程进度的关键？

  *解*：

  1. 从源点到汇点的最长路径长度即为完成整项工程所需的最短时间。
  2. 关键活动是指影响整个工程进度的活动，即最长路径上的活动，该弧上的权值增加将使有向图上的最长路径长度增加。

]

#definition[
  *关键路径*：AOE网络中，最长路径上的活动称为关键活动，最长路径的长度称为关键路径的长度。
]

求关键活动：

- 事件的最早发生时间 $v e(j)$：从源点到该事件的*最长*路径长度，决定了所有以 $v_j$ 为尾的弧的最早开始时间。
- 事件的最迟发生时间 $v l(k) = "工程完成时间" - "从顶点" v_k "到汇点的"underline("最长")"路径长度"$：表示在不推迟整个工程完成的前提下，事件*最迟*发生的时间，取的是最迟发生时间*最小*的那个。
- 活动的最早发生时间 $e e(i)$：即活动起点事件的最早发生时间。
- 活动的最迟发生时间 $l l(i) = "活动终点事件的最迟发生时间" - "活动持续时间"$：即活动终点事件的最迟发生时间减去活动持续时间，也就是活动起点事件的最迟发生时间。

当活动的最早发生时间等于最迟发生时间时，该活动为关键活动。

实现要点：

- 求 $v e$ 的顺序是按拓扑序的。
- 求 $v l$ 的顺序是*逆*拓扑序的，所以要另设一个栈存储拓扑序。

== 最短路径

#definition[
  *最短路径*：在图中，从一个顶点到另一个顶点的路径中，边的权值之和最小的路径称为最短路径，其权值之和称为最短路径长度。
]

两种常用的算法：

- *Dijkstra 算法*：单源最短路径，适用于边权值为正的图。
- *Floyd 算法*：所有顶点间的最短路径，适用于边权值为任意的图。

=== Dijkstra 算法

算法步骤：

1. 初始化 $"dist"$ 数组，$"dist"[i]$ 表示从源点到顶点 $i$ 的最短路径长度，$"dist"[s] = 0$，$"dist"[i] = +infinity$。
2. 从 $"dist"$ 数组中选择一个未被访问的顶点 $u$，使得 $"dist"[u]$ 最小，标记 $u$ 为已访问。
3. 更新 $"dist"$ 数组，对于 $u$ 的所有邻接点 $v$，如果 $"dist"[u] + w(u, v) < "dist"[v]$，则更新 $"dist"[v] = "dist"[u] + w(u, v)$。
4. 重复 2 和 3，直到所有顶点都被访问。

=== Floyd 算法

算法步骤：

1. $D^(-1)$ 初始化为邻接矩阵 $A$，$P^(-1)$ 初始化为图中的弧。$D$ 表示最短路径长度，$P$ 表示最短路径。
2. 对于每一对顶点 $i$ 和 $j$，如果 $D^(-1)[i][j] > D^(-1)[i][k] + D^(-1)[k][j]$，则更新 $D^(-1)[i][j] = D^(-1)[i][k] + D^(-1)[k][j]$，$P^(-1)[i][j] = P^(-1)[k][j]$。

#grid(
  columns: 2,

)[#image("../assets/2024-06-25-20-55-59.png")][#image("../assets/2024-06-25-20-55-46.png")]

