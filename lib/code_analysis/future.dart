import 'dart:async';

///  Name:
///  Created by Fitem on 2023/3/6
void main() {
  /// 1.1 Future的基本用法
  // futureTest1();

  // 1.2 await-async
  // futureTest2();

  // 1.3 延时执行
  // futureTest3();

  // 1.4 Future.then
  // futureTest4();

  // 2.1.1 Future.catchError
  // futureTest5();

  // 2.1.2 onError
  futureTest6();

  // Future.whenComplete
  // futureWhenCompleteTest();

  // Future.wait
  // futureWaitTest();

  // Future.timeout
  // futureTimeoutTest();

  /// Future队列
  // futureQueueTest();
}

/// 1.1 Future(FutureOr<T> computation())
void futureTest1() {
  int _count = 0;
  print('1.开始count=$_count');
  Future(() {
    for (int i = 0; i < 10000000; i++) {
      _count++;
    }
    print('2.计算完成count=$_count');
  });
  print('3.结束count=$_count');
}

/// 1.2 async 和 await
Future<void> futureTest2() async {
  int _count = 0;
  print('1.开始count=$_count');
  await Future(() {
    for (int i = 0; i < 10000000; i++) {
      _count++;
    }
    print('2.计算完成count=$_count');
  });
  print('3.结束count=$_count');
}

/// 1.3 Future.delayed
void futureTest3() {
  print('1.开始执行: ${DateTime.now()}');
  Future.delayed(const Duration(seconds: 2), () {
    print('2.延时2秒执行: ${DateTime.now()}');
  });
  print('3.结束执行: ${DateTime.now()}');
}

/// 1.4 Future.then
void futureTest4() {
  int _count = 0;
  print('1.开始count=$_count');
  Future(() {
    for (int i = 0; i < 10000000; i++) {
      _count++;
    }
    print('2.计算完成count=$_count');
  }).then((value) => print('3.结束count=$_count'));
}

/// 2.1.1 Future.catchError
void futureTest5() {
  int _count = 0;
  print('1.开始count=$_count');
  Future(() {
    _count++;
    throw Exception('计算错误');
    print('2.计算完成count=$_count');
  })
      .then((value) => print('3.计算完成count=$_count'))
      .catchError((error) => print('4.捕获异常 : $error'))
      .then((value) => print('5.计算完成count=$_count'));
}

/// 2.1.2 onError
void futureTest6() {
  int _count = 0;
  print('1.开始count=$_count');
  Future(() {
    _count++;
    throw Exception('计算错误1');
  }).then((value) {
    print('2.计算完成count=$_count');
  }, onError: (error) {
    print('3.捕获异常 : $error');
  });
}

void futureTest7() {
  int _count = 0;
  print('1.开始count=$_count');
  Future(() {
    _count++;
    throw Exception('计算错误1');
  }).then((value) {
    print('2.计算完成count=$_count');
    throw Exception('计算错误2');
  }).then((value) {
    throw Exception('计算错误3');
  }, onError: (error) {
    print('3.捕获异常 : $error');
    throw Exception('计算错误4');
  }).catchError((error) {
    print('4.捕获异常 : $error');
    throw error;
  }).then((value) {
    // throw Exception('计算错误4');
  }, onError: (error) {
    print('5.捕获异常 : $error');
    // throw Exception('计算错误5');
  });
}

/// Future.whenComplete
void futureWhenCompleteTest() {
  Future(() {
    throw '发生错误';
  }).then(print).catchError(print).whenComplete(() => print('whenComplete'));
}

/// Future.wait
void futureWaitTest() {
  Future.wait([
    Future(() => print('A')),
    Future(() => print('B')),
    Future(() => print('C')),
  ]).then((value) => print('D\n'));

  Future.wait(
    [
      Future(() => print('A')),
      Future(() => throw Exception('任务B异常')),
      Future(() => print('C')),
    ],
  ).then((value) => print('D')).catchError(print);
}

/// Future.timeout
void futureTimeoutTest() {
  Future(() => Future.delayed(Duration(seconds: 3), () => print('A')))
      .timeout(Duration(seconds: 2), onTimeout: () => print('超时'))
      .then((value) => print('B'));
}

/// Dart的事件循环 - event loop
void futureQueueTest() {
  Future future1 = Future(() => null);
  future1.then((value) {
    // 3.打印6
    print('6');
    // 5.打印7
    scheduleMicrotask(() => print('7'));
  }).then((value) => print('8')); // 4.打印8

  Future future2 = Future(() => print('1')); // 6.打印1
  // 8.打印2
  Future(() => print('2'));
  // 2.打印3
  scheduleMicrotask(() => print('3'));
  // 7.打印4
  future2.then((value) => print('4'));
  // 1.打印5
  print('5');
}
