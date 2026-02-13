import 'dart:ui';

class LetterStroke {
  final List<List<Offset>> paths; // 각 획의 좌표 목록 (0.0 ~ 1.0 정규화된 좌표)
  final String letter;

  const LetterStroke({required this.letter, required this.paths});
}

class StrokeRepository {
  // 간단한 한글 자음 데이터 (ㄱ~ㅎ)
  static final Map<String, LetterStroke> strokes = {
    'ㄱ': const LetterStroke(
      letter: 'ㄱ',
      paths: [
        [Offset(0.2, 0.2), Offset(0.8, 0.2), Offset(0.8, 0.8)], // 1획: ㄱ
      ],
    ),
    'ㄴ': const LetterStroke(
      letter: 'ㄴ',
      paths: [
        [Offset(0.2, 0.2), Offset(0.2, 0.8), Offset(0.8, 0.8)], // 1획: ㄴ
      ],
    ),
    'ㄷ': const LetterStroke(
      letter: 'ㄷ',
      paths: [
        [Offset(0.25, 0.2), Offset(0.75, 0.2)], // 1획: ㅡ (위)
        [Offset(0.25, 0.2), Offset(0.25, 0.8), Offset(0.75, 0.8)], // 2획: ㄴ (아래)
      ],
    ),
    'ㄹ': const LetterStroke(
      letter: 'ㄹ',
      paths: [
        [Offset(0.2, 0.2), Offset(0.8, 0.2), Offset(0.8, 0.5)], // 1획: ㄱ (작은)
        [Offset(0.2, 0.5), Offset(0.8, 0.5)], // 2획: ㅡ (중간)
        [Offset(0.2, 0.5), Offset(0.2, 0.8), Offset(0.8, 0.8)], // 3획: ㄴ (아래)
      ],
    ),
    'ㅁ': const LetterStroke(
      letter: 'ㅁ',
      paths: [
        [Offset(0.25, 0.2), Offset(0.25, 0.8)], // 1획: ㅣ (왼쪽)
        [Offset(0.25, 0.2), Offset(0.75, 0.2), Offset(0.75, 0.8)], // 2획: ㄱ (오른쪽 위)
        [Offset(0.25, 0.8), Offset(0.75, 0.8)], // 3획: ㅡ (아래)
      ],
    ),
    'ㅂ': const LetterStroke(
      letter: 'ㅂ',
      paths: [
        [Offset(0.25, 0.2), Offset(0.25, 0.8)], // 1획: ㅣ (왼쪽)
        [Offset(0.75, 0.2), Offset(0.75, 0.8)], // 2획: ㅣ (오른쪽)
        [Offset(0.25, 0.5), Offset(0.75, 0.5)], // 3획: ㅡ (중간)
        [Offset(0.25, 0.8), Offset(0.75, 0.8)], // 4획: ㅡ (아래)
      ],
    ),
    'ㅅ': const LetterStroke(
      letter: 'ㅅ',
      paths: [
        [Offset(0.5, 0.2), Offset(0.2, 0.8)], // 1획: / (왼쪽)
        [Offset(0.5, 0.2), Offset(0.8, 0.8)], // 2획: \ (오른쪽)
      ],
    ),
    'ㅇ': const LetterStroke(
      letter: 'ㅇ',
      paths: [
         // 원형에 가깝게 16각으로 근사화 (부드러운 원 그리기)
         [
           Offset(0.50, 0.20), Offset(0.39, 0.22), Offset(0.29, 0.29), Offset(0.22, 0.39),
           Offset(0.20, 0.50), Offset(0.22, 0.61), Offset(0.29, 0.71), Offset(0.39, 0.78),
           Offset(0.50, 0.80), Offset(0.61, 0.78), Offset(0.71, 0.71), Offset(0.78, 0.61),
           Offset(0.80, 0.50), Offset(0.78, 0.39), Offset(0.71, 0.29), Offset(0.61, 0.22),
           Offset(0.50, 0.20)
         ], 
      ],
    ),
    'ㅈ': const LetterStroke(
      letter: 'ㅈ',
      paths: [
        [Offset(0.2, 0.2), Offset(0.8, 0.2)], // 1획: ㅡ
        [Offset(0.5, 0.2), Offset(0.2, 0.8)], // 2획: /
        [Offset(0.5, 0.2), Offset(0.8, 0.8)], // 3획: \
      ],
    ),
    'ㅊ': const LetterStroke(
      letter: 'ㅊ',
      paths: [
         [Offset(0.35, 0.15), Offset(0.65, 0.15)], // 1획: ㅡ (짧은 가로)
         [Offset(0.2, 0.35), Offset(0.8, 0.35)], // 2획: ㅡ (긴 가로)
         [Offset(0.5, 0.35), Offset(0.2, 0.85)], // 3획: / (왼쪽 다리)
         [Offset(0.5, 0.35), Offset(0.8, 0.85)], // 4획: \ (오른쪽 다리)
      ],
    ),
    'ㅋ': const LetterStroke(
      letter: 'ㅋ',
      paths: [
        [Offset(0.2, 0.2), Offset(0.8, 0.2), Offset(0.8, 0.8)], // 1획: ㄱ
        [Offset(0.2, 0.5), Offset(0.8, 0.5)], // 2획: ㅡ (중간)
      ],
    ),
    'ㅌ': const LetterStroke(
      letter: 'ㅌ',
      paths: [
        [Offset(0.25, 0.2), Offset(0.75, 0.2)], // 1획
        [Offset(0.25, 0.5), Offset(0.75, 0.5)], // 2획
        [Offset(0.25, 0.2), Offset(0.25, 0.8), Offset(0.75, 0.8)], // 3획: ㄴ (ㄷ 형태 구현을 위해 세로선 포함)
      ],
    ),
    'ㅍ': const LetterStroke(
      letter: 'ㅍ',
      paths: [
        [Offset(0.2, 0.2), Offset(0.8, 0.2)], // 1획: ㅡ (위)
        [Offset(0.3, 0.2), Offset(0.3, 0.8)], // 2획: ㅣ (왼쪽)
        [Offset(0.7, 0.2), Offset(0.7, 0.8)], // 3획: ㅣ (오른쪽)
        [Offset(0.2, 0.8), Offset(0.8, 0.8)], // 4획: ㅡ (아래)
      ],
    ),
    'ㅎ': const LetterStroke(
      letter: 'ㅎ',
      paths: [
        [Offset(0.35, 0.15), Offset(0.65, 0.15)], // 1획: ㅡ (짧은 가로 - 정자체)
        [Offset(0.2, 0.35), Offset(0.8, 0.35)], // 2획: ㅡ (긴 가로)
        // 3획: ㅇ (원형 근사)
        [
          Offset(0.50, 0.40), Offset(0.42, 0.42), Offset(0.36, 0.46), Offset(0.31, 0.52),
          Offset(0.30, 0.60), Offset(0.31, 0.68), Offset(0.36, 0.74), Offset(0.42, 0.78),
          Offset(0.50, 0.80), Offset(0.58, 0.78), Offset(0.64, 0.74), Offset(0.69, 0.68),
          Offset(0.70, 0.60), Offset(0.69, 0.52), Offset(0.64, 0.46), Offset(0.58, 0.42),
          Offset(0.50, 0.40)
        ],
      ],
    ),
    // --- 기본 모음 추가 (10자) ---
    'ㅏ': const LetterStroke(
      letter: 'ㅏ',
      paths: [
        [Offset(0.5, 0.2), Offset(0.5, 0.8)], // 1획: ㅣ (세로)
        [Offset(0.5, 0.5), Offset(0.8, 0.5)], // 2획: ㅡ (짧은 가로)
      ],
    ),
    'ㅑ': const LetterStroke(
      letter: 'ㅑ',
      paths: [
        [Offset(0.4, 0.2), Offset(0.4, 0.8)], // 1획: ㅣ (세로)
        [Offset(0.4, 0.4), Offset(0.7, 0.4)], // 2획: ㅡ (위)
        [Offset(0.4, 0.6), Offset(0.7, 0.6)], // 3획: ㅡ (아래)
      ],
    ),
    'ㅓ': const LetterStroke(
      letter: 'ㅓ',
      paths: [
        [Offset(0.2, 0.5), Offset(0.5, 0.5)], // 1획: ㅡ (먼저 긋고)
        [Offset(0.5, 0.2), Offset(0.5, 0.8)], // 2획: ㅣ (나중에)
      ],
    ),
    'ㅕ': const LetterStroke(
      letter: 'ㅕ',
      paths: [
        [Offset(0.3, 0.4), Offset(0.6, 0.4)], // 1획: ㅡ (위)
        [Offset(0.3, 0.6), Offset(0.6, 0.6)], // 2획: ㅡ (아래)
        [Offset(0.6, 0.2), Offset(0.6, 0.8)], // 3획: ㅣ (세로)
      ],
    ),
    'ㅗ': const LetterStroke(
      letter: 'ㅗ',
      paths: [
        [Offset(0.5, 0.2), Offset(0.5, 0.5)], // 1획: ㅣ (위에서 중간으로)
        [Offset(0.2, 0.5), Offset(0.8, 0.5)], // 2획: ㅡ (가로)
      ],
    ),
    'ㅛ': const LetterStroke(
      letter: 'ㅛ',
      paths: [
        [Offset(0.35, 0.2), Offset(0.35, 0.5)], // 1획: ㅣ (왼쪽)
        [Offset(0.65, 0.2), Offset(0.65, 0.5)], // 2획: ㅣ (오른쪽)
        [Offset(0.2, 0.5), Offset(0.8, 0.5)],   // 3획: ㅡ (가로)
      ],
    ),
    'ㅜ': const LetterStroke(
      letter: 'ㅜ',
      paths: [
        [Offset(0.2, 0.4), Offset(0.8, 0.4)], // 1획: ㅡ (가로)
        [Offset(0.5, 0.4), Offset(0.5, 0.8)], // 2획: ㅣ (아래로)
      ],
    ),
    'ㅠ': const LetterStroke(
      letter: 'ㅠ',
      paths: [
        [Offset(0.2, 0.4), Offset(0.8, 0.4)], // 1획: ㅡ
        [Offset(0.35, 0.4), Offset(0.35, 0.8)], // 2획: ㅣ (왼쪽)
        [Offset(0.65, 0.4), Offset(0.65, 0.8)], // 3획: ㅣ (오른쪽)
      ],
    ),
    'ㅡ': const LetterStroke(
      letter: 'ㅡ',
      paths: [
        [Offset(0.2, 0.5), Offset(0.8, 0.5)], // 1획: ㅡ
      ],
    ),
    'ㅣ': const LetterStroke(
      letter: 'ㅣ',
      paths: [
        [Offset(0.5, 0.2), Offset(0.5, 0.8)], // 1획: ㅣ
      ],
    ),
    // --- 쌍자음 추가 (5자) ---
    'ㄲ': const LetterStroke(
      letter: 'ㄲ',
      paths: [
        [Offset(0.15, 0.3), Offset(0.45, 0.3), Offset(0.45, 0.7)], // 왼쪽 ㄱ
        [Offset(0.55, 0.3), Offset(0.85, 0.3), Offset(0.85, 0.7)], // 오른쪽 ㄱ
      ],
    ),
    'ㄸ': const LetterStroke(
      letter: 'ㄸ',
      paths: [
        [Offset(0.15, 0.3), Offset(0.45, 0.3)], // 왼쪽 ㄷ-1
        [Offset(0.15, 0.3), Offset(0.15, 0.7), Offset(0.45, 0.7)], // 왼쪽 ㄷ-2
        [Offset(0.55, 0.3), Offset(0.85, 0.3)], // 오른쪽 ㄷ-1
        [Offset(0.55, 0.3), Offset(0.55, 0.7), Offset(0.85, 0.7)], // 오른쪽 ㄷ-2
      ],
    ),
    'ㅃ': const LetterStroke(
      letter: 'ㅃ',
      paths: [
        [Offset(0.15, 0.3), Offset(0.15, 0.7)], // 왼쪽 ㅂ-1
        [Offset(0.4, 0.3), Offset(0.4, 0.7)],   // 왼쪽 ㅂ-2
        [Offset(0.15, 0.5), Offset(0.4, 0.5)],  // 왼쪽 ㅂ-3
        [Offset(0.15, 0.7), Offset(0.4, 0.7)],  // 왼쪽 ㅂ-4
        [Offset(0.6, 0.3), Offset(0.6, 0.7)],   // 오른쪽 ㅂ-1
        [Offset(0.85, 0.3), Offset(0.85, 0.7)], // 오른쪽 ㅂ-2
        [Offset(0.6, 0.5), Offset(0.85, 0.5)],  // 오른쪽 ㅂ-3
        [Offset(0.6, 0.7), Offset(0.85, 0.7)],  // 오른쪽 ㅂ-4
      ],
    ),
    'ㅆ': const LetterStroke(
      letter: 'ㅆ',
      paths: [
        [Offset(0.3, 0.3), Offset(0.1, 0.7)], // 왼쪽 ㅅ-1
        [Offset(0.3, 0.3), Offset(0.45, 0.7)], // 왼쪽 ㅅ-2
        [Offset(0.7, 0.3), Offset(0.5, 0.7)], // 오른쪽 ㅅ-1
        [Offset(0.7, 0.3), Offset(0.9, 0.7)], // 오른쪽 ㅅ-2
      ],
    ),
    'ㅉ': const LetterStroke(
      letter: 'ㅉ',
      paths: [
        [Offset(0.1, 0.3), Offset(0.45, 0.3)], // 왼쪽 ㅈ-1
        [Offset(0.27, 0.3), Offset(0.1, 0.7)], // 왼쪽 ㅈ-2
        [Offset(0.27, 0.3), Offset(0.45, 0.7)], // 왼쪽 ㅈ-3
        [Offset(0.55, 0.3), Offset(0.9, 0.3)], // 오른쪽 ㅈ-1
        [Offset(0.72, 0.3), Offset(0.55, 0.7)], // 오른쪽 ㅈ-2
        [Offset(0.72, 0.3), Offset(0.9, 0.7)], // 오른쪽 ㅈ-3
      ],
    ),
    // --- 이중 모음 (8자) ---
    'ㅐ': const LetterStroke(letter: 'ㅐ', paths: [[Offset(0.4, 0.2), Offset(0.4, 0.8)], [Offset(0.4, 0.5), Offset(0.7, 0.5)], [Offset(0.7, 0.2), Offset(0.7, 0.8)]]),
    'ㅔ': const LetterStroke(letter: 'ㅔ', paths: [[Offset(0.3, 0.5), Offset(0.5, 0.5)], [Offset(0.5, 0.2), Offset(0.5, 0.8)], [Offset(0.8, 0.2), Offset(0.8, 0.8)]]),
    'ㅘ': const LetterStroke(letter: 'ㅘ', paths: [[Offset(0.3, 0.4), Offset(0.3, 0.6)], [Offset(0.1, 0.6), Offset(0.4, 0.6)], [Offset(0.6, 0.2), Offset(0.6, 0.8)], [Offset(0.6, 0.5), Offset(0.9, 0.5)]]),
    'ㅝ': const LetterStroke(letter: 'ㅝ', paths: [[Offset(0.1, 0.4), Offset(0.5, 0.4)], [Offset(0.3, 0.4), Offset(0.3, 0.8)], [Offset(0.4, 0.5), Offset(0.6, 0.5)], [Offset(0.7, 0.2), Offset(0.7, 0.8)]]),
    'ㅟ': const LetterStroke(letter: 'ㅟ', paths: [[Offset(0.1, 0.4), Offset(0.5, 0.4)], [Offset(0.3, 0.4), Offset(0.3, 0.8)], [Offset(0.7, 0.2), Offset(0.7, 0.8)]]),
    'ㅢ': const LetterStroke(letter: 'ㅢ', paths: [[Offset(0.2, 0.6), Offset(0.6, 0.6)], [Offset(0.8, 0.2), Offset(0.8, 0.8)]]),
    'ㅒ': const LetterStroke(letter: 'ㅒ', paths: [[Offset(0.3, 0.2), Offset(0.3, 0.8)], [Offset(0.3, 0.4), Offset(0.5, 0.4)], [Offset(0.3, 0.6), Offset(0.5, 0.6)], [Offset(0.6, 0.2), Offset(0.6, 0.8)]]),
    'ㅖ': const LetterStroke(letter: 'ㅖ', paths: [[Offset(0.2, 0.4), Offset(0.4, 0.4)], [Offset(0.2, 0.6), Offset(0.4, 0.6)], [Offset(0.5, 0.2), Offset(0.5, 0.8)], [Offset(0.8, 0.2), Offset(0.8, 0.8)]]),
    // --- 기본 음절 가~하 (핵심 14자) ---
    '가': const LetterStroke(letter: '가', paths: [[Offset(0.1, 0.3), Offset(0.4, 0.3), Offset(0.4, 0.6)], [Offset(0.6, 0.2), Offset(0.6, 0.8)], [Offset(0.6, 0.5), Offset(0.9, 0.5)]]),
    '나': const LetterStroke(letter: '나', paths: [[Offset(0.1, 0.3), Offset(0.1, 0.7), Offset(0.4, 0.7)], [Offset(0.6, 0.2), Offset(0.6, 0.8)], [Offset(0.6, 0.5), Offset(0.9, 0.5)]]),
    '다': const LetterStroke(letter: '다', paths: [[Offset(0.1, 0.3), Offset(0.4, 0.3)], [Offset(0.1, 0.3), Offset(0.1, 0.7), Offset(0.4, 0.7)], [Offset(0.6, 0.2), Offset(0.6, 0.8)], [Offset(0.6, 0.5), Offset(0.9, 0.5)]]),
    '라': const LetterStroke(letter: '라', paths: [[Offset(0.1, 0.3), Offset(0.4, 0.3), Offset(0.4, 0.45)], [Offset(0.1, 0.45), Offset(0.4, 0.45)], [Offset(0.1, 0.45), Offset(0.1, 0.7), Offset(0.4, 0.7)], [Offset(0.6, 0.2), Offset(0.6, 0.8)], [Offset(0.6, 0.5), Offset(0.9, 0.5)]]),
    '마': const LetterStroke(letter: '마', paths: [[Offset(0.1, 0.3), Offset(0.1, 0.7)], [Offset(0.1, 0.3), Offset(0.4, 0.3), Offset(0.4, 0.7)], [Offset(0.1, 0.7), Offset(0.4, 0.7)], [Offset(0.6, 0.2), Offset(0.6, 0.8)], [Offset(0.6, 0.5), Offset(0.9, 0.5)]]),
    '바': const LetterStroke(letter: '바', paths: [[Offset(0.1, 0.3), Offset(0.1, 0.7)], [Offset(0.4, 0.3), Offset(0.4, 0.7)], [Offset(0.1, 0.5), Offset(0.4, 0.5)], [Offset(0.1, 0.7), Offset(0.4, 0.7)], [Offset(0.6, 0.2), Offset(0.6, 0.8)], [Offset(0.6, 0.5), Offset(0.9, 0.5)]]),
    '사': const LetterStroke(letter: '사', paths: [[Offset(0.25, 0.3), Offset(0.1, 0.7)], [Offset(0.25, 0.3), Offset(0.4, 0.7)], [Offset(0.6, 0.2), Offset(0.6, 0.8)], [Offset(0.6, 0.5), Offset(0.9, 0.5)]]),
    '아': const LetterStroke(letter: '아', paths: [[Offset(0.25, 0.5), Offset(0.2, 0.4), Offset(0.3, 0.3), Offset(0.4, 0.4), Offset(0.45, 0.5), Offset(0.4, 0.6), Offset(0.3, 0.7), Offset(0.2, 0.6), Offset(0.25, 0.5)], [Offset(0.6, 0.2), Offset(0.6, 0.8)], [Offset(0.6, 0.5), Offset(0.9, 0.5)]]),
    '자': const LetterStroke(letter: '자', paths: [[Offset(0.1, 0.3), Offset(0.4, 0.3)], [Offset(0.25, 0.3), Offset(0.1, 0.7)], [Offset(0.25, 0.3), Offset(0.4, 0.7)], [Offset(0.6, 0.2), Offset(0.6, 0.8)], [Offset(0.6, 0.5), Offset(0.9, 0.5)]]),
    '차': const LetterStroke(letter: '차', paths: [[Offset(0.2, 0.2), Offset(0.3, 0.2)], [Offset(0.1, 0.35), Offset(0.4, 0.35)], [Offset(0.25, 0.35), Offset(0.1, 0.7)], [Offset(0.25, 0.35), Offset(0.4, 0.7)], [Offset(0.6, 0.2), Offset(0.6, 0.8)], [Offset(0.6, 0.5), Offset(0.9, 0.5)]]),
    '카': const LetterStroke(letter: '카', paths: [[Offset(0.1, 0.3), Offset(0.4, 0.3), Offset(0.4, 0.7)], [Offset(0.1, 0.5), Offset(0.4, 0.5)], [Offset(0.6, 0.2), Offset(0.6, 0.8)], [Offset(0.6, 0.5), Offset(0.9, 0.5)]]),
    '타': const LetterStroke(letter: '타', paths: [[Offset(0.1, 0.3), Offset(0.4, 0.3)], [Offset(0.1, 0.5), Offset(0.4, 0.5)], [Offset(0.1, 0.3), Offset(0.1, 0.7), Offset(0.4, 0.7)], [Offset(0.6, 0.2), Offset(0.6, 0.8)], [Offset(0.6, 0.5), Offset(0.9, 0.5)]]),
    '파': const LetterStroke(letter: '파', paths: [[Offset(0.1, 0.3), Offset(0.4, 0.3)], [Offset(0.2, 0.3), Offset(0.2, 0.7)], [Offset(0.3, 0.3), Offset(0.3, 0.7)], [Offset(0.1, 0.7), Offset(0.4, 0.7)], [Offset(0.6, 0.2), Offset(0.6, 0.8)], [Offset(0.6, 0.5), Offset(0.9, 0.5)]]),
    '하': const LetterStroke(letter: '하', paths: [[Offset(0.2, 0.2), Offset(0.3, 0.2)], [Offset(0.1, 0.4), Offset(0.4, 0.4)], [Offset(0.25, 0.6), Offset(0.2, 0.5), Offset(0.3, 0.45), Offset(0.4, 0.5), Offset(0.3, 0.6), Offset(0.25, 0.6)], [Offset(0.6, 0.2), Offset(0.6, 0.8)], [Offset(0.6, 0.5), Offset(0.9, 0.5)]]),
    // --- 테마별 핵심 단어 음절 ---
    '기': const LetterStroke(letter: '기', paths: [[Offset(0.1, 0.3), Offset(0.4, 0.3), Offset(0.4, 0.6)], [Offset(0.7, 0.2), Offset(0.7, 0.8)]]),
    '차(Word)': const LetterStroke(letter: '차', paths: [[Offset(0.25, 0.1), Offset(0.25, 0.2)], [Offset(0.1, 0.3), Offset(0.4, 0.3)], [Offset(0.25, 0.3), Offset(0.1, 0.55)], [Offset(0.25, 0.3), Offset(0.4, 0.55)], [Offset(0.7, 0.1), Offset(0.7, 0.9)], [Offset(0.7, 0.5), Offset(0.9, 0.5)]]),
    '버': const LetterStroke(letter: '버', paths: [[Offset(0.1, 0.3), Offset(0.1, 0.5)], [Offset(0.35, 0.3), Offset(0.35, 0.5)], [Offset(0.1, 0.4), Offset(0.35, 0.4)], [Offset(0.1, 0.5), Offset(0.35, 0.5)], [Offset(0.5, 0.4), Offset(0.65, 0.4)], [Offset(0.65, 0.2), Offset(0.65, 0.8)]]),
    '스': const LetterStroke(letter: '스', paths: [[Offset(0.3, 0.3), Offset(0.1, 0.6)], [Offset(0.3, 0.3), Offset(0.5, 0.6)], [Offset(0.1, 0.8), Offset(0.9, 0.8)]]),
    '무': const LetterStroke(letter: '무', paths: [[Offset(0.1, 0.3), Offset(0.1, 0.6)], [Offset(0.1, 0.3), Offset(0.4, 0.3), Offset(0.4, 0.6)], [Offset(0.1, 0.6), Offset(0.4, 0.6)], [Offset(0.1, 0.75), Offset(0.9, 0.75)], [Offset(0.5, 0.75), Offset(0.5, 0.9)]]),
    '산': const LetterStroke(letter: '산', paths: [[Offset(0.3, 0.2), Offset(0.1, 0.5)], [Offset(0.3, 0.2), Offset(0.5, 0.5)], [Offset(0.7, 0.1), Offset(0.7, 0.6)], [Offset(0.7, 0.35), Offset(0.85, 0.35)], [Offset(0.2, 0.7), Offset(0.2, 0.9), Offset(0.8, 0.9)]]),
    '빵': const LetterStroke(letter: '빵', paths: [[Offset(0.2, 0.2), Offset(0.2, 0.5)], [Offset(0.4, 0.2), Offset(0.4, 0.5)], [Offset(0.2, 0.35), Offset(0.4, 0.35)], [Offset(0.2, 0.5), Offset(0.4, 0.5)], [Offset(0.6, 0.2), Offset(0.6, 0.5)], [Offset(0.8, 0.2), Offset(0.8, 0.5)], [Offset(0.6, 0.35), Offset(0.8, 0.35)], [Offset(0.6, 0.5), Offset(0.8, 0.5)], [Offset(0.85, 0.2), Offset(0.85, 0.6)], [Offset(0.85, 0.4), Offset(0.95, 0.4)], [Offset(0.5, 0.8), Offset(0.4, 0.7), Offset(0.5, 0.6), Offset(0.6, 0.7), Offset(0.5, 0.8)]]),
    '우': const LetterStroke(letter: '우', paths: [[Offset(0.5, 0.3), Offset(0.4, 0.2), Offset(0.5, 0.1), Offset(0.6, 0.2), Offset(0.5, 0.3)], [Offset(0.1, 0.5), Offset(0.9, 0.5)], [Offset(0.5, 0.5), Offset(0.5, 0.8)]]),
    '유': const LetterStroke(letter: '유', paths: [[Offset(0.5, 0.3), Offset(0.4, 0.2), Offset(0.5, 0.1), Offset(0.6, 0.2), Offset(0.5, 0.3)], [Offset(0.1, 0.5), Offset(0.9, 0.5)], [Offset(0.35, 0.5), Offset(0.35, 0.8)], [Offset(0.65, 0.5), Offset(0.65, 0.8)]]),
    '늘': const LetterStroke(
      letter: '늘',
      paths: [
        [Offset(0.2, 0.1), Offset(0.2, 0.3), Offset(0.8, 0.3)], // ㄴ
        [Offset(0.1, 0.5), Offset(0.9, 0.5)], // ㅡ
        [Offset(0.2, 0.6), Offset(0.8, 0.6), Offset(0.8, 0.73)], // ㄹ-1
        [Offset(0.2, 0.73), Offset(0.8, 0.73)], // ㄹ-2
        [Offset(0.2, 0.73), Offset(0.2, 0.86), Offset(0.8, 0.86)], // ㄹ-3
      ],
    ),
  };

  static LetterStroke getStroke(String letter) {
    return strokes[letter] ?? 
        const LetterStroke(letter: '?', paths: [[Offset(0.2, 0.2), Offset(0.8, 0.8)]]);
  }
}
