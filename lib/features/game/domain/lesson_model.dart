import 'package:flutter/material.dart';

class LessonModel {
  final String letter; // 따라 쓸 글자
  final String soundPath; // 사운드 파일 경로
  final List<Offset> strokePoints; // 획순 데이터 (추후 사용)

  const LessonModel({
    required this.letter,
    required this.soundPath,
    this.strokePoints = const [],
  });
}
