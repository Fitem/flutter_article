import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

///  Name:
///  Created by Fitem on 2023/3/7
Future<void> main() async {
  // isolateTest1();

  // isolateTest2();

  isolateTest3();
}


/// 1. 使用
Future<void> isolateTest1() async {
  const String downloadLink = '下载链接';
  final resultPort = ReceivePort();
  await Isolate.spawn(readAndParseJson, [resultPort.sendPort, downloadLink]);
  String fileLink = await resultPort.first as String;
  print(fileLink);
}

/// 2. 错误处理
Future<void> isolateTest2() async {
  const String downloadLink = '下载链接';
  final resultPort = ReceivePort();

  await Isolate.spawn(
    readAndParseJsonWithErrorHandle,
    [resultPort.sendPort, downloadLink],
    onError: resultPort.sendPort,
    onExit: resultPort.sendPort,
  );

  final response = await resultPort.first;
  if (response == null) {
    print('No message');
  } else if (response is List) {
    final errorAsString = response[0];
    final stackTraceAsString = response[1];
    print(errorAsString);
  } else {
    print(response);
  }
}

/// 3. compute
Future<void> isolateTest3() async {
  try {
    String newLink = await compute((link) async {
      await Future.delayed(const Duration(seconds: 2));
      throw Exception('下载失败');
      return '新的链接';
    }, '下载链接');
  } catch (e) {
    print('error: $e');
  }
  print('结束');
}

Future<void> readAndParseJson(List<dynamic> args) async {
  SendPort resultPort = args[0];
  String fileLink = args[1];
  String newLink = '文件链接';

  await Future.delayed(const Duration(seconds: 2));

  Isolate.exit(resultPort, newLink);
}

Future<void> readAndParseJsonWithErrorHandle(List<dynamic> args) async {
  SendPort resultPort = args[0];
  String fileLink = args[1];
  String newLink = '文件链接';

  await Future.delayed(const Duration(seconds: 2));
  throw Exception('下载失败');
  Isolate.exit(resultPort, newLink);
}
