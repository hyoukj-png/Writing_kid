import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:writing_kid/features/theme/data/theme_repository.dart';
import 'package:writing_kid/features/theme/domain/theme_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  List<ThemeModel> build() {
    // 1. ThemeRepository에서 초기 리스트를 가져와서 관리
    return ref.watch(themeRepositoryProvider);
  }

  // 테마 선택 시 현재 테마를 식별하는 ID를 저장 (선택 사항, 필요 시 추가)
  String? _selectedThemeId;

  ThemeModel? get currentTheme {
    if (_selectedThemeId == null) return state.firstOrNull;
    try {
      return state.firstWhere((t) => t.id == _selectedThemeId);
    } catch (_) {
      return state.firstOrNull;
    }
  }

  void selectTheme(String id) {
    _selectedThemeId = id;
    // UI 갱신을 위해 state 변경은 불필요할 수 있으나,
    // 만약 selectedThemeId 자체를 watch하고 싶다면 별도 Provider 분리가 필요.
    // 여기서는 간단히 로직만 수행.
  }

  void unlockTheme(String id) {
    // 2. Repository 호출을 통해 데이터 업데이트 -> 자동으로 watch 중인 state 갱신됨
    ref.read(themeRepositoryProvider.notifier).unlockTheme(id);
  }
}
