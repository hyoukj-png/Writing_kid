# Writing Kid: Design Documentation

## 1. 개요 (Overview)

"Writing Kid"는 아이들이 8가지 테마를 여행하며 한글을 재미있게 익힐 수 있는 교육용 앱입니다. 각 테마는 오염된 환경을 정화하는 컨셉으로, 글자를 바르게 쓸 때마다 오염도가 낮아지며 최종적으로 깨끗한 테마를 완성하게 됩니다.

## 2. 핵심 아키텍처 (Key Architecture)

### 2.1. 게임 컨트롤러 (Game Controller)

* **파일**: `lib/features/game/presentation/game_controller.dart`
* **역할**:
  * 테마별 레슨 데이터(`LessonModel`) 관리.
  * 학습 진행 상태(현재 인덱스, 클리어 여부) 관리.
  * 오염도 감소 및 사용자 보상(Credits) 로직 수행.
  * 학습 음성 재생 제어.

### 2.2. 글자 획 데이터 (Stroke Repository)

* **파일**: `lib/features/game/data/stroke_repository.dart`
* **역할**:
  * 한글 자음, 모음, 쌍자음, 이중 모음, 주요 음절 및 단어의 0.0~1.0 정규화된 좌표 데이터(`paths`) 보유.
  * 교육적 정석(바른 글씨)에 맞춘 획 순서와 모양 정의.

### 2.3. 사운드 시스템 (Sound Manager)

* **파일**: `lib/core/sound/sound_manager.dart`
* **역할**:
  * BGM, SFX, 그리고 학습용 음성(Voice) 재생 관리.
  * `playVoice(path)`를 통해 커리큘럼별 글자 소리 출력.

## 3. 학습 커리큘럼 (Curriculum)

1. **Dino**: 기초 자음 (ㄱ~ㅎ)
2. **Space**: 기초 모음 (ㅏ~ㅣ)
3. **Robot**: 심화 쌍자음 (ㄲ, ㄸ, ㅃ, ㅆ, ㅉ)
4. **Ocean**: 심화 이중 모음 (ㅐ, ㅔ, ㅘ, ㅝ, ㅟ, ㅢ, ㅒ, ㅖ)
5. **Princess**: 기본 음절 조합 (가~하 14자)
6. **Car**: 탈것 단어 (기차, 버스)
7. **Forest**: 자연 단어 (나무, 산, 하늘)
8. **Bakery**: 음식 단어 (빵, 우유)

## 4. UI/UX 디자인 원칙

* **동적 가이드**: `currentIndex`에 따라 힌트(획 번호, 화살표)를 점진적으로 제거하여 아이의 자립 학습 유도.
* **학습 강화**: 레슨 시작 시 음성으로 글자를 알려주고, 완료 시 다시 한번 들려주어 각인 효과 극대화.
* **보상 시스템**: 테마 클리어 시 팡파레 효과와 함께 크레딧 지급.

## 5. 현재 상태 (Current Status)

* 모든 8개 테마의 커리큘럼 및 데이터 구현 완료.
* 음성 안내 시스템(시작/완료 시 재생) 연동 완료.
* 한글 폰트 및 획 모양 최적화 완료.
