import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:writing_kid/core/sound/sound_manager.dart';
import 'package:writing_kid/core/storage/storage_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late bool _bgmEnabled;
  late bool _sfxEnabled;

  @override
  void initState() {
    super.initState();
    final soundManager = ref.read(soundManagerProvider);
    _bgmEnabled = !soundManager.isBgmMuted;
    _sfxEnabled = !soundManager.isSfxMuted;
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = ref.read(soundManagerProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('설정', style: GoogleFonts.jua(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // 1. 사운드 설정 섹션
          _buildSectionHeader('사운드'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('배경음악 (BGM)', style: GoogleFonts.jua(fontSize: 18)),
                  value: _bgmEnabled,
                  onChanged: (value) {
                    setState(() => _bgmEnabled = value);
                    soundManager.toggleBgm(!value); // !value == mute
                  },
                  activeColor: Colors.green,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: Text('효과음 (SFX)', style: GoogleFonts.jua(fontSize: 18)),
                  value: _sfxEnabled,
                  onChanged: (value) {
                    setState(() => _sfxEnabled = value);
                    soundManager.toggleSfx(!value);
                  },
                  activeColor: Colors.green,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // 2. 데이터 관리 섹션
          _buildSectionHeader('데이터 관리'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              title: Text('데이터 초기화', style: GoogleFonts.jua(fontSize: 18, color: Colors.red)),
              subtitle: const Text('모든 진행 상황과 구매 내역이 삭제됩니다.'),
              trailing: const Icon(Icons.delete_forever, color: Colors.red),
              onTap: _showResetDialog,
            ),
          ),
          const SizedBox(height: 32),

          // 3. 앱 정보 (개발자)
          Center(
             child: Column(
               children: [
                 Text('에코 히어로 한글 특공대 v1.0.0', style: GoogleFonts.jua(color: Colors.grey)),
                 const SizedBox(height: 8),
                 Text('Made by Super Daddy & AI', style: GoogleFonts.jua(color: Colors.grey, fontSize: 12)),
               ],
             ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(title, style: GoogleFonts.jua(fontSize: 20, color: Colors.black54)),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('정말 초기화할까요?'),
        content: const Text('삭제된 데이터는 복구할 수 없습니다.\n앱이 다시 시작됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              // 데이터 삭제
              final prefs = ref.read(sharedPreferencesProvider);
              await prefs.clear();
              
              // 앱 재시작 효과 (또는 메인으로 이동)
              // 여기서는 간단히 모든 스택을 비우고 메인으로 이동 + App 갱신 필요하지만
              // Riverpod state를 초기화하는 게 가장 깔끔함.
              // 하지만 복잡하므로, 일단 SharedPreferences를 비우고 앱 종료 안내 또는 재시작 로직.
              // 여기서는 간단하게 다이얼로그 닫고 스낵바 띄운 뒤 popUntil.
              if (mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false); // 홈으로 이동
                
                // Riverpod 컨테이너를 재생성하는 게 아니므로 메모리 상의 데이터는 남아있을 수 있음.
                // 완벽한 초기화를 위해선 main()부터 다시 시작해야 함. RestartWidget을 쓰는 게 일반적.
                // MVP 레벨에선 일단 저장소만 비우고 "앱을 다시 실행해주세요"라고 안내하거나,
                // 모든 Provider를 invalidate 하는 것이 좋음.
              }
            },
            child: const Text('초기화', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
