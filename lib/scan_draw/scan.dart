import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter_article/idraw/coordinate_pro.dart';

///  Name: 扫描图形绘制
///  Created by Fitem on 2022/8/3
class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: ScanPainter(),
      ),
    );
  }
}

class ScanPainter extends CustomPainter {
  late Paint _paint;

  final double strokeWidth = 0.5;
  final Color color = Colors.blue;

  // final Coordinate coordinate = Coordinate();
  final Paint circlePaint = Paint()..color = Color(0x1A1E88E6);

  ScanPainter() {
    _paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = strokeWidth
      ..color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // coordinate.paint(canvas, size);
    canvas.translate(size.width * 0.5, size.height * 0.5);
    _drawScan(canvas);
  }

  @override
  bool shouldRepaint(ScanPainter oldDelegate) {
    return true;
  }

  void _drawScan(Canvas canvas) {
    canvas.drawCircle(Offset.zero, 100, circlePaint);
    canvas.drawCircle(Offset.zero, 70, circlePaint);
    canvas.drawCircle(Offset.zero, 40, circlePaint);
    var colors = [
      const Color(0x99148DF7),
      const Color(0x9940A2F7),
      const Color(0x1A7DBDF2),
    ];
    var pos = [0.0, 0.1, 1.0];
    _paint.shader =
        ui.Gradient.sweep(Offset.zero, colors, pos, TileMode.clamp, 0, pi / 2);
    canvas.save();
    canvas.rotate(-pi / 5);
    canvas.drawArc(
        const Rect.fromLTRB(-100, -100, 100, 100), 0, pi / 2, true, _paint);
    canvas.restore();
    canvas.drawCircle(
        Offset.zero, 10, circlePaint..color = const Color(0xFF1E88E5));
  }
}
