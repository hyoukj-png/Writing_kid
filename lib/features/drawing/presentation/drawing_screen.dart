import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:writing_kid/features/theme/data/theme_repository.dart';
import 'package:writing_kid/features/theme/domain/theme_model.dart';
import 'package:writing_kid/features/drawing/presentation/drawing_canvas.dart';

class DrawingScreen extends ConsumerStatefulWidget {
  final ThemeModel theme;

  const DrawingScreen({super.key, required this.theme});

  @override
  ConsumerState<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends ConsumerState<DrawingScreen> {
  late int _trashCount;
  late int _currentPollution;
  final List<Offset> _trashPositions = [];

  // 글자 쓰기 성공 시 사용할 변수
  bool _isDrawingSuccess = false;

  @override
  void initState() {
    super.initState();
    _currentPollution = widget.theme.pollutionLevel;
    _trashCount = (_currentPollution / 20).ceil().clamp(1, 5);
    
    // 쓰레기 위치 랜덤 생성 (캔버스 주변)
    final random = Random();
    for (int i = 0; i < 5; i++) {
       // 화면 크기를 모르므로 대략적인 위치 잡기 (나중에 LayoutBuilder로 개선 가능)
       // 여기서는 중앙 기준 오프셋으로 랜덤 배치
       double dx = (random.nextBool() ? 1 : -1) * (140 + random.nextInt(100).toDouble()); // 캔버스(150)보다 바깥
       double dy = (random.nextBool() ? 1 : -1) * (140 + random.nextInt(100).toDouble());
       _trashPositions.add(Offset(dx, dy));
    }
  }

  void _handleStrokeComplete(List<Offset> strokePoints) {
    if (strokePoints.length < 10) return; // 너무 짧은 터치는 무시

    // 간단한 판정 로직: 점의 개수가 충분하고, 특정 영역을 지나갔는지 확인
    // (여기서는 무조건 성공으로 가정하고 피드백을 줌)
    setState(() {
      _isDrawingSuccess = true;
    });

    // 1. 성공 이펙트 (반짝임 등) -> 2. 쓰레기 제거 -> 3. 오염도 감소
    Future.delayed(const Duration(milliseconds: 500), () {
      _removeTrash();
      setState(() {
        _isDrawingSuccess = false; // 다시 그릴 수 있게 초기화
      });
    });
  }

  void _removeTrash() {
    if (_trashCount > 0) {
      setState(() {
        _trashCount--;
        // 오염도 감소 로직 호출 (Repository)
        ref.read(themeRepositoryProvider.notifier).decreasePollution(widget.theme.id);
        
        // 로컬 UI 상태도 업데이트 (게이지 반영)
        _currentPollution = (_currentPollution - 20).clamp(0, 100);
      });

      // 효과음 재생 (추후 추가)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('멋진 글씨네요! 쓰레기가 사라졌어요! ✨'), duration: Duration(milliseconds: 800)),
      );

      if (_trashCount == 0) {
        _showSuccessDialog();
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 정화 완료!'),
        content: Text('${widget.theme.name}을(를) 구해냈어요!\n정말 대단해요!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
              Navigator.pop(context); // 테마 선택 화면으로 돌아가기
            },
            child: const Text('돌아가기'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 실시간으로 변경된 테마 정보를 구독 (오염도 반영을 위해)
    final themeList = ref.watch(themeRepositoryProvider);
    final currentThemeData = themeList.firstWhere((t) => t.id == widget.theme.id, orElse: () => widget.theme);

    return Scaffold(
      backgroundColor: currentThemeData.primaryColor,
      appBar: AppBar(
        title: Text('${currentThemeData.name}을 구해줘!', style: GoogleFonts.jua(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. 상단 오염도 게이지
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: currentThemeData.pollutionLevel / 100,
                  backgroundColor: Colors.white30,
                  color: Colors.redAccent,
                  minHeight: 20,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 5),
                Text(
                  '오염도: ${currentThemeData.pollutionLevel}%',
                  style: GoogleFonts.jua(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),

          // 2. 중앙 그리기 캔버스 (라운드 박스)
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 2-1. 가이드 글자 (연한 회색)
                  Text(
                    '가',
                    style: GoogleFonts.nanumPenScript(
                      fontSize: 200,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ),

                  // 2-2. 실제 그리기 패널
                  SizedBox.expand(
                    child: DrawingCanvas(onStrokeComplete: _handleStrokeComplete),
                  ),
                ],
              ),
            ),
          ),

          // 3. 쓰레기 레이어 (랜덤 위치에 뿌리기)
          if (_trashCount > 0) ...List.generate(_trashCount, (index) {
            final offset = _trashPositions[index]; // 미리 생성한 랜덤 위치 사용
            return Positioned(
              left: MediaQuery.of(context).size.width / 2 + offset.dx, 
              top: MediaQuery.of(context).size.height / 2 + offset.dy,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: 1.0, 
                child: const Icon(Icons.delete_outline, size: 60, color: Colors.brown), // 임시 아이콘
              ),
            );
          }),
        ],
      ),
    );
  }
}
