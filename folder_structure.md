# Flutter Project Folder Structure (Riverpod Features-First)

이 구조는 **Riverpod Code Generation**을 사용하고, **기능 단위(Feature-first)**로 모듈화된 아키텍처입니다.

```plaintext
lib/
├── main.dart                       # 앱 진입점
├── app_router.dart                 # GoRouter 설정
├── app.dart                        # MaterialApp, Global Providers
├── core/                           # 공통 모듈
│   ├── constants/                  # 앱 전역 상수 (Strings, Keys)
│   ├── theme/                      # 디자인 시스템
│   │   ├── app_colors.dart         # 테마별 컬러 팔레트
│   │   ├── app_fonts.dart
│   │   └── app_theme.dart          # ThemeData 설정
│   ├── utils/                      # 유틸리티
│   │   ├── logger.dart
│   │   └── input_utils.dart        # 입력 장치 감지 로직
│   └── common_widgets/             # 공통 위젯 (버튼, 다이얼로그)
│       ├── eco_button.dart
│       └── loading_overlay.dart
├── features/                       # 핵심 기능 모듈
│   ├── authentication/             # (선택) 로컬 프로필 관리
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   ├── home_world/                 # 메인 월드맵 & 오염도 표시
│   │   ├── domain/                 # ThemeModel
│   │   ├── data/                   # ThemeRepository (Assets 로드)
│   │   └── presentation/           # WorldMapScreen, PlanetWidget
│   │       └── providers/          # theme_controller.g.dart
│   ├── writing_engine/             # 핵심: 글자 쓰기 및 캔버스
│   │   ├── domain/                 # StrokePath, WritingReview
│   │   ├── logic/                  # 획 인식 알고리즘 (CustomPainter)
│   │   └── presentation/
│   │       ├── canvas_screen.dart
│   │       ├── widgets/            # PaintCanvas, GuideLayer
│   │       └── providers/          # writing_state_provider.g.dart
│   ├── pollution_system/           # 오염/정화 로직 & 시각 효과
│   │   ├── domain/
│   │   └── presentation/           # TrashLayerWidget, ParticleEffect
│   ├── store_iap/                  # 상점 및 인앱 결제
│   │   ├── data/                   # IAP Service
│   │   └── presentation/           # StoreScreen
│   └── settings/                   # 입력 모드 설정 등
│       └── message_provider.dart
└── data/                           # 전역 데이터 소스
    ├── local/                      # Hive/SQLite/SharedPrefs
    │   ├── app_database.dart
    │   └── preference_service.dart
    └── models/                     # 전역 DTO
        └── user_progress_model.dart

assets/
├── fonts/
│   └── Jua-Regular.ttf             # 예: 귀여운 한글 폰트
├── sound/
│   ├── bgm/
│   │   ├── theme_dino.mp3
│   │   └── theme_space.mp3
│   └── sfx/
│       ├── success.wav
│       └── clean_pop.wav
├── images/
│   ├── ui/                         # 버튼, 아이콘
│   └── themes/                     # 8개 테마별 리소스 분리
│       ├── dino/
│       │   ├── bg_polluted.png     # 오염된 배경
│       │   ├── bg_clean.png        # 정화된 배경
│       │   ├── trash_items/        # 뼈다귀, 화산재 이미지
│       │   └── character_unlock.png
│       ├── space/
│       │   └── ...
│       ├── ocean/
│       │   └── ...
│       ├── princess/
│       ├── robot/
│       ├── forest/
│       ├── car/
│       └── bakery/
└── data/
    └── curriculum.json             # 글자 획순 좌표 데이터
```

## 주요 포인트

1. **`features/writing_engine`**: 가장 복잡한 캔버스 로직이 들어가는 곳입니다.
2. **`assets/themes/`**: 각 테마별(dino, space 등)로 리소스가 섞이지 않게 폴더를 엄격하게 분리하여 관리합니다.
3. **Riverpod**: 각 feature의 `presentation/providers` 폴더에 상태 관리 코드를 위치시킵니다.
