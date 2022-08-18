import 'dart:io';
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

  // 选择棋子序号
  ValueNotifier<int> piecesIndex = ValueNotifier<int>(-1);

  // 点击棋盘位置
  ValueNotifier<int> boardIndex = ValueNotifier<int>(-1);

  // 棋盘各个点可移动位置
  final moveVisibleList = [
    [1, 3, 4],
    [0, 2, 4],
    [1, 4, 5],
    [0, 4, 6],
    [0, 1, 2, 3, 5, 6, 7, 8],
    [2, 4, 8],
    [3, 4, 7],
    [4, 6, 8],
    [4, 5, 7], //第9个点可移动位置
  ];

  // 胜利的位置
  final winIndexMap = [
    [0, 4, 8],
    [2, 4, 6]
  ];
  final List<Offset> boardOffsetList = [];
  final List<PiecesBean> piecesOffsetList = [];

  // 定义步数，判断那一方走下一步棋
  int step = 0;

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
                piecesIndex: piecesIndex,
                boardIndex: boardIndex,
                repaint: Listenable.merge([piecesIndex, boardIndex]),
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

    // 重置游戏
    resetGame();
  }

  /// 重置游戏
  void resetGame() {
    // 定义棋子位置、颜色、文案
    piecesOffsetList.clear();
    // 对手棋子倒序显示
    piecesOffsetList
        .add(PiecesBean(boardOffsetList[0], Colors.greenAccent, "3", 0));
    piecesOffsetList
        .add(PiecesBean(boardOffsetList[1], Colors.greenAccent, "2", 1));
    piecesOffsetList
        .add(PiecesBean(boardOffsetList[2], Colors.greenAccent, "1", 2));
    piecesOffsetList
        .add(PiecesBean(boardOffsetList[6], Colors.redAccent, "1", 6));
    piecesOffsetList
        .add(PiecesBean(boardOffsetList[7], Colors.redAccent, "2", 7));
    piecesOffsetList
        .add(PiecesBean(boardOffsetList[8], Colors.redAccent, "3", 8));
    step = 0;
    piecesIndex.value = -1;
    boardIndex.value = -1;
  }

  /// 手势处理
  void _onTapDown(TapDownDetails details) {
    var offset = details.globalPosition;
    var dx = offset.dx - width * 0.5;
    var dy = offset.dy - height * 0.5;
    for (MapEntry<int, PiecesBean> entry in piecesOffsetList.asMap().entries) {
      var bean = entry.value;
      var index = entry.key;
      var piecesOffset = bean.offset;
      if (_checkPoint(piecesOffset.dx, piecesOffset.dy, dx, dy)) {
        // 更新棋子选中状态
        if (step % 2 == 1 && index < 3 || step % 2 == 0 && index >= 3) {
          piecesIndex.value = index;
        }
        // debugPrint("piecesIndex:$piecesIndex");
        return;
      }
    }
    // 若点击是棋盘
    for (MapEntry<int, Offset> entry in boardOffsetList.asMap().entries) {
      var offset = entry.value;
      var index = entry.key;
      if (_checkPoint(offset.dx, offset.dy, dx, dy)) {
        // 判断棋子是否可以走到该位置
        if (piecesIndex.value > -1 &&
            isMoveViable(piecesIndex.value, index) &&
            (step % 2 == 1 && piecesIndex.value < 3 ||
                step % 2 == 0 && piecesIndex.value >= 3)) {
          var bean = piecesOffsetList[piecesIndex.value];
          bean.offset = boardOffsetList[index];
          bean.boardIndex = index;
          boardIndex.value = index;
          step++;
          // 判断当前是否有一边胜利
          checkWinState();
        }
        // debugPrint("boardsIndex:$index");
        return;
      }
    }
  }

  /// 是否是当前点
  bool _checkPoint(double dx1, double dy1, double dx2, double dy2) =>
      (dx1 - dx2).abs() < 40 && (dy1 - dy2).abs() < 40;

  /// 是否是可移动的
  bool isMoveViable(int piecesIndex, int boardIndex) {
    var index = boardOffsetList.indexOf(piecesOffsetList[piecesIndex].offset);
    debugPrint("isMoveViable: $index $boardIndex");
    return moveVisibleList[index].contains(boardIndex);
  }

  /// 获取胜利的状态
  int getWinState() {
    for (int i = 0; i < piecesOffsetList.length / 3; i++) {
      var index1 = piecesOffsetList[i * 3 + 0].boardIndex;
      var index2 = piecesOffsetList[i * 3 + 1].boardIndex;
      var index3 = piecesOffsetList[i * 3 + 2].boardIndex;
      var lastIndex = piecesOffsetList.length - 1;
      var otherIndex1 = piecesOffsetList[lastIndex - (i * 3 + 0)].boardIndex;
      var otherIndex2 = piecesOffsetList[lastIndex - (i * 3 + 1)].boardIndex;
      var otherIndex3 = piecesOffsetList[lastIndex - (i * 3 + 2)].boardIndex;
      // 判断一方是否已胜利
      if (isWinPosition(index1, index2, index3)) {
        return i;
      }
      // 判断另外一方是否已无法走棋
      if (isOtherNotMoveVisible(
          [index1, index2, index3], [otherIndex1, otherIndex2, otherIndex3])) {
        return i;
      }
    }
    return -1;
  }

  /// 是否是符合胜利的位置
  bool isWinPosition(int index1, int index2, int index3) {
    for (var indexList in winIndexMap) {
      if (indexList.contains(index1) &&
          indexList.contains(index2) &&
          indexList.contains(index3)) {
        return true;
      }
    }
    return false;
  }

  /// 判断是否有一方胜利
  void checkWinState() {
    var winState = getWinState();
    switch (winState) {
      case 0: // 绿色方胜利
        _showDialogTip("绿色方胜利！");
        break;
      case 1: // 红色放胜利
        _showDialogTip("红色方胜利！");
        break;
      default:
        break;
    }
  }

  /// 显示弹窗
  _showDialogTip(String content) {
    //设置按钮
    Widget cancelButton = MaterialButton(
      child: const Text("确定"),
      onPressed: () {
        Navigator.of(context).pop();
        resetGame();
      },
    );

    //设置对话框
    AlertDialog alert = AlertDialog(
      title: const Text("比赛结果"),
      content: Text(content),
      actions: [
        cancelButton,
      ],
    );

    //显示对话框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            child: alert,
            onWillPop: () async {
              return false;
            });
      },
    );
  }

  bool isOtherNotMoveVisible(List<int> list1, List<int> list2) {
    List<int> list = [...list1, ...list2];
    for (var index in list2) {
      for (var moveIndex in moveVisibleList[index]) {
        if (!list.contains(moveIndex)) {
          return false;
        }
      }
    }
    return true;
  }
}

/// 对角棋Painter
class DiagonalChessPainter extends CustomPainter {
  DiagonalChessPainter({
    required this.rWidth,
    required this.rHeight,
    required this.boardOffsetList,
    required this.piecesOffsetList,
    required this.piecesIndex,
    required this.boardIndex,
    required this.repaint,
  }) : super(repaint: repaint);

  final double rWidth;
  final double rHeight;
  final List<Offset> boardOffsetList;
  final List<PiecesBean> piecesOffsetList;
  final Listenable repaint;
  final ValueNotifier<int> piecesIndex;
  final ValueNotifier<int> boardIndex;

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
  bool shouldRepaint(covariant DiagonalChessPainter oldDelegate) {
    return oldDelegate.repaint != repaint;
    // return true;
  }

  /// 绘制棋盘
  void _drawChessboard(Canvas canvas) {
    // 绘制矩形
    canvas.drawRect(
        Rect.fromLTRB(-rWidth, -rHeight, rWidth, rHeight), _chessboardPaint);
    // 绘制对角线
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
      _drawChessPiece(
        canvas,
        piecesOffsetList[i],
        i < 3,
        piecesIndex.value == i,
      );
    }
  }

  /// 绘制单个棋子
  void _drawChessPiece(
      Canvas canvas, PiecesBean bean, bool reverse, bool isSelected) {
    var offset = bean.offset;
    var color = bean.color;
    double radius = isSelected ? 30 : 25;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    // 对手棋子旋转180度，文案倒序显示
    if (reverse) canvas.rotate(pi);
    canvas.drawCircle(Offset.zero, radius, _chessPiecesPaint..color = color);
    _drawChessPieceText(canvas, bean, isSelected);
    canvas.restore();
  }

  /// 绘制文本
  void _drawChessPieceText(Canvas canvas, PiecesBean bean, bool isSelected) {
    var textPainter = TextPainter(
      text: TextSpan(
          text: bean.text,
          style: TextStyle(
            fontSize: isSelected ? 35 : 30,
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
