import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_article/%20algorithm/screen/bubble_sort.dart';

///  Name:
///  Created by Fitem on 2023/2/15

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 强制竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '算法',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => const HomePage(),
        '/bubble_sort': (context) => const BubbleSortScreen(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<ItemBean> _items = [
    const ItemBean('排序算法', '/bubble_sort'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('算法'),
      ),
      body: ListView(
        children: _items
            .map((e) => ListTile(
                  title: Text(e.title),
                  onTap: () {
                    Navigator.of(context).pushNamed(e.routeName);
                  },
                ))
            .toList(),
      ),
    );
  }
}

class ItemBean {
  const ItemBean(this.title, this.routeName);

  final String title;
  final String routeName;
}
