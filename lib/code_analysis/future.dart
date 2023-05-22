import 'dart:async';

///  Name:
///  Created by Fitem on 2023/3/6
void main() {
  /// 1.1 Future的基本用法
  // futureTest1();

  /// 1.2 Future.value
  futureValueTest();

  // 1.2 Future.then
  // futureTest2();

  // 1.3 延时执行
  // futureTest3();

  // 1.4 await-async
  // futureTest4();

  // 2.1.1 Future.catchError
  // futureTest5();

  // 2.1.2 onError
  // futureTest6();

  // 2.1.3  catchError 与 onError
  // futureTest7();
  // 2.1.3  catchError 与 onError
  // futureTest8();
  // 2.1.3  catchError 与 onError
  // futureTest9();

  // 2.2 whenComplete
  // futureTest10();

  // 2.3 wait
  // futureTest11();

  // 2.4 timeout
  // futureTest12();

  // 3.2 event loop
  // futureTest13();
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

/// 1.2 Future.value
void futureValueTest() {
  Future<int>.value(2021).then((value) {
    print('value: $value');
  });
}

/// 1.2 Future.then
void futureTest2() {
  int _count = 0;
  print('1.开始count=$_count');
  Future(() {
    for (int i = 0; i < 10000000; i++) {
      _count++;
    }
    print('2.计算完成count=$_count');
  }).then((value) => print('3.结束count=$_count'));
}

/// 1.3 Future.delayed
void futureTest3() {
  print('1.开始执行: ${DateTime.now()}');
  Future.delayed(const Duration(seconds: 2), () {
    print('2.延时2秒执行: ${DateTime.now()}');
  });
  print('3.结束执行: ${DateTime.now()}');
}

/// 1.4 async 和 await
Future<void> futureTest4() async {
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

/// 2.1.3 catchError 与 onError
void futureTest7() {
  int _count = 0;
  print('1.开始count=$_count');
  Future(() {
    _count++;
    throw Exception('计算错误1');
  }).then((value) {}, onError: (error) {
    print('2.捕获异常 : $error');
    // throw Exception('计算错误2');
    throw error;
  }).then((value) => null, onError: (error) {
    print('3.捕获异常 : $error');
  });
}

/// 2.1.3 catchError 与 onError
Future<void> futureTest8() async {
  int _count = 0;
  print('1.开始count=$_count');
  Future(() {
    _count++;
    throw Exception('计算错误1');
  }).catchError((error) {
    print('2.捕获异常 : $error');
    throw Exception('计算错误2');
    // throw error;
  }).catchError((error) {
    print('4.捕获异常 : $error');
  });
}

/// 2.1.3 catchError 与 onError
Future<void> futureTest9() async {
  int _count = 0;
  print('1.开始count=$_count');
  Future(() {
    _count++;
    throw Exception('计算错误1');
  }).then((value) {}).catchError((error) {
    print('2.捕获异常 : $error');
  });
}

/// 2.2 Future.whenComplete
void futureTest10() {
  Future(() {
    throw Exception('计算错误1');
  }).then((value) {}).catchError((error) {
    print('捕获异常: $error');
    throw error;
  }).whenComplete(() {
    print('whenComplete');
  });
}

/// 2.3 wait
void futureTest11() {
  Future.wait([
    Future(() => print('任务1')),
    Future(() => print('任务2')),
    Future(() => print('任务3')),
  ]).then((value) => print('完成所有任务'));
}

/// 2.4 timeout
void futureTest12() {
  Future(() {
    return Future.delayed(const Duration(seconds: 3), () => print('1.完成任务'));
  }).timeout(const Duration(seconds: 2), onTimeout: () {
    print('2.任务超时');
  }).then((value) {
    print('3.结束任务');
  });
}

/// 3.2 event loop
void futureTest13() {
  Future future1 = Future(() {
    // 3. 执行任务1
    print('任务1');
  });
  future1.then((value) {
    // 4.执行任务2
    print('任务2');
    // 6.执行任务3
    scheduleMicrotask(() => print('任务3'));
  }).then((value) {
    // 5.执行任务4
    print('任务4');
  }); // 4.打印8

  // 7. 执行任务5
  Future future2 = Future(() => print('任务5'));
  // 9. 执行任务6
  Future(() => print('任务6'));
  // 2.执行任务7
  scheduleMicrotask(() => print('任务7'));
  // 8.执行任务8
  future2.then((value) => print('任务8'));
  // 1.执行任务9
  print('任务9');
}
