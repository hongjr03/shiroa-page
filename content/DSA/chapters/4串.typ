
#import "../template.typ": *
#import "@preview/pinit:0.1.4": *
#import "@preview/fletcher:0.5.0" as fletcher: diagram, node, edge

#import "/book.typ": book-page

#show: book-page.with(title: "串 | DSA")


= 串
<串>

#definition[
  *串*：串是有限长的字符序列，由一对单引号相括，如: 'a string'。
]<串的基本概念>

== 基本操作
<串的基本操作>
- `StrAssign(&T, chars)`：生成一个其值等于字符串常量 chars 的串 T
- `DestroyString(&T)`：串 T 被销毁
- `StrCopy(&T, S)`：串 S 被复制到串 T
- `StrLength(S)`：返回串 S 的长度
- `StrCompare(S, T)`：若 S > T，则返回值 > 0；若 S = T，则返回值 = 0；若 S < T，则返回值 < 0
- `Concat(&T, S1, S2)`：用 T 返回由 S1 和 S2 连接而成的新串
- `SubString(&Sub, S, pos, len)`：用 Sub 返回串 S 的第 pos 个字符*起*长度为 len 的子串
- `ClearString(&S)`：串 S 清空
- `Index(S, T, pos)`：若主串 S 中存在和串 T 值相同的子串，则返回它在主串 S 中第一次出现的位置，否则返回 0
- `Replace(&S, T, V)`：用 V 替换主串 S 中出现的所有与 T 相等的不重叠的子串
- `StrInsert(&S, pos, T)`：在串 S 的第 pos 个字符之前插入串 T
- `StrDelete(&S, pos, len)`：从串 S 中删除第 pos 个字符起长度为 len 的子串
- `StrEmpty(S)`：若串 S 为空，则返回 true，否则返回 false

== 定长顺序存储

```c
#define MAXLEN 255
typedef unsigned char Sstring
        [MAXSTRLEN + 1]; // 0 号单元存放串的长度
```

*特点*：
- 串的实际长度可在这个予定义长度的范围内随意设定，超过予定义长度的串值则被舍去，称之为“截断” 。
- 按这种串的表示方法实现的串的运算时，其基本操作为 “字符序列的复制”。

== 堆分配存储表示

```c
typedef struct {
    char *ch; // 若是非空串，则按串长分配存储区，否则 ch 为 NULL
    int length; // 串长度
} HString;
```

C语言中提供的串类型就是以这种存储方式实现的。

这里的堆指的是动态分配的存储空间，而不是数据结构中的堆。

