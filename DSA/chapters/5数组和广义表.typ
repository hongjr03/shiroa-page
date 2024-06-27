
#import "../template.typ": *
#import "@preview/pinit:0.1.4": *
#import "@preview/fletcher:0.5.0" as fletcher: diagram, node, edge

#import "/book.typ": book-page

#show: book-page.with(title: "数组和广义表 | DSA")


= 数组和广义表
<数组和广义表>

== 数组

#note_block[
  *行序为主序*： 二维数组$A$中任一元素 $a_(i,j)$ 的存储位置
  $ "LOC"(i,j) = #pin(1)"LOC"(0,0)#pin(2) + (b_2×i＋j)×L $
  // #pinit-point-from(2)[基地址]
  #pinit-highlight(1, 2)
  #pinit-place(1, dy: 6pt)[
    #set text(size: 8pt)
    基地址
  ]

  扩展到 $n$ 维数组：
  $ "LOC"(j_1,j_2, dots, j_n) = "LOC"(0,0, dots, 0) + sum_(i=1)^(n) c_i×j_i $
  其中，$c_n = L$，$c_(i-1) = b_i × c_i$，$1 < i <= n$。

  称为 $n$ 维数组的映象函数。数组元素的存储位置是其下标的线性函数。
]

=== 矩阵的压缩存储

#definition[
  *稀疏矩阵*：矩阵中大部分元素为零，只有少数元素非零。
]

而稀疏矩阵又分为：

- *特殊矩阵*：如三角矩阵，对角矩阵。
- *随机稀疏矩阵*：非零元在矩阵中随机出现。

对于随机稀疏矩阵，有三种压缩存储方法：

+ 三元组顺序表
+ 行逻辑联接的顺序表
+ 十字链表

==== 三元组顺序表

核心思想是将矩阵中的非零元素的行、列、值三个信息存储在一个三元组中，只存储非零元素。然后用一个顺序表存储这些三元组。

```c
typedef struct {
    int i, j; // 非零元素的行和列
    ElemType e; // 非零元素的值
} Triple;

typedef struct { // 书上是 union，大错特错
    Triple data[MAXSIZE + 1]; // 非零元素三元组表，data[0] 未用
    int mu, nu, tu; // 矩阵的行数、列数和非零元素个数
} TSMatrix;
```

求转置矩阵虽然只要交换行列号，但是简单的交换会导致非零元素的行列号不再有序，因此需要先按列号排序。具体步骤如下：

+ 确定每一行的第一个非零元在转置矩阵的顺序表中的位置
+ 从第一个非零元开始，按列号递增的顺序存储非零元素

```c
Status FastTransposeSMatrix(TSMatrix M, TSMatrix &T) {
    T.mu = M.nu;
    T.nu = M.mu;
    T.tu = M.tu;

    if (T.tu) {
        int num[M.nu + 1] = {0}; // 存储每一列的非零元素个数
        for (int t = 1; t <= M.tu; t++) {
            num[M.data[t].j]++;
        }
        int cpot[M.nu + 1] = {0, 1}; // 存储每一列第一个非零元在 T 中的位置
        for (int col = 2; col <= M.nu; col++) {
            cpot[col] = cpot[col - 1] + num[col - 1];
        }
        for (int p = 1; p <= M.tu; p++) {
            int col = M.data[p].j;
            int q = cpot[col];
            T.data[q].i = M.data[p].j;
            T.data[q].j = M.data[p].i;
            T.data[q].e = M.data[p].e;
            cpot[col]++; // 下一个非零元素的位置
        }
    }
    return OK;
}
```

复杂度：$O(n + t)$，其中 $n$ 为矩阵的列数，$t$ 为非零元素个数。

==== 行逻辑联接的顺序表

在三元组顺序表的基础上，增加一个一维数组 `rpos`，存储每一行的第一个非零元在三元组表中的位置。这样就可以实现按行快速访问非零元素。

```c
typedef struct {
    Triple data[MAXSIZE + 1];
    int rpos[MAXRC + 1]; // 每一行的第一个非零元在三元组表中的位置
    int mu, nu, tu;
} RLSMatrix;
```

原来矩阵相乘是这样的：

```c
for (i = 1; i <= m1; ++i)
    for (j = 1; j <= n2; ++j) {
        Q[i][j] = 0;
        for (k = 1; k <= n1; ++k)
            Q[i][j] += M[i][k] * N[k][j];
    }
```

复杂度为 $O(n^3)$。而两个稀疏矩阵相乘则可以优化为：

```c
Status MultSMat(RLSMatrix M, RLSMatrix N, RLSMatrix &Q) {
    if (M.nu != N.mu) return ERROR;
    Q.mu = M.mu;
    Q.nu = N.nu;
    Q.tu = 0;
    if (M.tu * N.tu != 0) {
        for (int arow = 1; arow <= M.mu; arow++) {
            int tpot = 0;
            int brow = arow + 1;
            if (arow < M.mu) brow = M.rpos[arow + 1];
            for (int ccol = 1; ccol <= N.nu; ccol++) {
                int trow = arow;
                int tcol = ccol;
                int sum = 0;

                // 两个矩阵的行列号都不超过自己的行列数
                while (trow < brow && M.data[trow].i <= arow) {
                    while (tcol < N.nu && N.data[tcol].i <= M.data[trow].j) {
                        // 两个矩阵的行列号相等，相乘
                        if (N.data[tcol].i == M.data[trow].j) {
                            sum += M.data[trow].e * N.data[tcol].e;
                            tcol++;
                        }
                    }
                    trow++;
                }
                // 如果和不为 0，存储到 Q 中
                if (sum != 0) {
                    Q.tu++;
                    if (Q.tu > MAXSIZE) return ERROR;
                    Q.data[Q.tu].i = arow;
                    Q.data[Q.tu].j = ccol;
                    Q.data[Q.tu].e = sum;
                }
            }
        }
    }
    return OK;
}
```

这样的时间复杂度是 $O(n^2)$。

== 广义表

#definition[
  *广义表*：广义表是线性表的推广，是n个元素的有限序列，每个元素都可以是原子元素，也可以是另一个广义表。也称其为列表。
]

广义表的结构：#box(table(columns: (4em, 3em, 3em), rows: 2em, align: center + horizon, [Tag=1], [HP], [TP])) 或 #box(table(columns: (4em, 3em), rows: 2em, align: center + horizon, [Tag=0], [Data]))

*结构特点*：

- 广义表中的数据元素有相对次序；
- 广义表的长度定义为最外层包含的元素个数；
- 广义表的深度定义为广义表中括号的层数。原子的深度为 0，空表的深度为 1。
- 广义表可以共享。
- 广义表可以是一个递归的表，这时候深度是无限的。
- 任何一个非空广义表都可以分解为一个表头和一个表尾，其中表头是一个元素，表尾是一个广义表。

#image("../assets/2024-06-23-20-17-12.png", width: 80%)

=== 求广义表的深度

将广义表分解成 $h$ 个子表，子表的深度最大值加 1 即为广义表的深度。

```c
int Depth(GList L) {
    if (!L) return 1;
    if (L->tag == 0) return 0;
    int max = 0;
    for (GList p = L; p; p = p->tp) {
        int dep = Depth(p->hp);
        if (dep > max) max = dep;
    }
    return max + 1;
}
```

=== 复制广义表

一对确定的表头和表尾可唯一确定一个广义表，因此复制广义表的关键是复制表头和表尾。

```c
GList Copy(GList L) {
    if (!L) return NULL;
    GList p = (GList) malloc(sizeof(GLNode));
    if (!p) exit(OVERFLOW);
    if (L->tag == 0) {
        p->tag = 0;
        p->hp = L->hp;
    } else {
        p->tag = 1;
        p->hp = Copy(L->hp);
        p->tp = Copy(L->tp);
    }
    return p;
}
```

