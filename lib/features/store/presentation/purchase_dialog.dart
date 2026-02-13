import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:writing_kid/core/sound/sound_manager.dart';
import 'package:writing_kid/features/theme/data/theme_repository.dart';
import 'package:writing_kid/features/theme/domain/theme_model.dart';
import 'package:writing_kid/features/user/presentation/user_provider.dart';

class PurchaseDialog extends ConsumerWidget {
  final ThemeModel theme;

  const PurchaseDialog({super.key, required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final canAfford = userState.credits >= theme.price;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. 타이틀
            Text(
              '테마 해금하기',
              style: GoogleFonts.jua(fontSize: 28, color: Colors.blueGrey),
            ),
            const SizedBox(height: 16),

            // 2. 테마 정보
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.primaryColor, width: 2),
              ),
              child: Column(
                children: [
                   Text(theme.name, style: GoogleFonts.jua(fontSize: 24, color: theme.primaryColor)),
                   const SizedBox(height: 8),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                        const Icon(Icons.lock_open, size: 20, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text('${theme.price} 리프', style: GoogleFonts.jua(fontSize: 20)),
                     ],
                   )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. 내 지갑 상태
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('내 지갑: ', style: TextStyle(fontSize: 16, color: Colors.grey)),
                const Icon(Icons.eco, color: Colors.green, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${userState.credits}',
                  style: GoogleFonts.jua(
                    fontSize: 20,
                    color: canAfford ? Colors.green[800] : Colors.red,
                  ),
                ),
              ],
            ),
            if (!canAfford)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '리프가 부족해요! 더 모아오세요.',
                  style: GoogleFonts.jua(color: Colors.redAccent, fontSize: 14),
                ),
              ),


            const SizedBox(height: 30),

            // 4. 버튼 영역
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('취소', style: GoogleFonts.jua(fontSize: 18, color: Colors.grey)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: canAfford
                        ? () async {
                            // 1. 리프 차감
                            await ref.read(userProvider.notifier).consumeCredits(theme.price);
                            // 2. 테마 해금
                            ref.read(themeRepositoryProvider.notifier).unlockTheme(theme.id);
                            // 3. 효과음
                            ref.read(soundManagerProvider).playSfx('unlock_success');
                            // 4. 닫기
                            if (context.mounted) Navigator.pop(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                    child: Text('구매하기', style: GoogleFonts.jua(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
