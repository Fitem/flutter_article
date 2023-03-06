///  Name: 
///  Created by Fitem on 2023/2/16
import 'dart:math';

void main() {
  // List<int> array = [1, 9, 5, 7, 2, 8, 4, 6, 3, 0];
  List<int> array = [];
  for (int i = 0; i < 100; i++) {
    array.add(Random().nextInt(100));
  }
  print('${array.join(',')}\n');
//   bubbleSort(array);
//   selectionSort(array);
//   insertSort(array);
//   array = mergeSort(array);
//   quickSort(array, 0, array.length - 1);
//   shellSort(array);
//   heapSort(array);
  radixSort(array);
  print(array.join(','));
}

/// 冒泡排序
void bubbleSort(List<int> array) {
  int t = 0;
  for (int i = 0; i < array.length; i++) {
    for (int j = 0; j < array.length - 1 - i; j++) {
      if (array[j] > array[j + 1]) {
        t = array[j];
        array[j] = array[j + 1];
        array[j + 1] = t;
      }
    }
  }
}

/// 选择排序
void selectionSort(List<int> array) {
  int index;
  int temp;
  for (int i = 0; i < array.length; i++) {
    index = i;
    // 取出剩余数组中最小的元素
    for (int j = i; j < array.length; j++) {
      if (array[j] < array[index]) {
        index = j;
      }
    }
    // 和当前位置数据进行交换
    temp = array[i];
    array[i] = array[index];
    array[index] = temp;
  }
}

/// 插入排序
void insertSort(List<int> array) {
  int current;
  int preIndex;
  for (int i = 0; i < array.length - 1; i++) {
    current = array[i + 1];
    preIndex = i;
    while (preIndex >= 0 && current < array[preIndex]) {
      array[preIndex + 1] = array[preIndex];
      preIndex--;
    }
    array[preIndex + 1] = current;
  }
}

/// 归并排序
List<int> mergeSort(List<int> array) {
  if (array.length < 2) return array;
  int mid = array.length ~/ 2;
  List<int> left = array.sublist(0, mid);
  List<int> right = array.sublist(mid);
  return merge(mergeSort(left), mergeSort(right));
}

/// 并归排序：组合数组
List<int> merge(List<int> left, List<int> right) {
  List<int> result = List.filled(left.length + right.length, 0);
  for (int index = 0, i = 0, j = 0; index < result.length; index++) {
    if (i >= left.length) {
      result[index] = right[j++];
    } else if (j >= right.length) {
      result[index] = left[i++];
    } else if (left[i] > right[j]) {
      result[index] = right[j++];
    } else {
      result[index] = left[i++];
    }
  }
  return result;
}

/// 快速排序方法
void quickSort(List<int> array, int start, int end) {
  if (array.isEmpty || start < 0 || end >= array.length || start > end) {
    return;
  }
  int smallIndex = partition(array, start, end);
  if (smallIndex > start) quickSort(array, start, smallIndex - 1);
  if (smallIndex < end) quickSort(array, smallIndex + 1, end);
}

/// 快速排序算法——partition
int partition(List<int> array, int start, int end) {
  double random = Random().nextDouble();
  // 获取当前区间的基点
  int pivot = (start + random * (end - start + 1)).toInt();
  int smallIndex = start - 1;
  swap(array, pivot, end);
  for (int i = start; i <= end; i++) {
    // 当前节点比基点值小
    if (array[i] <= array[end]) {
      smallIndex++;
      if (i > smallIndex) {
        swap(array, i, smallIndex);
      }
    }
  }
  return smallIndex;
}

/// 交换数组内两个元素
void swap(List<int> array, int i, int j) {
  int temp = array[i];
  array[i] = array[j];
  array[j] = temp;
}

/// 希尔排序
void shellSort(List<int> array) {
  // 获取数组长度
  int len = array.length;
  // 取间距长度
  int temp, gap = len ~/ 2;
  while (gap > 0) {
    for (int i = gap; i < len; i++) {
      // 后一个数据
      temp = array[i];
      // 前一个数据index
      int preIndex = i - gap;
      // 当前一个数据 > 后一个数据
      while (preIndex >= 0 && array[preIndex] > temp) {
        // 后一个位置 = 前一个位置的值
        array[preIndex + gap] = array[preIndex];
        preIndex -= gap;
      }
      // 前一个位置的值 = 后一个位置的值
      array[preIndex + gap] = temp;
    }
    gap ~/= 2;
  }
}

/// 堆排序
heapSort(List<int> array) {
  int len = array.length;
  if (len < 1) return;
  // 1.构建一个最大堆
  buildMaxHeap(array, len);
  print('最大堆：${array.join(',')}');
  // 2.循环将堆首位（最大值）与末位交换，然后再重新调整最大堆
  while (len > 0) {
    swap(array, 0, len - 1);
    len--;
    adjustHeap(array, 0, len);
  }
}

/// 建立最大堆
void buildMaxHeap(List<int> array, int len) {
  // 从最后一个非子节点开始向上构造最大值
  for (int i = (len ~/ 2 - 1); i >= 0; i--) {
    adjustHeap(array, i, len);
  }
}

/// 构建为最大堆
void adjustHeap(List<int> array, int i, int len) {
  int maxIndex = i;
  int leftIndex = i * 2 + 1;
  int rightIndex = leftIndex + 1;
  // 如有有左子树，且左子树大于父节点，则将最大指针指向左子树
  if (leftIndex < len && array[leftIndex] > array[maxIndex]) {
    maxIndex = leftIndex;
  }
  // 如果有右子树，且右子树大于父节点，则将最大指针指向右子树
  if (rightIndex < len && array[rightIndex] > array[maxIndex]) {
    maxIndex = rightIndex;
  }
  // 如果父节点不是最大值，则将父节点与最大值交换，并且递归调整与父节点交换的位置。
  if (maxIndex != i) {
    swap(array, maxIndex, i);
    adjustHeap(array, maxIndex, len);
  }
}

/// 基数排序
void radixSort(List<int> array) {
  // 获取数组长度
  int len = array.length;
  if(len < 2) return;
  // 1.获取数组中最大值
  int max = array[0];
  for (int i = 1; i < len; i++) {
    if (array[i] > max) {
      max = array[i];
    }
  }
  // 获取最大值的位数
  int maxDigit = 0;
  while (max > 0) {
    max ~/= 10;
    maxDigit++;
  }
  // 从个位开始，对数组array按"指数"进行排序
  int mod = 10;
  int dev = 1;
  List<List<int>> counter = [];
  for (int i = 0; i < 10; i++) {
    counter.add([]);
  }
  for (int i = 0; i < maxDigit; i++, dev *= 10, mod *= 10) {
    for (int j = 0; j < len; j++) {
      int bucket = ((array[j] % mod) ~/ dev);
      counter[bucket].add(array[j]);
    }
    int pos = 0;
    for (int j = 0; j < 10; j++) {
      int value = -1;
      while (counter[j].isNotEmpty) {
        value = counter[j].removeAt(0);
        array[pos++] = value;
      }
    }
  }
}