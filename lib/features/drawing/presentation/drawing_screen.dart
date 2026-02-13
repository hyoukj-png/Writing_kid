import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:writing_kid/features/theme/data/theme_repository.dart';
import 'package:writing_kid/features/theme/domain/theme_model.dart';
import 'package:writing_kid/core/sound/sound_manager.dart';
import 'package:writing_kid/features/drawing/presentation/drawing_canvas.dart';
import 'package:writing_kid/features/game/domain/lesson_model.dart'; 
import 'package:writing_kid/features/game/presentation/game_controller.dart';
import 'package:writing_kid/features/game/presentation/widgets/theme_clear_dialog.dart';
import 'package:writing_kid/features/game/data/stroke_repository.dart';
import 'package:writing_kid/features/game/domain/stroke_validator.dart';

class DrawingScreen extends ConsumerStatefulWidget {
  final ThemeModel theme;

  const DrawingScreen({super.key, required this.theme});

  @override
  ConsumerState<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends ConsumerState<DrawingScreen> {
  // 쓰기 성공 여부 (전체 성공)
  bool _isDrawingSuccess = false;
  final List<Offset> _trashPositions = [];
  
  // 획 검증 관련 상태
  int _currentStrokeIndex = 0;
  final List<List<Offset>> _completedStrokes = [];
  
  @override
  void initState() {
    super.initState();
    
    // BGM 및 첫 레슨 음성 재생
    WidgetsBinding.instance.addPostFrameCallback((_) {
       ref.read(soundManagerProvider).playBgm(widget.theme.bgmPath);
       ref.read(gameControllerProvider(widget.theme.id).notifier).playCurrentLessonVoice();
    });

    _initializeTrash();
  }
  
  void _initializeTrash() {
    _trashPositions.clear();
    final random = Random();
    for (int i = 0; i < 5; i++) {
       double dx = (random.nextBool() ? 1 : -1) * (140 + random.nextInt(100).toDouble());
       double dy = (random.nextBool() ? 1 : -1) * (140 + random.nextInt(100).toDouble());
       _trashPositions.add(Offset(dx, dy));
    }
  }

  @override
  void dispose() {
    // BGM 정지 등은 필요 시 여기서 처리
    super.dispose();
  }

  // 획 성공 핸들러
  void _handleStrokeComplete(List<Offset> strokePoints) {
    if (strokePoints.isEmpty) return;
    
    final gameState = ref.read(gameControllerProvider(widget.theme.id));
    final currentLesson = gameState.currentLesson;
    final targetLetterData = StrokeRepository.getStroke(currentLesson.letter);

    // 모든 획을 이미 다 그렸으면 무시
    if (_currentStrokeIndex >= targetLetterData.paths.length) return;

    // 현재 그어야 할 획의 정답 경로
    final targetPath = targetLetterData.paths[_currentStrokeIndex];
    
    // 검증 실행 (캔버스 크기 300x300 가정)
    bool isValid = StrokeValidator.validateStroke(
      userPath: strokePoints, 
      targetPath: targetPath, 
      canvasSize: const Size(300, 300),
    );

    if (isValid) {
      // 성공 효과음 (획 하나 성공)
      ref.read(soundManagerProvider).playSfx('stroke_success');
      
      setState(() {
        _completedStrokes.add(strokePoints);
        _currentStrokeIndex++;
      });

      // 모든 획을 다 그렸는지 확인
      if (_currentStrokeIndex >= targetLetterData.paths.length) {
        _handleLessonComplete();
      }
    } else {
      // 실패 피드백 (진동, 소리 등) - 여기선 소리만 넣거나 무반응 (다시 쓰게 유도)
      // ref.read(soundManagerProvider).playSfx('error');
    }
  }
  
  void _handleLessonComplete() {
    setState(() {
      _isDrawingSuccess = true;
    });

    // 컨트롤러 로직 호출 (쓰레기 제거, 오염도 감소)
    final controller = ref.read(gameControllerProvider(widget.theme.id).notifier);
    controller.completeCurrentStage(); 
    
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      
      setState(() {
         _isDrawingSuccess = false;
         _currentStrokeIndex = 0;
         _completedStrokes.clear();
      });
      // 다음 스테이지로 이동
      controller.nextStage();
      // 쓰레기 위치 재설정 (선택 사항)
      _initializeTrash();
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider(widget.theme.id));
    
    ref.listen<GameState>(gameControllerProvider(widget.theme.id), (previous, next) {
      if (previous == null) return;

      // 1. 테마 클리어 다이얼로그
      if (!previous.isThemeCleared && next.isThemeCleared) {
         showDialog(
           context: context,
           barrierDismissible: false,
           builder: (context) => ThemeClearDialog(
             themeName: widget.theme.name,
             onGoHome: () {
               Navigator.pop(context); // Dialog 닫기
               Navigator.pop(context); // 테마 선택 화면으로
             },
           ),
         );
      }

      // 2. 새로운 레슨 시작 음성 안내 (인덱스 변경 시)
      if (previous.currentIndex != next.currentIndex) {
        ref.read(gameControllerProvider(widget.theme.id).notifier).playCurrentLessonVoice();
      }
    });

    final currentLesson = gameState.currentLesson;
    
    // 오염도는 ThemeRepository에서 가져옴
    final themeList = ref.watch(themeRepositoryProvider);
    final currentThemeData = themeList.firstWhere((t) => t.id == widget.theme.id, orElse: () => widget.theme);

    // 쓰레기 개수 계산
    int trashCount = gameState.lessons.length - gameState.currentIndex;
    if (gameState.isThemeCleared) trashCount = 0;
    
    // 현재 글자의 스트로크 데이터 가져오기
    final targetLetterData = StrokeRepository.getStroke(currentLesson.letter);

    return Scaffold(
      backgroundColor: currentThemeData.primaryColor,
      appBar: AppBar(
        title: Text('${currentThemeData.name} (${gameState.currentIndex + 1}/${gameState.lessons.length})', 
            style: GoogleFonts.jua(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. 상단 오염도 게이지
          Positioned(
            top: 20, left: 20, right: 20,
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: currentThemeData.pollutionLevel / 100,
                  backgroundColor: Colors.white30,
                  color: Colors.redAccent,
                  minHeight: 20,
                  borderRadius: BorderRadius.circular(10),
                ),
                Text('오염도: ${currentThemeData.pollutionLevel}%', style: GoogleFonts.jua(color: Colors.white)),
              ],
            ),
          ),

          // 2. 중앙 그리기 캔버스 (라운드 박스)
          Center(
            child: Container(
              width: 380, // 캔버스 크기 약간 키움
              height: 380,
              padding: const EdgeInsets.all(35.0), // 배지/화살표가 잘리지 않도록 여백 충분히 확보
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                   // 2-1. 그리기 캔버스 (가이드 포함)
                   // 학습 진도(currentIndex)에 따라 힌트를 점진적으로 줄임
                   // 0~4번 글자: 모든 힌트 표시
                   // 5~9번 글자: 화살표만 표시
                   // 10번 이후: 힌트 없음
                   SizedBox.expand(
                     child: DrawingCanvas(
                       targetLetter: targetLetterData,
                       currentStrokeIndex: _currentStrokeIndex,
                       completedStrokes: _completedStrokes,
                       onStrokeComplete: _handleStrokeComplete,
                       showOrderHints: gameState.currentIndex < 5,
                       showDirectionArrows: gameState.currentIndex < 10,
                     ),
                   ),
                  
                  // 2-2. 완전히 성공했을 때 체크 아이콘
                  if (_isDrawingSuccess)
                    FadeTransition(
                      opacity: const AlwaysStoppedAnimation(1.0), // 애니메이션 추가 가능
                      child: const Icon(Icons.check_circle, color: Colors.green, size: 150),
                    ),
                ],
              ),
            ),
          ),

          // 3. 쓰레기 레이어 (남은 스테이지 수만큼 표시)
          if (trashCount > 0) ...List.generate(trashCount, (index) {
             final posIndex = index % _trashPositions.length;
             final offset = _trashPositions[posIndex];
             // 쓰레기 위치 미세 조정
             return Positioned(
              left: MediaQuery.of(context).size.width / 2 + offset.dx - 30, // center alignment fix
              top: MediaQuery.of(context).size.height / 2 + offset.dy - 30,
              child: const Icon(Icons.delete_outline, size: 60, color: Colors.brown),
             );
          }),
        ],
      ),
    );
  }
}
