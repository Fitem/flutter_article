import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_article/study_night/hongloumeng.dart';

///  Name: 书本
///  Created by Fitem on 2022/9/13
class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState<BookPage> extends State {
  static const candlelight = Color(0xFFF1DA59);
  static const night = Color(0xFF434343);
  ValueNotifier<bool> isTouchSwitch = ValueNotifier(false);
  ValueNotifier<bool> isOpen = ValueNotifier(true);
  Offset initOffset = Offset.zero;
  ValueNotifier<Offset> switchOffset = ValueNotifier(Offset.zero);
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _initLight();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text(
          "挑灯夜读",
          style: TextStyle(
            color: candlelight,
          ),
        ),
      ),
      body: Container(
        color: Colors.black87,
        child: Listener(
          onPointerDown: _onPanStart,
          onPointerUp: _onPanEnd,
          onPointerMove: _onPanUpdate,
          child: Stack(
            children: [
              _buildBook(),
              _buildLight(),
            ],
          ),
        ),
      ),
    );
  }

  /// 初始化图片
  Future<void> _initLight() async {
    _image = await loadImageFromAssets("images/icon_light.png");
    setState(() {});
  }

  /// 读取 assets 中的图片
  Future<ui.Image>? loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    return decodeImageFromList(data.buffer.asUint8List());
  }

  ShaderMask _buildBook() {
    return ShaderMask(
      shaderCallback: _buildShader,
      child: ValueListenableBuilder(
          valueListenable: isTouchSwitch,
          builder: (context, bool isTouch, _) =>
              SingleChildScrollView(
                physics: isTouch
                    ? const NeverScrollableScrollPhysics()
                    : const AlwaysScrollableScrollPhysics(),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    children: [
                      TextSpan(
                          text: HongLouMeng.title,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          )),
                      TextSpan(text: HongLouMeng.content),
                    ],
                  ),
                ),
              )),
    );
  }

  Shader _buildShader(Rect bounds) {
    return RadialGradient(
      center: const Alignment(0, -0.7),
      colors: [isOpen.value ? candlelight : night, night],
      tileMode: TileMode.clamp,
    ).createShader(bounds);
  }

  /// 灯
  Widget _buildLight() {
    return IgnorePointer(
      ignoring: true,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            var width = constraints.maxWidth;
            var height = constraints.maxHeight;
            initOffset = Offset(width * 0.8, 300);
            switchOffset.value = initOffset;
            return CustomPaint(
              size: Size(width, height),
              painter: SwitchPainter(
                  switchOffset: switchOffset, //开关移动位置
                  isOpen: isOpen, //是否开灯
                  lightImage: _image),
            );
          }),
    );
  }

  /// 手指点击
  void _onPanStart(PointerDownEvent details) {
    final Offset offset = details.localPosition;
    double dx = offset.dx - switchOffset.value.dx;
    double dy = offset.dy - switchOffset.value.dy;
    isTouchSwitch.value = sqrt(dx * dx + dy * dy).abs() < (15 + 10);
  }

  /// 手指抬起
  void _onPanEnd(PointerUpEvent details) {
    final Offset offset = switchOffset.value;
    double dx = offset.dx - initOffset.dx;
    double dy = offset.dy - initOffset.dy;
    isOpen.value =
    dy > 0 && sqrt(dx * dx + dy * dy) > 50 ? !isOpen.value : isOpen.value;
    isTouchSwitch.value = false;
    switchOffset.value = initOffset;
  }

  /// 手指移动
  void _onPanUpdate(PointerMoveEvent details) {
    if (isTouchSwitch.value) {
      switchOffset.value = details.localPosition;
    }
  }
}

class SwitchPainter extends CustomPainter {
  late Paint _linePaint;
  late Paint _switchPaint;
  late Paint _imagePaint;
  final Color candlelight = const Color(0xFFF1DA59);
  final ValueNotifier<Offset> switchOffset;
  final ValueNotifier<bool> isOpen;
  ui.Image? _image;

  SwitchPainter({required this.switchOffset,
    required this.isOpen,
    required ui.Image? lightImage})
      : super(repaint: Listenable.merge([switchOffset, isOpen])) {
    _image = lightImage;
    _linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = candlelight;
    _switchPaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0
      ..color = candlelight;
    _imagePaint = Paint();
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawLight(canvas, size);
    _drawSwitch(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void _drawSwitch(Canvas canvas, Size size) {
    Offset offset = switchOffset.value;
    Path path = Path()
      ..moveTo(size.width * 0.8, 0)
      ..lineTo(offset.dx, offset.dy);
    canvas.drawPath(path, _linePaint);
    canvas.drawOval(
        Rect.fromCenter(center: offset, width: 30, height: 30), _switchPaint);
  }

  void _drawLight(Canvas canvas, Size size) {
    if (!isOpen.value) return; //若当前开关没有打开，则不显示吊灯
    var width = _image!.width.toDouble();
    canvas.save();
    canvas.translate(size.width * 0.5, 0);
    canvas.drawImage(_image!, Offset(-width * 0.5, 0), _imagePaint);
    canvas.restore();
  }
}