import 'dart:async';

///  Name:
///  Created by Fitem on 2023/3/6
void main() {
  /// 1.1 Future(FutureOr<T> computation())
  // futureTest();

  /// 1.2 Future.value
  // futureValueTest();

  /// 1.3 Future.then
  // futureThenTest();

  /// 1.4 Future.delayed
  // futureDelayedTest();

  /// 1.5 await-async
  // awaitAsyncTest();

  /// 2.1.1 catchError
  // catchErrorTest();

  /// 2.1.2 Future.onError
  // onErrorTest();

  /// 2.1.3  catchError 与 onError
  // futureErrorTest1();
  /// 2.1.3  catchError 与 onError
  // futureErrorTest2();
  /// 2.1.3  catchError 与 onError
  // futureErrorTest3();

  /// 2.1.4 Future.error
  // futureErrorTest();

  /// 2.2 Future.whenComplete
  // whenCompleteTest();

  /// 2.3 Future.wait
  // futureWaitTest();

  /// 2.4 Future.timeout
  // featureTimeoutTest();

  /// 2.5 Future.doWhile
  // doWhileTest();

  /// 2.6 Future.Sync
  // syncTest();

  // 3.2 event loop
  futureEventLoopTest();
}

/// 1.1 Future(FutureOr<T> computation())
void futureTest() {
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

/// 1.3 Future.then
void futureThenTest() {
  int _count = 0;
  print('1.开始count=$_count');
  Future(() {
    for (int i = 0; i < 10000000; i++) {
      _count++;
    }
    print('2.计算完成count=$_count');
  }).then((value) => print('3.结束count=$_count'));
}

/// 1.4 Future.delayed
void futureDelayedTest() {
  print('1.开始执行: ${DateTime.now()}');
  Future.delayed(const Duration(seconds: 2), () {
    print('2.延时2秒执行: ${DateTime.now()}');
  });
  print('3.结束执行: ${DateTime.now()}');
}

/// 1.5 async 和 await
Future<void> awaitAsyncTest() async {
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
void catchErrorTest() {
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
void onErrorTest() {
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
void futureErrorTest1() {
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
Future<void> futureErrorTest2() async {
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
Future<void> futureErrorTest3() async {
  int _count = 0;
  print('1.开始count=$_count');
  Future(() {
    _count++;
    throw Exception('计算错误1');
  }).then((value) {}).catchError((error) {
    print('2.捕获异常 : $error');
  });
}

/// 2.1.4 Future.error
futureErrorTest() {
  int _count = 0;
  print('1.开始count=$_count');
  Future(() {
    _count++;
    return Future.error(Exception('计算错误1'));
  }).catchError((error) {
    print('2.捕获异常 : $error');
  });
}

/// 2.2 Future.whenComplete
void whenCompleteTest() {
  Future(() {
    throw Exception('计算错误1');
  }).then((value) {}).catchError((error) {
    print('捕获异常: $error');
    throw error;
  }).whenComplete(() {
    print('whenComplete');
  });
}

/// 2.3 Future.wait
void futureWaitTest() {
  Future.wait([
    Future(() => print('任务1')),
    Future(() => print('任务2')),
    Future(() => print('任务3')),
  ]).then((value) => print('完成所有任务'));
}

/// 2.4 Future.timeout
void featureTimeoutTest() {
  Future(() {
    return Future.delayed(const Duration(seconds: 3), () => print('1.完成任务'));
  }).timeout(const Duration(seconds: 2), onTimeout: () {
    print('2.任务超时');
  }).then((value) {
    print('3.结束任务');
  });
}

/// 2.5 Future.doWhile
void doWhileTest() {
  int _count = 0;
  Future.doWhile(() async {
    _count++;
    await Future.delayed(const Duration(seconds: 1));
    if (_count == 3) {
      print('Finished with $_count');
      return false;
    }
    return true;
  });
}

/// 2.8 Future.sync
Future<void> syncTest() async {
  Future future1 =  Future.value(1); // tag1
  Future future2 = Future<int>(() => 2);	// tag5
  Future future3 = Future.value(Future(() => 3)); // tag6
  Future future4 = Future.sync(() => 4);	// tag4
  Future future5 = Future.sync(() => Future.value(5)); // tag2
  scheduleMicrotask(() => print(6));  // tag3
  future1.then(print);
  future2.then(print);
  future3.then(print);
  future4.then(print);
  future5.then(print);
}

/// 3.2 event loop
void futureEventLoopTest() {
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
