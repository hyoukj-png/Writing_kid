import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:writing_kid/core/sound/sound_manager.dart';
import 'package:writing_kid/features/game/domain/lesson_model.dart';
import 'package:writing_kid/features/theme/data/theme_repository.dart';
import 'package:writing_kid/features/user/presentation/user_provider.dart';

// 현재 게임 상태 (어떤 글자 단계인지)
class GameState {
  final List<LessonModel> lessons;
  final int currentIndex;
  final bool isThemeCleared;

  const GameState({
    required this.lessons,
    required this.currentIndex,
    required this.isThemeCleared,
  });

  LessonModel get currentLesson => lessons[currentIndex];
  double get progress => (currentIndex + 1) / lessons.length;
}

// 게임 컨트롤러 Provider (테마 ID를 인자로 받음)
final gameControllerProvider =
    StateNotifierProvider.family.autoDispose<GameController, GameState, String>(
  (ref, themeId) => GameController(ref, themeId),
);

// GameController (Riverpod Notifier)
class GameController extends StateNotifier<GameState> {
  final Ref ref;
  final String themeId;

  GameController(this.ref, this.themeId)
      : super(GameState(
          lessons: _getLessonsForTheme(themeId),
          currentIndex: 0,
          isThemeCleared: false,
        ));

  // 사용자가 글자 쓰기에 성공했을 때 호출
  Future<void> completeCurrentStage() async {
    if (state.isThemeCleared) return;

    // 1. 오염도 감소 로직 호출 (테마 리포지토리)
    // 전체 단계 수에 맞춰 균등하게 오염도 감소 (약 100 / N)
    int decreaseAmount = (100 / state.lessons.length).ceil();
    ref.read(themeRepositoryProvider.notifier).decreasePollution(themeId, decreaseAmount);

    // 2. 효과음 재생
    ref.read(soundManagerProvider).playSfx('clean_complete');

    // 3. 글자 음성 재생 (강화 학습)
    await Future.delayed(const Duration(milliseconds: 500)); // 효과음과 겹치지 않게 약간 뒤에 재생
    await playCurrentLessonVoice();
  }

  // 현재 레슨의 음성 재생
  Future<void> playCurrentLessonVoice() async {
    final lesson = state.currentLesson;
    await ref.read(soundManagerProvider).playVoice(lesson.soundPath);
  }

  // 다음 글자로 넘기는 함수 (DrawingScreen에서 애니메이션 후 호출)
  void nextStage() {
    if (state.currentIndex < state.lessons.length - 1) {
      state = GameState(
        lessons: state.lessons,
        currentIndex: state.currentIndex + 1,
        isThemeCleared: false,
      );
    } else {
      // 마지막 단계 클리어 -> 테마 정화 완료!
      state = GameState(
        lessons: state.lessons,
        currentIndex: state.currentIndex,
        isThemeCleared: true,
      );
      
      // 사용자 보상 지급 (500 리프)
      ref.read(userProvider.notifier).addCredits(500);
      
      // 팡파레 효과음
      ref.read(soundManagerProvider).playSfx('theme_clear');
    }
  }

  // 테마별 학습 글자 데이터 (하드코딩)
  static List<LessonModel> _getLessonsForTheme(String themeId) {
    switch (themeId) {
      case 'dino':
        return [
          const LessonModel(letter: 'ㄱ', soundPath: 'sounds/giyok.mp3'),
          const LessonModel(letter: 'ㄴ', soundPath: 'sounds/nieun.mp3'),
          const LessonModel(letter: 'ㄷ', soundPath: 'sounds/digeut.mp3'),
          const LessonModel(letter: 'ㄹ', soundPath: 'sounds/rieul.mp3'),
          const LessonModel(letter: 'ㅁ', soundPath: 'sounds/mieum.mp3'),
          const LessonModel(letter: 'ㅂ', soundPath: 'sounds/bieup.mp3'),
          const LessonModel(letter: 'ㅅ', soundPath: 'sounds/siot.mp3'),
          const LessonModel(letter: 'ㅇ', soundPath: 'sounds/ieung.mp3'),
          const LessonModel(letter: 'ㅈ', soundPath: 'sounds/jieut.mp3'),
          const LessonModel(letter: 'ㅊ', soundPath: 'sounds/chieut.mp3'),
          const LessonModel(letter: 'ㅋ', soundPath: 'sounds/kieuk.mp3'),
          const LessonModel(letter: 'ㅌ', soundPath: 'sounds/tieut.mp3'),
          const LessonModel(letter: 'ㅍ', soundPath: 'sounds/pieup.mp3'),
          const LessonModel(letter: 'ㅎ', soundPath: 'sounds/hieut.mp3'),
        ];
      case 'space': // 우주 테마는 이제 '모음' 학습 단계로 활용
        return [
          const LessonModel(letter: 'ㅏ', soundPath: 'sounds/ah.mp3'),
          const LessonModel(letter: 'ㅑ', soundPath: 'sounds/ya.mp3'),
          const LessonModel(letter: 'ㅓ', soundPath: 'sounds/eo.mp3'),
          const LessonModel(letter: 'ㅕ', soundPath: 'sounds/yeo.mp3'),
          const LessonModel(letter: 'ㅗ', soundPath: 'sounds/o.mp3'),
          const LessonModel(letter: 'ㅛ', soundPath: 'sounds/yo.mp3'),
          const LessonModel(letter: 'ㅜ', soundPath: 'sounds/u.mp3'),
          const LessonModel(letter: 'ㅠ', soundPath: 'sounds/yu.mp3'),
          const LessonModel(letter: 'ㅡ', soundPath: 'sounds/eu.mp3'),
          const LessonModel(letter: 'ㅣ', soundPath: 'sounds/i.mp3'),
        ];
      case 'robot': // 로봇 테마: 쌍자음
        return [
          const LessonModel(letter: 'ㄲ', soundPath: 'sounds/kk_giyeok.mp3'),
          const LessonModel(letter: 'ㄸ', soundPath: 'sounds/tt_digeut.mp3'),
          const LessonModel(letter: 'ㅃ', soundPath: 'sounds/pp_bieup.mp3'),
          const LessonModel(letter: 'ㅆ', soundPath: 'sounds/ss_siot.mp3'),
          const LessonModel(letter: 'ㅉ', soundPath: 'sounds/jj_jieut.mp3'),
        ];
      case 'ocean': // 바다 테마: 이중 모음
        return [
          const LessonModel(letter: 'ㅐ', soundPath: 'sounds/ae.mp3'),
          const LessonModel(letter: 'ㅔ', soundPath: 'sounds/e.mp3'),
          const LessonModel(letter: 'ㅘ', soundPath: 'sounds/wa.mp3'),
          const LessonModel(letter: 'ㅝ', soundPath: 'sounds/wo.mp3'),
          const LessonModel(letter: 'ㅟ', soundPath: 'sounds/wi.mp3'),
          const LessonModel(letter: 'ㅢ', soundPath: 'sounds/ui.mp3'),
        ];
      case 'princess': // 공주 테마: 기본 가나다
        return [
          const LessonModel(letter: '가', soundPath: 'sounds/ga.mp3'),
          const LessonModel(letter: '나', soundPath: 'sounds/na.mp3'),
          const LessonModel(letter: '다', soundPath: 'sounds/da.mp3'),
          const LessonModel(letter: '라', soundPath: 'sounds/ra.mp3'),
          const LessonModel(letter: '마', soundPath: 'sounds/ma.mp3'),
          const LessonModel(letter: '바', soundPath: 'sounds/ba.mp3'),
          const LessonModel(letter: '사', soundPath: 'sounds/sa.mp3'),
          const LessonModel(letter: '아', soundPath: 'sounds/a.mp3'),
          const LessonModel(letter: '자', soundPath: 'sounds/ja.mp3'),
          const LessonModel(letter: '차', soundPath: 'sounds/cha.mp3'),
          const LessonModel(letter: '카', soundPath: 'sounds/ka.mp3'),
          const LessonModel(letter: '타', soundPath: 'sounds/ta.mp3'),
          const LessonModel(letter: '파', soundPath: 'sounds/pa.mp3'),
          const LessonModel(letter: '하', soundPath: 'sounds/ha.mp3'),
        ];
      case 'car': // 자동차 테마: 탈것 단어
        return [
          const LessonModel(letter: '기', soundPath: 'sounds/gi.mp3'),
          const LessonModel(letter: '차(Word)', soundPath: 'sounds/cha.mp3'),
          const LessonModel(letter: '버', soundPath: 'sounds/beo.mp3'),
          const LessonModel(letter: '스', soundPath: 'sounds/seu.mp3'),
        ];
      case 'forest': // 숲 테마: 자연 단어
        return [
          const LessonModel(letter: '나', soundPath: 'sounds/na.mp3'),
          const LessonModel(letter: '무', soundPath: 'sounds/mu.mp3'),
          const LessonModel(letter: '산', soundPath: 'sounds/san.mp3'),
          const LessonModel(letter: '하', soundPath: 'sounds/ha.mp3'),
          const LessonModel(letter: '늘', soundPath: 'sounds/neul.mp3'),
        ];
      case 'bakery': // 빵집 테마: 음식 단어
        return [
          const LessonModel(letter: '빵', soundPath: 'sounds/ppang.mp3'),
          const LessonModel(letter: '우', soundPath: 'sounds/u.mp3'),
          const LessonModel(letter: '유', soundPath: 'sounds/yu.mp3'),
        ];
      default:
        // 기본값 (다른 테마용)
        return [
          const LessonModel(letter: 'ㄱ', soundPath: 'sounds/giyok.mp3'),
        ];
    }
  }
}
