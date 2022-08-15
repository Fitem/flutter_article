import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_article/diagonal_chess/bean/pieces.dart';
import 'package:flutter_article/idraw/coordinate_pro.dart';

///  Name: 对角棋
///  Created by Fitem on 2022/8/9
class DiagonalChessPage extends StatefulWidget {
  const DiagonalChessPage({Key? key}) : super(key: key);

  @override
  _DiagonalChessPageState createState() => _DiagonalChessPageState();
}

class _DiagonalChessPageState extends State<DiagonalChessPage> {
  double width = 0;
  double height = 0;
  double rWidth = 0;
  double rHeight = 0;
  int piecesIndex = 0;
  final List<Offset> boardOffsetList = [];
  final List<PiecesBean> piecesOffsetList = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          initPosition(constraints);
          return GestureDetector(
            onTapDown: _onTapDown,
            child: CustomPaint(
              size: Size(width, height),
              painter: DiagonalChessPainter(
                rWidth: rWidth,
                rHeight: rHeight,
                boardOffsetList: boardOffsetList,
                piecesOffsetList: piecesOffsetList,
              ),
            ),
          );
        },
      ),
    );
  }

  /// 初始化位置
  void initPosition(BoxConstraints constraints) {
    width = constraints.maxWidth;
    height = constraints.maxHeight;
    rWidth = width * 0.4;
    rHeight = width * 0.6;
    // 棋盘各个点
    // 第一行，从左到右
    boardOffsetList.add(Offset(-rWidth, -rHeight));
    boardOffsetList.add(Offset(0, -rHeight));
    boardOffsetList.add(Offset(rWidth, -rHeight));
    // 第二行，从左到右
    boardOffsetList.add(Offset(-rWidth, 0));
    boardOffsetList.add(Offset.zero);
    boardOffsetList.add(Offset(rWidth, 0));
    // 第二行，从左到右
    boardOffsetList.add(Offset(-rWidth, rHeight));
    boardOffsetList.add(Offset(0, rHeight));
    boardOffsetList.add(Offset(rWidth, rHeight));

    // 棋子
    piecesOffsetList.add(PiecesBean(boardOffsetList[0], Colors.redAccent, "3"));
    piecesOffsetList.add(PiecesBean(boardOffsetList[1], Colors.redAccent, "2"));
    piecesOffsetList.add(PiecesBean(boardOffsetList[2], Colors.redAccent, "1"));
    piecesOffsetList
        .add(PiecesBean(boardOffsetList[6], Colors.greenAccent, "1"));
    piecesOffsetList
        .add(PiecesBean(boardOffsetList[7], Colors.greenAccent, "2"));
    piecesOffsetList
        .add(PiecesBean(boardOffsetList[8], Colors.greenAccent, "3"));
  }

  void _onTapDown(TapDownDetails details) {
    var offset = details.globalPosition;
    var dx = offset.dx - width * 0.5;
    var dy = offset.dy - height * 0.5;
    for (MapEntry<int, PiecesBean> entry in piecesOffsetList.asMap().entries) {
      var bean = entry.value;
      var index = entry.key;
      var piecesOffset = bean.offset;
      if (_checkPoint(piecesOffset.dx, piecesOffset.dy, dx, dy)) {
         piecesIndex = index;
         debugPrint("piecesIndex:$piecesIndex");
        return;
      }
    }
    // 若点击是棋盘
    for(MapEntry<int, Offset> entry in boardOffsetList.asMap().entries){
      var offset = entry.value;
      var index = entry.key;
      if (_checkPoint(offset.dx, offset.dy, dx, dy)) {
        debugPrint("boardsIndex:$index");
        return;
      }
    }
  }

  /// 是否是当前点
  bool _checkPoint(double dx1, double dy1, double dx2, double dy2) =>
      (dx1 - dx2).abs() < 40 && (dy1 - dy2).abs() < 40;
}

/// 对角棋Painter
class DiagonalChessPainter extends CustomPainter {
  DiagonalChessPainter({
    required this.rWidth,
    required this.rHeight,
    required this.boardOffsetList,
    required this.piecesOffsetList,
  });

  final double rWidth;
  final double rHeight;
  final List<Offset> boardOffsetList;
  final List<PiecesBean> piecesOffsetList;

  final Coordinate _coordinate = Coordinate();
  final Paint _chessboardPaint = Paint()
    ..strokeWidth = 5
    ..style = PaintingStyle.stroke
    ..color = Colors.blue
    ..isAntiAlias = true;

  final Paint _chessPiecesPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.red
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Size size) {
    _coordinate.paint(canvas, size);
    canvas.translate(size.width * 0.5, size.height * 0.5);
    _drawChessboard(canvas);
    _drawChessPieces(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  /// 绘制棋盘
  void _drawChessboard(Canvas canvas) {
    canvas.drawRect(
        Rect.fromLTRB(-rWidth, -rHeight, rWidth, rHeight), _chessboardPaint);
    Path path = Path()
      // P1-P9
      ..moveTo(boardOffsetList[0].dx, boardOffsetList[0].dy)
      ..lineTo(boardOffsetList[8].dx, boardOffsetList[8].dy)
      // P2-P8
      ..moveTo(boardOffsetList[1].dx, boardOffsetList[1].dy)
      ..lineTo(boardOffsetList[7].dx, boardOffsetList[7].dy)
      // P3-P7
      ..moveTo(boardOffsetList[2].dx, boardOffsetList[2].dy)
      ..lineTo(boardOffsetList[6].dx, boardOffsetList[6].dy)
      // P4-P6
      ..moveTo(boardOffsetList[3].dx, boardOffsetList[3].dy)
      ..lineTo(boardOffsetList[5].dx, boardOffsetList[5].dy);
    canvas.drawPath(path, _chessboardPaint);
  }

  /// 绘制棋子
  void _drawChessPieces(Canvas canvas, Size size) {
    for (int i = 0; i < piecesOffsetList.length; i++) {
      _drawChessPiece(canvas, piecesOffsetList[i], i < 3);
    }
  }

  /// 绘制单个棋子
  void _drawChessPiece(Canvas canvas, PiecesBean bean, bool reverse) {
    var offset = bean.offset;
    var color = bean.color;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    if (reverse) canvas.rotate(pi);
    canvas.drawCircle(Offset.zero, 25, _chessPiecesPaint..color = color);
    _drawChessPieceText(canvas, bean);
    canvas.restore();
  }

  /// 绘制文本
  void _drawChessPieceText(Canvas canvas, PiecesBean bean) {
    var textPainter = TextPainter(
      text: TextSpan(
          text: bean.text,
          style: const TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    var textSize = textPainter.size;
    textPainter.paint(
        canvas, Offset(textSize.width * -0.5, textSize.height * -0.5));
  }
}
