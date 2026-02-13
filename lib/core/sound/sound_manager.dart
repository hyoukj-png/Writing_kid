import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 앱 전체의 사운드를 관리하는 매니저
class SoundManager {
  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  
  bool _isBgmMuted = false;
  bool _isSfxMuted = false;
  String? _currentBgmPath;

  bool get isBgmMuted => _isBgmMuted;
  bool get isSfxMuted => _isSfxMuted;

  void toggleBgm(bool mute) {
    _isBgmMuted = mute;
    if (mute) {
      _bgmPlayer.setVolume(0);
    } else {
      _bgmPlayer.setVolume(0.5);
    }
  }

  void toggleSfx(bool mute) {
    _isSfxMuted = mute;
    if (mute) {
      _sfxPlayer.setVolume(0);
    } else {
      _sfxPlayer.setVolume(1.0);
    }
  }

  // 테마별 BGM 재생
  Future<void> playBgm(String path) async {
    // 음소거 상태라도 로직상 재생은 시작하지만 볼륨 0으로 함
    if (_currentBgmPath == path && _bgmPlayer.state == PlayerState.playing) return;

    try {
      _currentBgmPath = path;
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      
      if (_isBgmMuted) {
        await _bgmPlayer.setVolume(0);
      } else {
        await _bgmPlayer.setVolume(0.5);
      }
      
      await _bgmPlayer.play(AssetSource(path.replaceFirst('assets/', ''))); 
    } catch (e) {
      print('Error playing BGM: $e');
    }
  }

  Future<void> stopBgm() async {
    await _bgmPlayer.stop();
    _currentBgmPath = null;
  }

  // 효과음 재생
  Future<void> playSfx(String type) async {
    if (_isSfxMuted) return;

    String path;
    switch (type) {
      case 'stroke_success':
        path = 'sounds/sfx/success_ding.mp3';
        break;
      case 'clean_complete':
        path = 'sounds/sfx/clean_whoosh.mp3';
        break;
      case 'theme_clear':
        path = 'sounds/sfx/theme_clear_fanfare.mp3';
        break;
      case 'unlock_success':
        path = 'sounds/sfx/unlock_success.mp3'; // 구매 성공
        break;
      default:
        return;
    }

    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.setVolume(_isSfxMuted ? 0 : 1.0);
      await _sfxPlayer.play(AssetSource(path));
    } catch (e) {
      print('Error playing SFX: $e');
    }
  }

  // 글자 음성 재생 (AssetSource 사용)
  Future<void> playVoice(String path) async {
    if (_isSfxMuted) return;
    
    try {
      // 음성 재생 시 기존 효과음을 멈출지 여부는 기획에 따라 다르지만, 
      // 보통은 겹치지 않게 멈추는 것이 깔끔함
      await _sfxPlayer.stop();
      await _sfxPlayer.setVolume(_isSfxMuted ? 0 : 1.0);
      
      // 'assets/' 접두사가 포함된 경우 제거 (audioplayers의 AssetSource는 assets/를 자동으로 인식하거나 명시적 경로 필요)
      // 현재 LessonModel은 'sounds/...' 형식임
      await _sfxPlayer.play(AssetSource(path));
    } catch (e) {
      print('Error playing Voice ($path): $e');
    }
  }
}

final soundManagerProvider = Provider<SoundManager>((ref) {
  return SoundManager(); // 싱글톤처럼 사용
});
