import 'package:flutter/material.dart';

///  Name: 冒泡排序
///  Created by Fitem on 2023/2/15
class BubbleSortScreen extends StatelessWidget{
  const BubbleSortScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('冒泡排序'),
      ),
      body: _buildBody(),
    );
  }

  /// body
  Widget _buildBody() {
    return ListView(
      children: [
        RichText(
          text:  TextSpan(
            text: '冒泡排序\n',
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
            children: [
              const TextSpan(
                text: '从左到右不断交换相邻逆序的元素，在⼀轮的循环之后，可以让未排序的最⼤元素上浮到右侧。'
                    '在⼀轮循环中，如果没有发⽣交换，那么说明数组已经是有序的，此时可以直接退出。\n',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              const TextSpan(
                text: '稳定、时间复杂度O(N^2)、空间复杂度O(1)。',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.asset('images/img_bubble_sort.webp'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}