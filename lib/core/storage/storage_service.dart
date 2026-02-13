import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 앱 시작 시 SharedPreferences 인스턴스를 주입받음
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // === 키 값 ===
  static const String keyUserCredits = 'user_credits';
  static const String keyUnlockedThemes = 'unlocked_themes';
  static const String keyTutorialShown = 'tutorial_shown';

  // === 유저 크레딧 ===
  int loadUserCredits() {
    return _prefs.getInt(keyUserCredits) ?? 0;
  }

  Future<void> saveUserCredits(int credits) async {
    await _prefs.setInt(keyUserCredits, credits);
  }

  // === 해금된 테마 ===
  List<String> loadUnlockedThemes() {
    return _prefs.getStringList(keyUnlockedThemes) ?? [];
  }

  Future<void> saveUnlockedThemes(List<String> themeIds) async {
    await _prefs.setStringList(keyUnlockedThemes, themeIds);
  }

  // === 튜토리얼 ===
  bool loadTutorialShown() {
    return _prefs.getBool(keyTutorialShown) ?? false;
  }

  Future<void> saveTutorialShown(bool shown) async {
    await _prefs.setBool(keyTutorialShown, shown);
  }
}

// StorageService Provider
final storageServiceProvider = Provider<StorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return StorageService(prefs);
});
