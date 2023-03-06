import 'dart:math';

///  Name:
///  Created by Fitem on 2023/2/21
void main(){
  // List<int> array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  // print(binarySearch(array, 5));
  // print(lengthOfLongestSubstring('abcabcbb'));
  List<int> array1 = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<int> array2 = [2, 4, 6, 8, 10, 12, 14, 16, 18, 20];
  merge2(array1, array1.length ~/ 2, array2, array2.length);
  print(array1.join(','));
}

/// 二分查找（避免整形溢出）
int binarySearch(List<int> array, int target) {
  int left = 0;
  int right = array.length - 1;
  while (left <= right) {
    int mid = left + ((right - left) >> 1);
    if (array[mid] == target) {
      return mid;
    } else if (array[mid] < target) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }
  return -1;
}

/// 滑动窗口 + 优化：使用记录上一次滑动窗口右边界下标的数组，以实现找到重复元素时左边界的飞跃
/// 时间复杂度：O(len(s))、空间复杂度：O(len(charset))。其中 len(s) 为字符串长度，charset 为字符集
int lengthOfLongestSubstring(String s) {
  int left = 0;
  int right = 0;
  int maxLen = 0;
  List<int> index = List.filled(128, -1);
  while (right < s.length) {
    // 当前字符的ASCII码
    int indexOf = s.codeUnitAt(right);
    // 当前字符上一次出现的位置
    int rightValue = index[indexOf];
    if (rightValue != -1) {
      // 当前字符上一次出现的位置在滑动窗口左边界的右边，说明当前字符在滑动窗口内
      left = max(left, rightValue + 1);
    }
    index[indexOf] = right;
    // 更新最大长度
    maxLen = max(maxLen, right - left + 1);
    right++;
  }
  return maxLen;
}

/// 盛最多⽔的容器
/// 时间复杂度：O(n)、空间复杂度：O(1)
int maxArea(List<int> height) {
  // 初始化记录窗⼝左右边界的位置
  int left = 0;
  int right = height.length - 1;
  int maxArea = 0;
  // 当左边界⼩于右边界时
  while (left < right) {
    // 计算面积
    int area = min(height[left], height[right]) * (right - left);
    // 更新最大面积
    maxArea = max(maxArea, area);
    // 移动较短的边界
    if (height[left] < height[right]) {
      left++;
    } else {
      right--;
    }
  }
  return maxArea;
}

/// 合并区间
/// 时间复杂度：O(nlogn)、空间复杂度：O(logn)
List<List<int>> merge(List<List<int>> intervals) {
  // 按照区间的左边界排序
  intervals.sort((a, b) => a[0] - b[0]);
  // 初始化结果集
  List<List<int>> res = [];
  // 遍历区间
  for (int i = 0; i < intervals.length; i++) {
    // 当结果集为空或者当前区间的左边界⼤于结果集中最后⼀个区间的右边界时，直接将当前区间加⼊结果集
    if (res.isEmpty || intervals[i][0] > res.last[1]) {
      res.add(intervals[i]);
    } else {
      // 否则，将当前区间的右边界更新为结果集中最后⼀个区间的右边界和当前区间右边界的较⼤值
      res.last[1] = max(res.last[1], intervals[i][1]);
    }
  }
  return res;
}

/// 合并两个有序数组
/// 双指针：为防止元素被覆盖，双指针需从后往前遍历
/// 时间复杂度：O(m + n)、空间复杂度：O(1)
void merge2(List<int> nums1, int m, List<int> nums2, int n) {
  int p1 = m - 1;
  int p2 = n - 1;
  int p = m + n - 1;
  while (p1 >= 0 && p2 >= 0) {
    if (nums1[p1] > nums2[p2]) {
      nums1[p] = nums1[p1];
      p1--;
    } else {
      nums1[p] = nums2[p2];
      p2--;
    }
    p--;
  }
  // 将 nums2 中剩余的元素拷贝到 nums1 中
  if (p2 >= 0) {
    nums1.setRange(0, p2 + 1, nums2);
  }
}