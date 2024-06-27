
#import "../template.typ": *
#import "@preview/pinit:0.1.4": *
#import "@preview/fletcher:0.5.0" as fletcher: diagram, node, edge

#import "/book.typ": book-page

#show: book-page.with(title: "线性表 | DSA")


= 线性表

#definition[
  *线性结构*是一个数据元素的有序（次序）集，集合中必存在唯一的一个“第一元素”和唯一的一个“最后元素”，除第一个元素外，集合中的每个元素均有唯一的前驱，除最后一个元素外，集合中的每个元素均有唯一的后继。
]

== 线性表的定义

设线性表为 $(a_1, a_2, dots, a_i, dots, a_n)$，称 $i$ 为 $a_i$ 在线性表中的*位序*。


#note_block[
  例 2-1：

  假设：有两个集合 A 和 B 分别用两个线性表 LA 和 LB 表示，即：线性表中的数据元素即为集合中的成员。现要求一个新的集合A＝A∪B。

  解：```cpp
  void union(SqList &La, SqList Lb) {
      int La_len = ListLength(La); // 求线性表的长度
      int Lb_len = ListLength(Lb);
      for (int i = 1; i <= Lb_len; i++) {
          ElemType e;
          GetElem(Lb, i, e); // 取出线性表中的第 i 个元素，赋给 e
          if (!LocateElem(La, e)) {
              // 在线性表中查找元素 e，若不存在则插入
              ListInsert(La, ++La_len, e);
              // 在线性表中第 La_len 个位置插入元素 e
          }
      }
  }

  ```
]

== 线性表的顺序表示和实现
<线性表的顺序表示和实现>

#definition[
  // 顺序映象：以 x 的存储位置和 y 的存储位置之间某种关系表示逻辑关系<x,y>。
  *顺序映象*：以 $x$ 的存储位置和 $y$ 的存储位置之间某种关系表示逻辑关系 $<x, y>$。
]

数据元素存储位置的计算：<顺序表存储结构> $ "LOC"(a_i) = "LOC"(a_(i-1)) + C $

$ "LOC"(a_i) = #pin(101)"LOC"(#pin(103)a_1)#pin(102) + (i-1)×C $

其中，$C$ 为一个数据元素所占存储量。

#pinit-highlight(101, 102)
#pinit-point-from(103)[基地址]

*特点*：
1. 所有数据放在一个连续的地址空间
2. 数据的逻辑关系由存储位置来表现

=== 初始化

```c
Status InitList_Sq(SqList &L) {
    // 构造一个空的线性表
    L.elem = (ElemType *) malloc(LIST_INIT_SIZE(sizeof(ElemType));
    if (!L.elem)
        exit(OVERFLOW);//存储分配失败
    L.length = 0;               //空表长度为 0
    L.listsize = LIST_INIT_SIZE //初始存储容量
    return OK;
}// InitList_Sq
```

=== 查找元素

基本操作是：将顺序表中的元素逐个和给定值 e 相比较。

```C
int LocateElem_Sq(SqList L, ElemType e,
                  Status (*compare)(ElemType, ElemType)) {

    i = 1;     // i 的初值为第 1 元素的位序
    p = L.elem;// p 的初值为第 1 元素的存储位置

    while (i <= L.length && !(*compare)(*p++, e)) ++i;

    if (i <= L.length) return i;
    else
        return 0;

}// LocateElem_Sq
```

算法的时间复杂度为： $O( "ListLength"(L) )$

但如果是获取某个元素的值，时间复杂度为 $O(1)$。

=== 插入元素

时间复杂度：$O(n)$

在长度为 $n$ 的线性表中插入一个元素所需移动元素次数的期望值为：$ E_(i s) = sum_(i=1)^(n+1) p_i (n-i+1) $
假定在线性表中任何一个位置进行插入的概率都是相等的，则移动元素的期望值为：$ E_(i s) = 1/(n+1) sum_(i=1)^(n+1) (n-i+1) = n/2 $

=== 删除元素

时间复杂度：$O(n)$

移动元素次数的期望值为：$ E_(d l) = sum_(i=1)^(n-1) p_i (n-i) = n/2 $

== 线性表的链式表示和实现
<线性表的链式表示和实现>

#definition[
  *链式映象*：以附加信息（指针）表示后继关系。需要用一个和 `x` 在一起的附加信息指示 `y` 的存储位置。
]

*特点*：
1. 用一组*任意*的存储单元来存放线性表的结点。因此，链表中结点的逻辑次序和物理次序不一定相同。
2. 因为链表除了存放数据元素之外，还要存放指针，因此链表的存储密度不及顺序存储。

=== 线性单链表

#note_block[
  #align(center)[
    结点 = 元素 + 指针
  ]
  - 元素：数据元素的映象
  - 指针：指示后继元素存储位置

  由于此链表的每个结点中只包含一个指针域，故称为线性链表或单链表。
]

#note_block[
  #let lnode(pin, data, next) = {
    show table.cell: it => {
      // if it.x == 0 {
      //     cell.stroke
      // }
      align(center + horizon)[#it]
    }
    set table(stroke: (x, y) => (
      y: if x > 1 {
        1pt
      },
      left: if x > 1 {
        1pt
      } else {
        0pt
      },
      right: 1pt,
    ))
    table(
      columns: (1em, 0.5em, 2em, 1em),
      rows: (2em),
      [], pin, [#data], [#next],
    )
  }
  #grid(
    columns: 8,

  )[
    #align(center + horizon)[
      #v(1em)
      #pin(1)
      #h(1em)
    ]
  ][
    #lnode([#pin(2)], [], "^")
    #pinit-arrow(1, 2)
    #pinit-place(2, dy: 13.5pt)[
      #set text(size: 8pt)
      头结点
    ]
  ][
    #h(2em)
  ][
    #lnode([], [$a_1$], pin(3))
  ][
    #lnode(pin(4), [$a_2$], pin(5))
    #pinit-arrow(3, 4)
  ][
    #lnode(pin(6), [$...$], pin(7))
    #pinit-arrow(5, 6)
  ][
    #lnode(pin(8), [$a_n$], [^])
    #pinit-arrow(7, 8)
  ]

  以线性表中第一个数据元素 $a_1$ 的存储地址作为线性链表的地址，称作线性链表的头指针。

  有时为了操作方便，在第一个结点之前虚加一个“头结点”，以指向头结点的指针为链表的头指针。

  加入头结点的*优势*：
  - 由于头结点的位置被存放在头结点的指针域中，所以在链表的第一个位置上的操作就和在表的其他位置上的操作一致，无须进行特殊处理。
  - 无论链表是否为空，其头指针是指向头结点的非空指针（空表中头结点的指针域空），因此空表和非空表的处理也就一致了。


]

```C
typedef struct LNode {
    ElemType data;   // 数据域
    struct LNode *next; // 指针域
} LNode, *LinkList;

LinkList L; // L 为单链表的头指针
```

- ```C p->next```：下一个结点的地址
- ```C p->data```：当前结点的数据
- ```C p = p->next```：指向下一个结点（指针后移）

==== 操作的时间复杂度

- 查找：$O(n)$
- 插入：$O(n)$ （找到插入位置）
- 删除：$O(n)$ （找到删除位置）
  - 插入和删除结点的时间复杂度为 $O(1)$，但是需要先找到插入或删除位置。
- 清空链表：$O(n)$
- 创建链表：$O(n)$

#note_block[
  算法 2.13：

  ```c
  void MergeList_L(LinkList &La, LinkList &Lb, LinkList &Lc) {
      // 已知单链线性表La和 Lb的元素按值非递减排列
      //归并La和 Lb得到新的单链线性表Lc，Lc的元素也按值非递减排列

      pa = La->next;
      pb = Lb->next;
      Lc = pc = La;
      //用的La头结点作为Lc的头结点

      While(pa && pb) {
          if (pa->data <= pb->data) {
              pc->next = pa;
              pc = pa;
              pa = pa->next;
          } else {
              pc->next = pb;
              pc = pb;
              pb = pb->next;
          }
      }

      pc->next = pa ? pa : pb;//插入剩余段
      free(Lb)；              //释放Lb的头结点

  }// MergeList_L
  ```

]

=== 循环链表

#definition[
  *循环链表*：最后一个结点的指针域的指针又指回第一个结点的链表。
]

和单链表的差别仅在于，判别链表中最后一个结点的条件不再是“后继是否为空”，而是“后继是否为头结点”。

=== 双向链表

==== 插入


#grid(
  columns: (0.3fr, 1fr),

)[
  #image("../assets/2024-06-16-18-44-27.png")
][```c
  s->next = p->next;
  p->next = s;
  s->next->prior = s;
  s->prior = p;
  ```]

#grid(
  columns: (0.3fr, 1fr),

)[
  #image("../assets/2024-06-16-18-48-55.png")
][```c
  s->prior = p->prior;
  p->prior->next = s;
  s->next = p;
  p->prior = s;
  ```]

```C
Status ListInsert_ DuL(DuLinkList &L, int i, ElemType e) {
    //i 的合法值为 1≤i≤表长 +1.
    if (!(p = GetElemP_ DuL(L, i)))//大于表长加 1,p=NULL；
        return ERROR;              //等于表长加 1 时，指向头结点;

    if (!(s = (DuLinkList) malloc(sizeof(DuLNode))))
        return ERROR;

    s->data = e;
    s->prior = p->prior;
    p->prior->next = s;
    s->next = p;
    p->prior = s;
    return OK;

}// ListInsert_ DuL
```

==== 删除

#grid(
  columns: (0.3fr, 1fr),

)[
  #image("../assets/2024-06-16-18-51-01.png")
][```c
  p->next = p->next->next;
  p->next->prior = p;
  ```]

#grid(
  columns: (0.3fr, 1fr),

)[
  #image("../assets/2024-06-16-18-51-45.png")
][```c
  p->prior->next = p->next;
  p->next->prior = p->prior;
  ```]

```C
Status ListDelete_DuL(DuLinkList &L, int i, ElemType &e) {
    //i 的合法值为 1≤i≤表长
    if (!(p = GetElemP_ DuL(L, i)))
        return ERROR;//p=NULL，即第 i 个元素不存在

    e = p->data;
    p->prior->next = p->next;
    p->next->prior = p->prior;

    free(p);
    return OK;

}// ListDelete_ DuL
```

== 比较几种主要链表

#image("../assets/2024-06-16-18-53-41.png", width: 100%)

#image("../assets/2024-06-16-18-53-46.png", width: 100%)

#image("../assets/2024-06-16-18-53-50.png", width: 100%)

#image("../assets/2024-06-16-18-53-57.png", width: 100%)

== 边界条件

=== 几个特殊点的处理

- 头指针处理
- 非循环链表尾结点的指针域保持为NULL
- 循环链表尾结点的指针回指头结点

=== 链表处理

- 空链表的特殊处理
- 插入或删除结点时指针勾链的顺序
- 指针移动的正确性
  - 插入
  - 查找或遍历

== 实现方法比较

=== 顺序表

*优点*：
- 没有使用指针，不用花费额外开销
- 线性表元素的读访问非常简洁便利

*特点*：
- 插入、删除运算时间代价$O(n)$，查找则可常数时间完成
- 预先申请固定长度的数组
- 如果整个数组元素很满，则没有结构性存储开销


=== 链表

*优点*：
- 无需事先了解线性表的长度
- 允许线性表的长度动态变化
- 能够适应经常插入删除内部元素的情况

*特点*：
- 插入、删除运算时间代价$O(1)$，但找第$i$个元素运算时间代价$O(n)$
- 存储利用指针，动态地按照需要为表中新的元素分配存储空间
- 每个元素都有结构性存储开销


#note_block[
  - 顺序表是存储静态数据的不二选择，适用于读操作比插入删除操作频率大的场合
  - 链表是存储动态变化数据的良方，适用于插入删除操作频率大的场合；当指针的存储开销，和整个结点内容所占空间相比其比例较大时，应该慎重选择
]

