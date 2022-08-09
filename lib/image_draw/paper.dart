import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_article/idraw/coordinate_pro.dart';
import 'package:image/image.dart' as image;

///  Name: 绘制自定义图片
///  Created by Fitem on 2022/8/3
class PaperPage extends StatefulWidget {
  const PaperPage({Key? key}) : super(key: key);

  @override
  State<PaperPage> createState() => _PaperPageState();
}

class _PaperPageState extends State<PaperPage> {
  image.Image? _image;
  List<Point> points = [];
  double d = 1.8; //复刻的像素边长

  @override
  void initState() {
    super.initState();
    _initImagePoint();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: PaperPainter(points),
      ),
    );
  }

  void _initImagePoint() async {
    _image = await loadImageFromAssets("assets/avatar.png");
    setState(() {
      if (_image == null) return;
      for (int i = 0; i < _image!.width; i++) {
        for (int j = 0; j < _image!.height; j++) {
          var point = Point();
          point.x = i * d + d / 2;
          point.y = j * d + d / 2;
          point.r = d / 2;
          var color = Color(_image!.getPixel(i, j));
          point.color =
              Color.fromARGB(color.alpha, color.blue, color.green, color.red);
          points.add(point);
        }
      }
    });
  }

  //读取 assets 中的图片
  Future<image.Image?> loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    List<int> bytes = data.buffer.asUint8List();
    return image.decodeImage(bytes);
  }
}

class Point {
  double x;
  double y;
  Color color;
  double r;

  Point({this.x = 0, this.y = 0, this.color = Colors.black, this.r = 5});
}


class PaperPainter extends CustomPainter {
  late Paint _paint;

  final double strokeWidth = 0.5;
  final Color color = Colors.blue;

  final List<Point> points;
  final Coordinate coordinate = Coordinate();

  PaperPainter(this.points) {
    _paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = strokeWidth
      ..color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    coordinate.paint(canvas, size);
    canvas.translate(-20, 200);
    _drawImage(canvas);
  }

  @override
  bool shouldRepaint(PaperPainter oldDelegate) {
    return true;
  }

  void _drawImage(Canvas canvas) {
    for (var point in points) {
      canvas.drawCircle(Offset(point.x, point.y), point.r, _paint..color = point.color);
    }
  }
}