import 'dart:async';
import 'dart:isolate';

// import 'package:flutter/foundation.dart';

///  Name:
///  Created by Fitem on 2023/3/7
Future<void> main() async {
  /// 1.1 Isolate的基本用法
  // isolateTest1();
  /// 1.2 Isolate的异常处理
  isolateTest2();

  // isolateTest3();
}

/// 1.1 Isolate的基本用法
Future<void> isolateTest1() async {
  const String downloadLink = '下载链接';
  final resultPort = ReceivePort();
  await Isolate.spawn(readAndParseJson, [resultPort.sendPort, downloadLink]);
  String fileContent = await resultPort.first as String;
  print('展示文件内容: $fileContent');
}

/// 1.2 Isolate的异常处理
Future<void> isolateTest2() async {
  const String downloadLink = '下载链接';
  final resultPort = ReceivePort();

  await Isolate.spawn(
    readAndParseJsonWithErrorHandle,
    [resultPort.sendPort, downloadLink],
    onError: resultPort.sendPort,
    onExit: resultPort.sendPort,
  );

  // 获取结果
  final response = await resultPort.first;
  if (response == null) { // 没有消息
    print('没有消息');
  } else if (response is List) { // 异常消息
    final errorAsString = response[0]; //异常
    final stackTraceAsString = response[1]; // 堆栈信息
    print('error: $errorAsString \nstackTrace: $stackTraceAsString');
  } else { // 正常消息
    print(response);
  }
}

/// 3. compute
Future<void> isolateTest3() async {
  // try {
  //   String newLink = await compute((link) async {
  //     await Future.delayed(const Duration(seconds: 2));
  //     throw Exception('下载失败');
  //     return '新的链接';
  //   }, '下载链接');
  // } catch (e) {
  //   print('error: $e');
  // }
  // print('结束');
}

/// 读取并解析文件内容
Future<void> readAndParseJson(List<dynamic> args) async {
  SendPort resultPort = args[0];
  String fileLink = args[1];

  print('获取下载链接: $fileLink');

  String fileContent = '文件内容';
  await Future.delayed(const Duration(seconds: 2));
  Isolate.exit(resultPort, fileContent);
}

/// 读取并解析文件内容, 上报异常
Future<void> readAndParseJsonWithErrorHandle(List<dynamic> args) async {
  SendPort resultPort = args[0];
  String fileLink = args[1];
  String newLink = '文件链接';

  await Future.delayed(const Duration(seconds: 2));
  throw Exception('下载失败');
  Isolate.exit(resultPort, newLink);
}
