
#import "../template.typ": *
#import "@preview/pinit:0.1.4": *
#import "@preview/fletcher:0.5.0" as fletcher: diagram, node, edge

#import "/book.typ": book-page

#show: book-page.with(title: "栈和队列 | DSA")


= 栈和队列
<栈和队列>
== 栈

#definition[
  *栈*：栈（Stack）是限定仅在表的一端进行插入或删除操作的线性表。通常称插入删除的一端为栈顶（top），另一端称为栈底（bottom）。
]

*特点*：后进先出（LIFO）

=== 基本操作

- `InitStack(&S)`：构造一个空栈S
- `DestroyStack(&S)`：销毁栈S
- `ClearStack(&S)`：清空栈S
- `StackEmpty(S)`：判断栈S是否为空
- `StackLength(S)`：返回栈S的长度
- `GetTop(S, &e)`：取栈顶元素
- `Push(&S, e)`：入栈
- `Pop(&S, &e)`：出栈
- `StackTraverse(S, visit())`：遍历栈

#note_block[
  若 `S.data[0]` 为栈底元素，那么：
  1. 当插入一个元素时，top如何变化
    - `S.top++`
  2. 当删除一个元素时，top如何变化
    - `S.top--`
  3. 如何判断栈满的情况？
    - `S.top == StackSize`
  4. 如何判断空栈的情况？
    - `S.top == -1`
  5. Top的初始值是多少？
    - `S.top = -1`

  若以 `S.data[Stacksize-1]` 为栈底呢？
  1. 初始值：`S.top = StackSize`
  2. 入栈：`S.top--`
  3. 出栈：`S.top++`
  4. 栈满：`S.top == -1`
  5. 空栈：`S.top == StackSize`
]

=== 表达式求解

=== 递归

#definition[
  *递归*：一个对象如果部分地由它自身来定义（或描述），则称其为递归。
]

== 队列

#definition[
  *队列*：队列（queue）是限定只能在表的一端进行插入，在表的另一端进行删除的线性表。
]

*特点*：先进先出（FIFO）

// 顺序队列
// 固定的存储空间
// 方便访问队列内部元素
// 链式队列
// 可以满足队列大小无法估计的情况
// 访问队列内部元素不方便

=== 顺序队列与链式队列的比较

#grid(
  columns: (1fr, 1fr),

)[
  *顺序队列*
  - 存储空间固定
  - 访问队列内部元素方便
][
  *链式队列*
  - 存储空间不固定
  - 访问队列内部元素不方便
]

=== 应用

- 只要满足先来先服务特性的应用均可采用队列作为其数据组织方式或中间数据结构。
- 调度或缓冲
  - 消息缓冲器
  - 邮件缓冲器
  - 计算机的硬设备之间的通信也需要队列作为数据缓冲
  - 操作系统的资源管理
- 图结构的广度优先搜索

