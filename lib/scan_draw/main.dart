import 'package:flutter/material.dart';
import 'package:flutter_article/config.dart';
import 'package:flutter_article/scan_draw/scan.dart';

void main() {
  // 确定初始化
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScanPage(),
    );
  }
}


