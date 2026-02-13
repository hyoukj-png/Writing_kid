import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeClearDialog extends StatefulWidget {
  final String themeName;
  final VoidCallback onGoHome;

  const ThemeClearDialog({
    super.key,
    required this.themeName,
    required this.onGoHome,
  });

  @override
  State<ThemeClearDialog> createState() => _ThemeClearDialogState();
}

class _ThemeClearDialogState extends State<ThemeClearDialog> {
  // 간단한 애니메이션 효과용 변수 (Scale)
  double _scale = 0.5;

  @override
  void initState() {
    super.initState();
    // 팝업 등장 애니메이션
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) setState(() => _scale = 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 500),
        curve: Curves.elasticOut,
        scale: _scale,
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10))
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. 폭죽 & 아이콘 효과
              Stack(
                alignment: Alignment.center,
                children: [
                   const Icon(Icons.star, size: 100, color: Colors.amber), // Star
                   Positioned(top: 0, right: 0, child: Icon(Icons.celebration, size: 40, color: Colors.blue[300])),
                   Positioned(bottom: 0, left: 0, child: Icon(Icons.wb_sunny, size: 40, color: Colors.orange[300])),
                ],
              ),
              const SizedBox(height: 20),

              // 2. 축하 메시지
              Text(
                '정화 완료!',
                style: GoogleFonts.jua(fontSize: 32, color: Colors.green),
              ),
              const SizedBox(height: 10),
              Text(
                '${widget.themeName}을(를)\n완벽하게 구해냈어요!',
                textAlign: TextAlign.center,
                style: GoogleFonts.jua(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 24),

              // 3. 보상 정보
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.eco, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      '+500 리프 획득!',
                      style: GoogleFonts.jua(fontSize: 20, color: Colors.green[800]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 4. 홈으로 돌아가기 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onGoHome,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    '메인으로 나가기',
                    style: GoogleFonts.jua(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
