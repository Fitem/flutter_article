import 'dart:async';

///  Name:
///  Created by Fitem on 2023/3/6
void main() {
  // 最简单的Future
  // simpleFuture();

  // await、async
  // asyncAwaitTest();

  // 延时执行
  // futureDelayTest();

  // Future.then
  // futureThenTest();

  // Future.catchError
  // futureCatchErrorTest();

  // onError
  futureOnErrorTest();
}

int _count = 0;

void futurePrint() {
  print('1.开始count=$_count');
  Future(() {
    for (int i = 0; i < 100000000; i++) {
      _count++;
    }
    print('2.计算完成count=$_count');
  });
  print('3.结束count=$_count');
}

/// 一、最简单的Future
void simpleFuture() {
  futurePrint();
  print('4.做其他事情');
}

/// async 和 await
Future<void> asyncAwaitTest() async {
  print('1.开始count=$_count');
  await Future(() {
    for (int i = 0; i < 100000000; i++) {
      _count++;
    }
    print('2.计算完成count=$_count');
  });
  print('3.结束count=$_count');
  print('4.做其他事情');
}

/// Future.delayed
void futureDelayTest() {
  print('开始执行: ${DateTime.now()}');
  Future.delayed(const Duration(seconds: 2), () {
    print('延时2秒执行: ${DateTime.now()}');
  });
}

/// Future.then
void futureThenTest() {
  Future(() => print('A')).then((value) => print('A结束'));
  Future(() => print('B')).then((value) => print('B结束'));
}

/// Future.catchError
void futureCatchErrorTest() {
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

void futureOnErrorTest() {
  print('1.开始count=$_count');
  Future(() {
    _count++;
    // throw Exception('计算错误1');
  }).then((value) {
    print('2.计算完成count=$_count');
    // throw Exception('计算错误2');
  }).then((value){
    throw Exception('计算错误2');
  },  onError: (error) {
    print('3.捕获异常 : $error');
    throw Exception('计算错误3');
  }).catchError((error) {
    print('4.捕获异常$error');
    throw Exception('计算错误4');
  })
  //     .catchError((error) {
  //   print('5.捕获异常$error');
  // })
      //     .then((value) {
      //   throw Exception('计算错误2');
      // }).catchError((error) {
      //   print('5.捕获异常$error');
      //   throw Exception(error);
      // })
      //     .then((value) => print('6.计算完成count=$_count'), onError: (error) {
      //   print('7.捕获异常 : $error');
      // })
      ;
}

void futureQueueTest() {
  Future future1 = Future(() => null);
  future1.then((value) {
    print('6');
    scheduleMicrotask(() => print('7'));
  }).then((value) => print('8'));
  Future future2 = Future(() => print('1'));
  Future(() => print('2'));
  scheduleMicrotask(() => print('3'));
  future2.then((value) => print('4'));

  print('5');
}
