import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';
import 'package:writing_kid/features/game/data/stroke_repository.dart';

// Drawing Canvas (CustomPainter) to handle user input and path drawing
class DrawingCanvas extends StatefulWidget {
  final LetterStroke targetLetter;
  final int currentStrokeIndex;
  final List<List<Offset>> completedStrokes;
  final Function(List<Offset>) onStrokeComplete;
  final bool showOrderHints;      // 획 순서 표시 여부
  final bool showDirectionArrows; // 방향 화살표 표시 여부

  const DrawingCanvas({
    super.key,
    required this.targetLetter,
    required this.currentStrokeIndex,
    required this.completedStrokes,
    required this.onStrokeComplete,
    this.showOrderHints = true,
    this.showDirectionArrows = true,
  });

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  final List<Offset> _currentPoints = [];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onPanStart: (details) {
            setState(() {
              _currentPoints.clear();
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              _currentPoints.add(renderBox.globalToLocal(details.globalPosition));
            });
          },
          onPanUpdate: (details) {
            setState(() {
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              _currentPoints.add(renderBox.globalToLocal(details.globalPosition));
            });
          },
          onPanEnd: (details) {
            // 획이 완료되면 부모에게 전달하여 검증
            if (_currentPoints.isNotEmpty) {
              widget.onStrokeComplete(List.from(_currentPoints));
              setState(() {
                _currentPoints.clear();
              });
            }
          },
          child: CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: _DetailsPainter(
              targetLetter: widget.targetLetter,
              currentStrokeIndex: widget.currentStrokeIndex,
              completedStrokes: widget.completedStrokes,
              currentPoints: _currentPoints,
              showOrderHints: widget.showOrderHints,
              showDirectionArrows: widget.showDirectionArrows,
            ),
          ),
        );
      },
    );
  }
}

class _DetailsPainter extends CustomPainter {
  final LetterStroke targetLetter;
  final int currentStrokeIndex;
  final List<List<Offset>> completedStrokes;
  final List<Offset> currentPoints;
  final bool showOrderHints;
  final bool showDirectionArrows;

  _DetailsPainter({
    required this.targetLetter,
    required this.currentStrokeIndex,
    required this.completedStrokes,
    required this.currentPoints,
    required this.showOrderHints,
    required this.showDirectionArrows,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. 모든 획의 밑바탕(트랙) 먼저 그리기 (Layer 1)
    // 순서대로 그리되, 나중에 그려진 트랙이 이전 트랙을 덮을 수 있음
    for (int i = 0; i < targetLetter.paths.length; i++) {
        _drawTrack(canvas, size, i);
    }

    // 2. 활성화되지 않은(미래/과거) 점선 그리기 (Layer 2)
    for (int i = 0; i < targetLetter.paths.length; i++) {
        if (i == currentStrokeIndex) continue; // 현재 획은 나중에 그림
        _drawDashedLine(canvas, size, i, false);
    }

    // 3. 현재 활성화된 획(가이드 + 화살표 + 시작점) 그리기 (Layer 3 - 가장 위)
    if (currentStrokeIndex < targetLetter.paths.length) {
        _drawDashedLine(canvas, size, currentStrokeIndex, true);
    }

    // 4. 완료된 획 & 5. 현재 긋고 있는 획 (Layer 4, 5)
    _drawCompletedStrokes(canvas);
    _drawCurrentStroke(canvas);
  }

  void _drawTrack(Canvas canvas, Size size, int index) {
      final pathPoints = targetLetter.paths[index];
      if (pathPoints.length < 2) return;

      final scaledPoints = pathPoints
          .map((p) => Offset(p.dx * size.width, p.dy * size.height))
          .toList();

      Path path = Path()..moveTo(scaledPoints.first.dx, scaledPoints.first.dy);
      for (int j = 1; j < scaledPoints.length; j++) {
        path.lineTo(scaledPoints[j].dx, scaledPoints[j].dy);
      }

      Paint trackPaint = Paint()
        ..color = Colors.grey[200]!
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = 50.0;
        
      canvas.drawPath(path, trackPaint);
  }

  void _drawDashedLine(Canvas canvas, Size size, int index, bool isActive) {
      final pathPoints = targetLetter.paths[index];
      if (pathPoints.length < 2) return;

      final scaledPoints = pathPoints
          .map((p) => Offset(p.dx * size.width, p.dy * size.height))
          .toList();

      Path path = Path()..moveTo(scaledPoints.first.dx, scaledPoints.first.dy);
      for (int j = 1; j < scaledPoints.length; j++) {
        path.lineTo(scaledPoints[j].dx, scaledPoints[j].dy);
      }

      Paint dashPaint = Paint()
        ..color = isActive ? Colors.amber : Colors.grey[300]!
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 6.0;

      // 점선 그리기
      _drawDashedPath(canvas, path, dashPaint, showDirectionArrows && isActive);

      // 활성 상태일 때 시작/끝점 장식
      if (isActive) {
         canvas.drawCircle(scaledPoints.first, 12, Paint()..color = Colors.blueAccent);
         canvas.drawCircle(scaledPoints.first, 8, Paint()..color = Colors.white);
         
         canvas.drawCircle(scaledPoints.last, 12, Paint()..color = Colors.redAccent.withOpacity(0.3));
      }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint, bool drawArrows) {
    const double dashWidth = 10.0;
    const double dashSpace = 10.0;
    
    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      double lastArrowDistance = -50.0; // 처음에 바로 화살표 나오지 않게

      while (distance < metric.length) {
        final double len = (distance + dashWidth < metric.length) ? dashWidth : metric.length - distance;
        final Path dashPath = metric.extractPath(distance, distance + len);
        canvas.drawPath(dashPath, paint);
        
        // 방향 화살표 그리기 (약 60px 간격으로, 확실한 방향을 위해)
        if (drawArrows && (distance - lastArrowDistance) > 60.0 && len >= dashWidth) {
           // 현재 구간의 중간 지점에서 방향 계산
           _drawArrowHead(canvas, metric, distance + len / 2, paint.color);
           lastArrowDistance = distance;
        }
        
        distance += dashWidth + dashSpace;
      }
      
      // 마지막에 화살표 하나 더 (짧은 획도 방향 보이게) - 단, 너무 짧으면 스킵
      if (drawArrows && metric.length > 30 && (metric.length - lastArrowDistance) > 30) {
        _drawArrowHead(canvas, metric, metric.length - 10, paint.color);
      }
    }
  }

  void _drawArrowHead(Canvas canvas, PathMetric metric, double distance, Color color) {
    // 탄젠트 오차를 줄이기 위해 전후 좌표 차이로 각도 계산
    // 0.1 픽셀 간격으로 두 점을 샘플링
    final double d1 = (distance - 1.0).clamp(0.0, metric.length);
    final double d2 = (distance + 1.0).clamp(0.0, metric.length);
    if (d1 >= d2) return;

    final Offset p1 = metric.getTangentForOffset(d1)?.position ?? Offset.zero;
    final Offset p2 = metric.getTangentForOffset(d2)?.position ?? Offset.zero;
    if (p1 == p2) return;

    // 실제 진행 각도 계산
    final double angle = atan2(p2.dy - p1.dy, p2.dx - p1.dx);

    final Offset pos = metric.getTangentForOffset(distance)?.position ?? p1;

    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(angle);

    final double arrowSize = 8.0; 
    final Path arrowPath = Path()
      ..moveTo(0, 0) // 화살표 끝이 원점
      ..lineTo(-arrowSize, arrowSize / 1.5)
      ..lineTo(-arrowSize, -arrowSize / 1.5)
      ..close();

    canvas.drawPath(arrowPath, Paint()..color = color..style = PaintingStyle.fill); 
    canvas.restore();
  }

  void _drawCompletedStrokes(Canvas canvas) {
    Paint completedPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 30.0;

    for (final stroke in completedStrokes) {
       if (stroke.isEmpty) continue;
       Path path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
       for (int i = 1; i < stroke.length; i++) {
         path.lineTo(stroke[i].dx, stroke[i].dy);
       }
       canvas.drawPath(path, completedPaint);
    }
  }

  void _drawCurrentStroke(Canvas canvas) {
    if (currentPoints.isEmpty) return;
    Paint currentPaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 30.0;

    Path path = Path()..moveTo(currentPoints.first.dx, currentPoints.first.dy);
    for (int i = 1; i < currentPoints.length; i++) {
      path.lineTo(currentPoints[i].dx, currentPoints[i].dy);
    }
    canvas.drawPath(path, currentPaint);
  }

  @override
  bool shouldRepaint(covariant _DetailsPainter oldDelegate) {
    return true;
  }
}
