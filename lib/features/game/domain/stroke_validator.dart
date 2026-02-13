import 'dart:math';
import 'dart:ui';

class StrokeValidator {
  // 사용자의 획과 정답 획을 비교
  static bool validateStroke({
    required List<Offset> userPath,
    required List<Offset> targetPath,
    required Size canvasSize,
  }) {
    if (userPath.length < 5) return false; // 너무 짧으면 무시

    // 1. 실제 좌표로 변환 (0.0~1.0 -> 300x300)
    final scaledTarget = targetPath.map((p) => Offset(p.dx * canvasSize.width, p.dy * canvasSize.height)).toList();

    // 2. 시작점 & 끝점 검사 (방향성 확인)
    final userStart = userPath.first;
    final userEnd = userPath.last;
    
    final targetStart = scaledTarget.first;
    final targetEnd = scaledTarget.last;

    // 시작점 거리 (허용 오차 50px)
    if ((userStart - targetStart).distance > 60.0) return false;
    
    // 끝점 거리 (허용 오차 60px)
    if ((userEnd - targetEnd).distance > 70.0) return false;

    // 3. 중간 경로 이탈 검사 (샘플링)
    // 사용자의 경로가 타겟 경로(직선들)에서 너무 멀어지면 안 됨
    // 간단히: 사용자의 포인트 중 80% 이상이 타겟 라인 근처에 있어야 함
    int validPoints = 0;
    
    for (final point in userPath) {
      double minDistance = double.infinity;
      
      // 타겟 경로의 각 세그먼트(선분)와의 거리 계산
      for (int i = 0; i < scaledTarget.length - 1; i++) {
        final dist = _distanceToSegment(point, scaledTarget[i], scaledTarget[i+1]);
        if (dist < minDistance) minDistance = dist;
      }
      
      if (minDistance < 50.0) { // 허용 오차 50px (붓 두께 고려)
        validPoints++;
      }
    }

    // 80% 이상 경로 일치 시 통과
    return (validPoints / userPath.length) > 0.8;
  }

  // 점(P)과 선분(A-B) 사이의 최단 거리
  static double _distanceToSegment(Offset p, Offset a, Offset b) {
    final double l2 = (a - b).distanceSquared;
    if (l2 == 0) return (p - a).distance;
    
    final double t = ((p.dx - a.dx) * (b.dx - a.dx) + (p.dy - a.dy) * (b.dy - a.dy)) / l2;
    
    if (t < 0) return (p - a).distance;
    if (t > 1) return (p - b).distance;
    
    final Offset projection = Offset(a.dx + t * (b.dx - a.dx), a.dy + t * (b.dy - a.dy));
    return (p - projection).distance;
  }
}
