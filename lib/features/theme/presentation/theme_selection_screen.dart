import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:writing_kid/features/theme/data/theme_repository.dart';
import 'package:writing_kid/features/theme/domain/theme_model.dart';
import 'package:lottie/lottie.dart';
import 'package:writing_kid/features/drawing/presentation/drawing_screen.dart';

class ThemeSelectionScreen extends ConsumerStatefulWidget {
  const ThemeSelectionScreen({super.key});

  @override
  ConsumerState<ThemeSelectionScreen> createState() =>
      _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends ConsumerState<ThemeSelectionScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // 카드 슬라이더 효과를 위해 viewportFraction을 0.8로 설정 (양옆 카드 살짝 보임)
    _pageController = PageController(viewportFraction: 0.8, initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. ThemeRepository (Provider)에서 테마 리스트 가져오기
    final themeList = ref.watch(themeRepositoryProvider);

    return Scaffold(
      backgroundColor: Colors.black87, // 우주 배경 느낌
      appBar: AppBar(
        title: Text(
          '어디를 구해줄까?',
          style: GoogleFonts.jua(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          height: 500, // 카드 높이
          child: PageView.builder(
            controller: _pageController,
            itemCount: themeList.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final theme = themeList[index];
              return _buildThemeCard(theme, index);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildThemeCard(ThemeModel theme, int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 1.0;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page! - index;
          value = (1 - (value.abs() * 0.2)).clamp(0.8, 1.0);
        } else {
          // 초기 로딩 시 현재 페이지만 크게
          value = (index == _currentPage) ? 1.0 : 0.8;
        }

        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        clipBehavior: Clip.antiAlias, // 자식 위젯이 둥근 모서리를 넘지 않도록 자름
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. 배경 색상 (필수)
            Container(color: theme.primaryColor),

            // 2. 배경 이미지 (에러 방지 처리)
            Image.asset(
              theme.backgroundAsset,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // 이미지가 없으면 배경색만 유지하고 아이콘 표시 안 함 (깔끔하게)
                return const SizedBox.shrink();
              },
            ),

            // 3. 오염도 레이어 (반투명 오버레이)
            if (theme.pollutionLevel > 0)
              Container(
                color: Colors.black.withOpacity(0.3 * (theme.pollutionLevel / 100)),
              ),

            // 4. 중앙 콘텐츠 (이름 & 아이콘)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 아이콘 (에러 처리)
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Image.asset(
                    theme.iconAsset,
                    errorBuilder: (c, e, s) => Icon(
                      Icons.park, // 기본 아이콘
                      size: 80,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  theme.name,
                  style: GoogleFonts.jua(
                    fontSize: 42,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      const Shadow(blurRadius: 10, color: Colors.black45, offset: Offset(2, 2)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  theme.description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.jua(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),

            // 5. 하단 버튼 영역
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: theme.isUnlocked
                  ? ElevatedButton(
                      onPressed: () {
                        // 게임 화면으로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DrawingScreen(theme: theme),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: theme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        '✨ 출동하기!',
                        style: GoogleFonts.jua(fontSize: 24),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: () {
                        // 해금 로직 호출
                        ref
                            .read(themeRepositoryProvider.notifier)
                            .unlockTheme(theme.id);
                      },
                      icon: const Icon(Icons.lock, color: Colors.white),
                      label: Text(
                        '잠금 해제 (${theme.price} 리프)',
                        style: GoogleFonts.jua(fontSize: 20, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black54,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
