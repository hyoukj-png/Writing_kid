# 제품 요구사항 정의서 (PRD) - 에코 히어로 한글 특공대 (Eco-Hero Hangul)

## 1. 프로젝트 개요

* **앱 이름:** 에코 히어로 한글 특공대 (Eco-Hero Hangul)
* **타겟 사용자:** 5~7세 미취학 아동 (태블릿 중심, 스마트폰 호환)
* **핵심 컨셉:** "글자를 써서 오염된 세상을 구한다" - 환경 보호 스토리텔링과 한글 쓰기 학습의 결합 (Gamification)
* **플랫폼:** Flutter (Android/iOS)

## 2. 사용자 흐름 (User Flow)

1. **온보딩 (Intro):**
    * 오염된 지구 영상 재생.
    * "한글 특공대, 출동!" 메시지와 함께 8개 테마 중 **첫 번째 무료 테마 선택**.
2. **메인 월드맵 (Home):**
    * 8개 위성(테마)이 지구를 돌고 있음.
    * 각 테마 위에 **오염도(Pollution Level)** 게이지 표시 (예: 80% 오염됨).
    * 무료/해금된 테마는 밝게, 잠긴 테마는 자물쇠 아이콘 표시.
3. **테마 진입 (Game Mode):**
    * 화면에 **쓰레기(Trash Layer)**가 가득 참.
    * **입력 모드 토글** (S펜 🖊️ vs 손가락 👆) 확인.
4. **쓰기 학습 (Writing):**
    * 한글 낱자/단어 제시 -> 획순 가이드 애니메이션.
    * 유저가 따라 쓰기 -> 정확도 판정.
5. **정화 및 보상 (Cleansing & Reward):**
    * **성공 시:** 화면의 쓰레기가 펑! 하고 사라짐 (Particle Effect).
    * **보상:** '에코 리프(Eco Leaf)' 획득.
    * **결과:** 오염도 감소. 오염도가 0%가 되면 테마가 **정화됨(Shiny Effect)** 상태로 변신하고 숨겨진 캐릭터 등장.

## 3. 핵심 기능 상세 (Core Specs)

### 3.1. 테마 시스템 (8 Worlds)

| 테마 ID | 이름 | 컨셉 | 오염 요소 예시 | 정화 후 모습 |
| :--- | :--- | :--- | :--- | :--- |
| `theme_dino` | 공룡 (Dino) | 화산재와 뼈다귀 | 검은 연기, 뼈 | 푸른 숲, 살아있는 공룡 |
| `theme_space` | 우주 (Space) | 우주 쓰레기 | 부서진 인공위성 | 반짝이는 은하수 |
| `theme_ocean` | 바다 (Ocean) | 플라스틱 섬 | 비닐봉지, 페트병 | 맑은 산호초, 물고기 |
| `theme_princess`| 공주 (Princess)| 먼지 쌓인 성 | 거미줄, 회색 벽 | 화려한 무도회장 |
| `theme_robot` | 로봇 (Robot) | 녹슨 고철 | 녹물, 부서진 부품 | 최첨단 미래 도시 |
| `theme_forest` | 숲 (Forest) | 말라죽은 나무 | 베어진 그루터기 | 울창한 숲, 다람쥐 |
| `theme_car` | 자동차 (Car) | 매연 도시 | 스모그, 낡은 타이어 | 전기차, 맑은 도로 |
| `theme_bakery` | 베이커리 (Bakery)| 곰팡이 핀 빵 | 상한 음식, 파리 | 갓 구운 빵, 파티 |

### 3.2. 하이브리드 입력 엔진 (Writing Engine)

* **공통:** `CustomPainter` 기반 획 추적 logic.
* **S-Pen 모드:**
  * `Palm Rejection`: **ON** (손바닥 터치 무시).
  * `Pressure Sensitivity`: **ON** (필압에 따라 선 굵기 3.0 ~ 8.0px 가변).
  * `StylusOnly`: `PointerDeviceKind.stylus` 이벤트만 수신.
* **Finger 모드:**
  * `Palm Rejection`: **OFF** (멀티터치 허용하되, 첫 번째 터치만 인식).
  * `Magic Pen Effect`: 일정한 굵기(10.0px)와 무지개/단색 그라데이션 효과.
* **UI:** 화면 상단에 모드 전환 토글 버튼 배치 (즉시 전환).

### 3.3. 비즈니스 모델 (BM) - 하이브리드

* **화폐:** **에코 리프 (Eco Leaf)** 🍃
  * 획득: 글자 쓰기 성공 시 (+1), 스테이지 클리어 시 (+10).
  * 사용: 잠겨있는 테마 해금 (예: 100 리프로 '우주 테마' 해금).
* **IAP (In-App Purchase):**
  * **Eco Pass:** 모든 테마 즉시 해금 + 무한 에코 리프.
  * **Leaf Pack:** 에코 리프 묶음 구매 (시간 단축).
* **최초 무료:** 설치 후 1개 테마 선택 무료 제공 (Onboarding).

## 4. 데이터 모델 (Data Structure)

### 4.1. UserProfile (Local DB - Hive/SQLite)

```dart
class UserProfile {
  final String uid;         // 로컬 유저 ID
  String name;              // 아이 이름
  int ecoLeafBalance;       // 보유 재화 (Leaves)
  List<String> unlockedThemes; // 해금된 테마 ID 목록 ['theme_dino']
  Map<String, double> pollutionStatus; // {'theme_dino': 0.2, 'theme_space': 1.0} (0.0=Clean, 1.0=Dirty)
  bool isSoundOn;           // 설정
  InputMode inputMode;      // .spen or .finger
}
```

### 4.2. WritingData (Asset JSON)

```dart
class SymbolData {
  final String char;        // 'ㄱ', '가', '사과'
  final List<List<Offset>> strokes; // 정답 획 좌표
  final int difficulty;     // 난이도
  final String soundAsset;  // 발음 오디오
}
```

## 5. 기술 스택 및 라이브러리 (Tech Stack)

* **Framework:** Flutter (Latest Stable)
* **State Management:** **Riverpod (Code Generation)** (@riverpod, riverpod_annotation)
* **Local Data:**
  * `shared_preferences`: 간단한 설정(볼륨, 입력 모드).
  * `hive` or `sqflite`: 유저 진행도, 인벤토리 등 구조화된 데이터.
* **Sound:** `audioplayers` (효과음 중첩 재생, BGM 루프).
* **Graphics:**
  * `flutter_svg`: UI 아이콘.
  * `rive` or `lottie`: 캐릭터/정화 애니메이션.
* **IAP:** `in_app_purchase`.

## 6. UI 화면 명세 (Screen List)

1. **Splash:** 로고 애니메이션.
2. **Onboarding:** 스토리 컷씬 -> 무료 테마 선택.
3. **Home (World Map):** 3D/2D 행성 뷰, 테마 선택, 상점 버튼.
4. **Theme Detail (Stage Select):** 해당 테마의 레벨(단어) 선택.
5. **Play Screen (Canvas):**
    * [Top] 진행바(오염도), 홈 버튼, 모드 토글.
    * [Center] 쓰기 영역 (가이드라인 + 캔버스).
    * [Bottom] 펜 도구(색상 변경, 지우개).
6. **Success Dialog:** 획득한 에코 리프 애니메이션, "정화 완료!" 메시지.
7. **Store:** IAP 및 리프 교환소.
