import 'package:flutter/material.dart';

// Drawing Canvas (CustomPainter) to handle user input and path drawing
class DrawingCanvas extends StatefulWidget {
  final Function(List<Offset>) onStrokeComplete;

  const DrawingCanvas({super.key, required this.onStrokeComplete});

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  final List<Offset?> _points = [];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              _points.add(renderBox.globalToLocal(details.globalPosition));
            });
          },
          onPanEnd: (details) {
            // 사용자가 손을 뗐을 때, 지금까지 그린 점들을 상위 위젯으로 전달
            // (획 단위 분석을 위해 null 제외한 점들만 전달)
            widget.onStrokeComplete(
                _points.where((p) => p != null).map((e) => e!).toList());
            
            // 획이 끝나면 점들을 초기화 (다음 글자 쓰기를 위해)
            // 실제 앱에서는 한 글자를 다 쓸 때까지 유지해야 함.
            // 여기서는 '가' 한 번 쓰기를 반복하는 형태로 가정.
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) setState(() => _points.clear());
            });
          },
          child: CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: _DetailsPainter(_points),
          ),
        );
      },
    );
  }
}

class _DetailsPainter extends CustomPainter {
  final List<Offset?> points;

  _DetailsPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DetailsPainter oldDelegate) => true;
}
