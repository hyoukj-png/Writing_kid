import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:writing_kid/core/storage/storage_service.dart';

// 유저 정보 상태 (현재는 에코 리프만 관리)
class UserState {
  final int credits;
  final bool tutorialShown;

  const UserState({
    required this.credits,
    required this.tutorialShown,
  });

  UserState copyWith({int? credits, bool? tutorialShown}) {
    return UserState(
      credits: credits ?? this.credits,
      tutorialShown: tutorialShown ?? this.tutorialShown,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  final StorageService storageService;

  UserNotifier(this.storageService)
      : super(UserState(
          credits: storageService.loadUserCredits(),
          tutorialShown: storageService.loadTutorialShown(),
        ));

  Future<void> addCredits(int amount) async {
    final newCredits = state.credits + amount;
    state = state.copyWith(credits: newCredits);
    await storageService.saveUserCredits(newCredits);
  }

  Future<void> consumeCredits(int amount) async {
    if (state.credits < amount) return;
    final newCredits = state.credits - amount;
    state = state.copyWith(credits: newCredits);
    await storageService.saveUserCredits(newCredits);
  }

  Future<void> setTutorialShown() async {
    state = state.copyWith(tutorialShown: true);
    await storageService.saveTutorialShown(true);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return UserNotifier(storageService);
});
