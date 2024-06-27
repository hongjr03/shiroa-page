
#import "../template.typ": *
#import "@preview/pinit:0.1.4": *
#import "@preview/fletcher:0.5.0" as fletcher: diagram, node, edge

#import "/book.typ": book-page

#show: book-page.with(title: "排序 | DSA")


= 排序
<排序>

== 冒泡排序
<冒泡排序>

=== 算法描述

冒泡排序是一种简单的排序算法。它重复地遍历要排序的列表，一次比较两个元素，如果它们的顺序错误就把它们交换过来。遍历列表的工作是重复地进行直到没有再需要交换，也就是说该列表已经排序完成。这个算法的名字由来是因为越小的元素会经由交换慢慢“浮”到数列的顶端。

=== 算法实现

```c
void BubbleSort(Elem R[], int n) {
    i = n;
    while (i > 1) {
        lastExchangeIndex = 1;
        for (j = 1; j < i; j++)
            if (R[j + 1].key < R[j].key) {
                Swap(R[j], R[j + 1]);
                lastExchangeIndex = j;// 记下进行交换的记录位置
            }// if
        i = lastExchangeIndex;// 本趟进行过交换的
                              // 最后一个记录的位置
    }// while
}// BubbleSort
```

=== 算法分析

冒泡排序的时间复杂度为 $O(n^2)$，空间复杂度为 $O(1)$。是稳定的排序算法。

== 插入排序

=== 算法描述

插入排序是一种简单直观的排序算法。它的工作原理是通过构建有序序列，对于未排序数据，在已排序序列中从后向前扫描，找到相应位置并插入。

=== 算法实现

==== 直接插入排序

```c
/* 插入排序 */
void insertionSort(int nums[], int size) {
    // 外循环：已排序区间为 [0, i-1]
    for (int i = 1; i < size; i++) {
        int base = nums[i], j = i - 1;
        // 内循环：将 base 插入到已排序区间 [0, i-1] 中的正确位置
        while (j >= 0 && nums[j] > base) {
            // 将 nums[j] 向右移动一位
            nums[j + 1] = nums[j];
            j--;
        }
        // 将 base 赋值到正确位置
        nums[j + 1] = base;
    }
}
```

课本上不另外设 `base` 变量，而是用 ```c nums[0] = nums[i]``` 代替。

```c
L.r[0] = L.r[i];// 复制为监视哨
for (j = i - 1; L.r[0].key < L.r[j].key; --j)
    L.r[j + 1] = L.r[j];// 记录后移
L.r[j + 1] = L.r[0];    // 插入到正确位置
```

这里 ```c L.r[0].key < L.r[j].key``` 保证了排序的稳定性。

==== 二分插入排序

```cpp
/*折半插入排序*/
void insertionBinarySort(std::vector<int> &nums) {
    int n = nums.size();
    // 外循环，已排序区间为 [0, i-1]
    for (int i = 1; i < n; i++) {
        int base = nums[i];
        int low = 0;
        int high = i - 1;
        while (low <= high) {
            int mid = (low + high) / 2;
            if (nums[mid] > base) {
                high = mid - 1;
            } else {
                low = mid + 1;
            }
        }
        // 将区间 [low, i-1] 的元素右移，腾出位置给 base
        for (int j = i; j >= low + 1; j--) {
            nums[j] = nums[j - 1];
        }
        // 将 base 插入到正确位置
        nums[low] = base;
    }
}
```

==== 希尔排序

和插入排序类似，但是希尔排序会先将数组分成若干个子序列，然后对每个子序列进行插入排序，最后再对整个数组进行插入排序。实现上，将插入排序中的步长 $1$ 替换为 $d$，即可实现希尔排序。

```cpp
void ShellInsert(SqList &L, int dk) {
    for (i = dk + 1; i <= n; ++i)
        if (L.r[i].key < L.r[i - dk].key) {
            L.r[0] = L.r[i];// 暂存在 R[0]
            for (j = i - dk; j > 0 && (L.r[0].key < L.r[j].key);
                 j -= dk)
                L.r[j + dk] = L.r[j];// 记录后移，查找插入位置
            L.r[j + dk] = L.r[0];    // 插入
        }// if
}// ShellInsert

void ShellSort(SqList &L, int dlta[], int t) {
    for (k = 0; k < t; ++k)
        ShellInsert(L, dlta[k]);
}// ShellSort
```

=== 算法分析

插入排序的时间复杂度为 $O(n^2)$，空间复杂度为 $O(1)$。是稳定的排序算法。

== 快速排序

=== 算法描述

快速排序使用分治法策略来把一个序列分为两个子序列。具体算法描述如下：

1. 从数列中挑出一个元素，称为 “基准”（pivot）；
2. 重新排序数列，所有元素比基准值小的摆放在基准前面，所有元素比基准值大的摆放在基准的后面（相同的数可以到任一边）。在这个分区退出之后，该基准就处于数列的中间位置。这个称为分区（partition）操作；
3. 递归地把小于基准值元素的子数列和大于基准值元素的子数列排序。

=== 算法实现

==== 冒泡排序 / 起泡排序

见冒泡排序。

==== 快速排序

定了枢轴之后，设左右指针分别指向数组的两端，右指针向左移动，找到第一个小于枢轴的元素，此时将左指针指向的元素赋值给右指针指向的元素，左指针向右移动，找到第一个大于枢轴的元素，此时将右指针指向的元素赋值给左指针指向的元素，直到左右指针相遇，将枢轴元素赋值给左右指针相遇的位置。

其实每次扫描就是找到一对逆序对，然后交换。

然后一趟排序完成后，枢轴元素就在正确的位置上了，返回枢轴的位置，对其左右两部分递归进行排序。

```c
int Partition(RedType R[], int low, int high) {
    R[0] = R[low];
    pivotkey = R[low].key;// 枢轴
    while (low < high) {  //从表的两端交替地向中间扫描
        while (low < high && R[high].key >= pivotkey)
            --high;//将比枢轴记录小的记录交换到低端
        R[low] = R[high];
        while (low < high && R[low].key <= pivotkey)
            ++low;//将比枢轴记录大的记录交换到高端
        R[high] = R[low];
    }
    R[low] = R[0];
    return low；//枢轴记录到位，返回枢轴位置
}// Partition

void QSort(RedType &R[], int low, int high) {
    // 对记录序列R[low..high]进行快速排序
    if (low < high) {// 长度大于1
        pivotloc = Partition(R, low, high);
        // 对 R[s..t] 进行一次划分
        QSort(R, low, pivotloc - 1);
        // 对低子序列递归排序，pivotloc是枢轴位置
        QSort(R, pivotloc + 1, high);// 对高子序列递归排序
    }
}// QSort

void QuickSort(SqList &L) {
    // 对顺序表进行快速排序
    QSort(L.r, 1, L.length);
}// QuickSort
```

或者这么写：

```cpp
/* 元素交换 */
void swap(vector<int> &nums, int i, int j) {
    int tmp = nums[i];
    nums[i] = nums[j];
    nums[j] = tmp;
}

/* 哨兵划分 */
int partition(vector<int> &nums, int left, int right) {
    // 以 nums[left] 为基准数
    int i = left, j = right;
    while (i < j) {
        while (i < j && nums[j] >= nums[left])
            j--;// 从右向左找首个小于基准数的元素
        while (i < j && nums[i] <= nums[left])
            i++;         // 从左向右找首个大于基准数的元素
        swap(nums, i, j);// 交换这两个元素
    }
    swap(nums, i, left);// 将基准数交换至两子数组的分界线
    return i;           // 返回基准数的索引
}

/* 快速排序 */
void quickSort(vector<int> &nums, int left, int right) {
    // 子数组长度为 1 时终止递归
    if (left >= right)
        return;
    // 哨兵划分
    int pivot = partition(nums, left, right);
    // 递归左子数组、右子数组
    quickSort(nums, left, pivot - 1);
    quickSort(nums, pivot + 1, right);
}
```

=== 算法分析

- *时间复杂度为 $O(n log n)$、自适应排序*：在平均情况下，哨兵划分的递归层数为 $log n$ ，每层中的总循环数为 $n$ ，总体使用 $O(n log n)$ 时间。在最差情况下，每轮哨兵划分操作都将长度为 $n$ 的数组划分为长度为 $0$ 和 $n - 1$ 的两个子数组，此时递归层数达到 $n$ ，每层中的循环数为 $n$ ，总体使用 $O(n^2)$ 时间。
- *空间复杂度为 $O(n)$、原地排序*：在输入数组完全倒序的情况下，达到最差递归深度 $n$ ，使用 $O(n)$ 栈帧空间。排序操作是在原数组上进行的，未借助额外数组。
- *非稳定排序*：在哨兵划分的最后一步，基准数可能会被交换至相等元素的右侧。

=== 算法优化

若待排记录的初始状态为按关键字有序时，快速排序将蜕化为起泡排序，其时间复杂度为 $O(n^2)$。为了避免这种情况，可以采用三数取中法：在待排记录序列中，首、尾、中间三个记录的关键字取中间值作为枢轴记录的关键字。

== 选择排序

=== 算法描述

选择排序是一种简单直观的排序算法。它的工作原理如下：

1. 首先在未排序序列中找到最小（大）元素，存放到排序序列的起始位置；
2. 然后，再从剩余未排序元素中继续寻找最小（大）元素，然后放到已排序序列的末尾；
3. 重复第二步，直到所有元素均排序完毕。

=== 算法实现

```c
/* 选择排序 */
void selectionSort(vector<int> &nums) {
    int n = nums.size();
    // 外循环：未排序区间为 [i, n-1]
    for (int i = 0; i < n - 1; i++) {
        // 内循环：找到未排序区间内的最小元素
        int k = i;
        for (int j = i + 1; j < n; j++) {
            if (nums[j] < nums[k])
                k = j;// 记录最小元素的索引
        }
        // 将该最小元素与未排序区间的首个元素交换
        swap(nums[i], nums[k]);
    }
}
```

=== 算法分析

选择排序的时间复杂度为 $O(n^2)$，空间复杂度为 $O(1)$。是不稳定的排序算法。

#figure(image("../assets/2024-06-10-15-11-21.png"), caption: "选择排序不稳定示意图")

=== 树形选择排序 / 锦标赛排序

树形选择排序是选择排序的一种改进，它使用完全二叉树的结构来减少比较次数。每次比较两个元素，将较小的元素放在树的叶子节点，然后向上比较，直到根节点为止。这种排序方法尚有辅助存储空间较多、和“最大值”进行多余的比较等缺点。为了弥补，提出了另一种形式的选择排序——堆排序。

== 堆排序

=== 算法描述

堆排序是一种树形选择排序，是对直接选择排序的有效改进。堆排序的基本思想是：将待排序序列构造成一个大顶堆，此时整个序列的最大值就是堆顶的根节点。将其与末尾元素进行交换，此时末尾就为最大值。然后将剩余 $n-1$ 个元素重新构造成一个堆，这样会得到 $n-1$ 个元素的次大值。如此反复执行，便能得到一个有序序列。

=== 算法实现

```cpp
/* 堆的长度为 n ，从节点 i 开始，从顶至底堆化 */
void siftDown(vector<int> &nums, int n, int i) {
    while (true) {
        // 判断节点 i, l, r 中值最大的节点，记为 ma
        int l = 2 * i + 1;
        int r = 2 * i + 2;
        int ma = i;
        if (l < n && nums[l] > nums[ma])
            ma = l;
        if (r < n && nums[r] > nums[ma])
            ma = r;
        // 若节点 i 最大或索引 l, r 越界，则无须继续堆化，跳出
        if (ma == i) {
            break;
        }
        // 交换两节点，和孩子交换
        swap(nums[i], nums[ma]);
        // ma 是交换节点的索引，继续向下堆化
        i = ma;
    }
}

/* 堆排序 */
void heapSort(vector<int> &nums) {
    // 建堆操作：堆化除叶节点以外的其他所有节点
    // 由于叶节点没有子节点，因此它们天然就是合法的子堆，无须堆化
    // 选择倒序遍历，是因为这样能够保证当前节点之下的子树已经是合法的子堆
    for (int i = nums.size() / 2 - 1; i >= 0; --i) {
        siftDown(nums, nums.size(), i);
    }
    // 从堆中提取最大元素，循环 n-1 轮
    for (int i = nums.size() - 1; i > 0; --i) {
        // 交换根节点与最右叶节点（交换首元素与尾元素）
        swap(nums[0], nums[i]);
        // 以根节点为起点，从顶至底进行堆化
        siftDown(nums, i, 0);
    }
}
```

=== 算法分析

- *时间复杂度为 $O(n log n)$、非自适应排序*：建堆操作使用 $O(n)$ 时间。从堆中提取最大元素的时间复杂度为 $O(log n)$ ，共循环 $n - 1$ 轮。
- *空间复杂度为 $O(1)$、原地排序*：几个指针变量使用 $O(1)$ 空间。元素交换和堆化操作都是在原数组上进行的。
- *非稳定排序*：在交换堆顶元素和堆底元素时，相等元素的相对位置可能发生变化。

== 归并排序

=== 算法描述

归并排序是一种分治算法，采用分治策略将待排序序列分为若干个子序列，分别进行排序，最后再将排好序的子序列合并成一个有序序列。分别排序时其实是将两个有序序列合并成一个有序序列，只需要比较两个序列的首元素，将较小的元素放入新序列中。

#figure(image("../assets/2024-06-10-15-40-24.png"), caption: "归并排序示意图")

=== 算法实现

归并排序与二叉树后序遍历的递归顺序是一致的。

- *后序遍历*：左子树、右子树、根节点
- *归并排序*：左子序列、右子序列、合并

```cpp
void Merge(RcdType SR[], RcdType &TR[],
           int i, int m, int n) {
    // 将有序的记录序列 SR[i..m] 和 SR[m+1..n]，归并为有序的//记录序列 TR[i..n]
    for (j = m + 1, k = i; i <= m && j <= n; ++k) {// 将 SR 中记录由小到大地并入 TR
        if (SR[i].key <= SR[j].key) TR[k] = SR[i++];
        else
            TR[k] = SR[j++];
    }
    if (i <= m) TR[k..n] = SR[i..m];// 将剩余的 SR[i..m] 复制到 TR
    if (j <= n) TR[k..n] = SR[j..n];// 将剩余的 SR[j..n] 复制到 TR
}// Merge

void Msort(RcdType SR[], RcdType &TR1[], int s, int t) {
    // 将 SR[s..t] 归并排序为 TR1[s..t]
    if (s = = t) TR1[s] = SR[s];
    else {
        m = (s + t) / 2;// 将 SR[s..t] 平分为 SR[s..m] 和 SR[m+1..t]
        Msort(SR, TR2, s, m);
        // 递归地将 SR[s..m] 归并为有序的 TR2[s..m]
        Msort(SR, TR2, m + 1, t);
        //递归地 SR[m+1..t] 归并为有序的 TR2[m+1..t]
        Merge(TR2, TR1, s, m, t);
        // 将 TR2[s..m] 和 TR2[m+1..t] 归并到 TR1[s..t]
    }
}// Msort

void MergeSort(SqList &L) {
    // 对顺序表 L 作 2-路归并排序
    MSort(L.r, L.r, 1, L.length);
}// MergeSort
```

书上的分界点选的是 $floor(m = (s + t) / 2)$，向下取整，然后递归调用时，左子序列是 $[s, m]$，右子序列是 $[m + 1, t]$。

不过书上这个 `Merge` 写得比较抽象，可以换成下面这种写法：

```cpp
/* 合并左子数组和右子数组 */
void merge(vector<int> &nums, int left, int mid, int right) {
    // 左子数组区间为 [left, mid], 右子数组区间为 [mid+1, right]
    // 创建一个临时数组 tmp，用于存放合并后的结果
    vector<int> tmp(right - left + 1);
    // 初始化左子数组和右子数组的起始索引
    int i = left, j = mid + 1, k = 0;
    // 当左右子数组都还有元素时，进行比较并将较小的元素复制到临时数组中
    while (i <= mid && j <= right) {
        if (nums[i] <= nums[j])
            tmp[k++] = nums[i++];
        else
            tmp[k++] = nums[j++];
    }
    // 将左子数组和右子数组的剩余元素复制到临时数组中
    while (i <= mid) {
        tmp[k++] = nums[i++];
    }
    while (j <= right) {
        tmp[k++] = nums[j++];
    }
    // 将临时数组 tmp 中的元素复制回原数组 nums 的对应区间
    for (k = 0; k < tmp.size(); k++) {
        nums[left + k] = tmp[k];
    }
}

/* 归并排序 */
void mergeSort(vector<int> &nums, int left, int right) {
    // 终止条件
    if (left >= right)
        return;// 当子数组长度为 1 时终止递归
    // 划分阶段
    int mid = left + (right - left) / 2;// 计算中点
    mergeSort(nums, left, mid);         // 递归左子数组
    mergeSort(nums, mid + 1, right);    // 递归右子数组
    // 合并阶段
    merge(nums, left, mid, right);
}
```

=== 算法分析

- *时间复杂度为 $O(n log n)$、非自适应排序*：划分产生高度为 $log n$ 的递归树，每层合并的总操作数量为 $n$ ，因此总体时间复杂度为 $O(n log n)$ 。
- *空间复杂度为 $O(n)$、非原地排序*：递归深度为 $log n$ ，使用 $O(log n)$ 大小的栈帧空间。合并操作需要借助辅助数组实现，使用 $O(n)$ 大小的额外空间。
- *稳定排序*：在合并过程中，相等元素的次序保持不变。

对于链表，归并排序相较于其他排序算法具有显著优势，可以将链表排序任务的空间复杂度优化至 $O(1)$ 。在合并阶段，链表中节点增删操作仅需改变引用（指针）即可实现，因此合并阶段（将两个短有序链表合并为一个长有序链表）无须创建额外链表。

== 基数排序

=== 算法描述

基数排序是一种非比较型整数排序算法，其原理是将整数按位数切割成不同的数字，然后按每个位数分别比较。基数排序的实现有两种方式：LSD（Least Significant Digit first）低位优先和 MSD（Most
Significant Digit first）高位优先。

在连续的排序轮次中，后一轮排序会覆盖前一轮排序的结果。举例来说，如果第一轮排序结果 $a<b$ ，而第二轮排序结果 $a>b$ ，那么第二轮的结果将取代第一轮的结果。由于数字的高位优先级高于低位，因此应该先排序低位再排序高位。

=== 算法实现

书上实现的是链式基数排序。

```cpp
#define MaxDigit 4
#define Radix 10

typedef struct {
    int keys[MaxDigit];// 关键字，keys[0] 是主位
    int next;// 指向下一个结点
} RecType;

typedef struct {
    int head, tail;// 链表的头指针和尾指针
} NodeType;
NodeType radix[Radix];// 静态链表

void LSDRadixSort(RecType R[], int n) {
    // 对 R[1..n] 进行基数排序，最大关键字为 MaxKey
    for (i = 1; i <= n; ++i) {
        R[i].next = i + 1;
    }
    R[n].next = 0;// 用 R[0].next 作为链表头指针
    for (i = 0; i < MaxDigit; ++i) {
        // 从低位到高位依次对各位关键字进行分配和收集
        Distribute(R, i);// 分配
        Collect(R);// 收集
    }
}// LSDRadixSort

void Distribute(RecType R[], int i) {
    // 按第 i 位关键字的大小分配到各个子链表
    p = R[0].next;
    while (p != 0) {
        j = ord(R[p].keys[i]);// ord 函数返回第 i 位关键字的值
        if (radix[j].head == 0)
            radix[j].head = p;
        else
            R[radix[j].tail].next = p;
        radix[j].tail = p;
        p = R[p].next;
    }
}// Distribute

void Collect(RecType R[]) {
    // 从各个子链表中收集
    i = 0;
    while (radix[i].head == 0)
        i++;
    R[0].next = radix[i].head;
    p = radix[i].tail;
    while (i < MaxDigit) {
        i++;
        while (i < MaxDigit && radix[i].head == 0)
            i++;
        if (i < MaxDigit) {
            R[p].next = radix[i].head;
            p = radix[i].tail;
        }
    }
    R[p].next = 0;
}// Collect
```

书上的实现：

```c
#define MAX_NUM_OF_KEY 8//关键字项数的最大值
#define RADIX 10        //关键字基数，此时是十进制整数的基数
#define MAX_SPACE 10000
typedef struct {
    KeysType keys[MAX_NUM_OF_KEY];//关键字
    InfoType otheritems;          //其他数据项
    int next;
} SLCell;//静态链表的结点类型

typedef struct {
    SLCell r[MAX_SPACE];   //静态链表的可利用空间，r[0] 为头结点
    int keynum;            //记录的当前关键字个数
    int recnum;            //静态链表的当前长度
} SLList;                  //静态链表类型
typedef int ArrType[RADIX];//指针数组类型

void Distribute(SLCell &r, int i, ArrType &f, ArrType &e) {
    //静态链表 L 的 r 域中记录已按 keys[0],…,keys[i-1]) 有序。本算法按第 i 个关键字 keys[i] 建立 RADIX 个子表，使同一子表中记录的 keys[i] 相同.f[0..RADIX-1] 和 e[0..RADIX-1] 分别指向各子表中第一个和最后一个记录。

    for (j = 0; j < Radix; ++j) f[j] = 0;
    //各子表初始化为空表

    for (p = r[0].next; p; p = r[p].next) {

        j = ord(r[p].keys[i]);
        //ord 将记录中第 i 个关键字映射到 [0..RADIX-1],

        if (!f[j]) f[j] = p;
        else
            r[e[j]].next = p;

        e[j] = p;
        //将 p 所指的结点插入第 j 个子表
    }
}// Distribute

void Collect(SLCell &r, int i, ArrType f, ArrType e) {
    //本算法按 keys[i] 自小至大的将 f[0..RADIX-1] 所指各子表依次链接成一个链表，e[0..RADIX-1] 为各子表的尾指针。
    for (j = 0; !f[j]; j = succ(j));
    //找第一个非空子表，succ 为求后继函数

    r[0].next = f[j];
    t = e[j];
    //r[0].next 指向第一个非空子表中第一个结点

    while (j < RADIX) {
        for (j = succ(j); j < RADIX - 1 && !f[j];
             j = succ(j));//找下一个非空子表

        if (f[j]) {
            r[t].next = f[j];
            t = e[j];
        }
        //链接两个非空子表
    }
    r[t].next = 0;
    //t 指向最后一个非空子表的最后一个结点
}// Collect

void RadixSort(SList &L) {
    // L 是采用静态链表表示的顺序表。对 L 做基数排序，使
    //得 L 成为按关键字自小到达的有序静态链表，L.r[0] 为
    //头结点。
    for (i = 0; i < L.recnum; ++i) L.r[i].next = i + 1;
    L.r[L.recnum].next = 0;//将 L 改造为静态链表
    for (i = 0; i < L.keynum; ++i) {
        //按最低位优先依次对各关键字进行分配和收集
        Distribute(L.r, i, f, e);//第 i 趟分配
        Collect(L.r, i, f, e);   //第 i 趟收集
    }
}// RadixSort
```

=== 算法分析

时间复杂度 $O(d(n+r d))$。需附设队列首尾指针，则空间复杂度为 $O(r d)$。$r$ 为基数，$d$ 为关键字位数。

== 总结

=== 时间性能

平均时间复杂度：
- $O(n log n)$：快速排序、归并排序、堆排序
- $O(n^2)$：冒泡排序、直接插入排序、简单选择排序
- $O(d(n+r d))$：基数排序

当待排记录序列按关键字顺序有序时：
- 直接插入排序和起泡排序能达到$O(n)$的时间复杂度
- 快速排序的时间性能蜕化为$O(n^2)$。

简单选择排序、堆排序和归并排序的时间性能不随记录序列中关键字的分布而改变。

=== 空间性能

- $O(1)$：所有的简单排序方法（包括：直接插入、起泡和简单选择）和堆排序，是原地排序；
- $O(n log n)$：快速排序，为递归程序执行过程中，栈所需的辅助空间；
- $O(n)$：归并排序，需要一个与待排记录序列等长的辅助数组；
- $O(r d)$：链式基数排序，需附设队列首尾指针。

=== 稳定性

- 不稳定的排序方法：快速排序、直接选择排序、希尔排序、堆排序；
- 稳定的排序方法：冒泡排序、直接插入排序、归并排序、基数排序。

=== 时间复杂度下限

基于比较关键字的排序方法的时间复杂度下限为 $O(n log n)$。

