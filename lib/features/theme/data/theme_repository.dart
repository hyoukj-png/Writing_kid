import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:writing_kid/features/theme/domain/theme_model.dart';

part 'theme_repository.g.dart';

@riverpod
class ThemeRepository extends _$ThemeRepository {
  @override
  List<ThemeModel> build() {
    return _initialThemes;
  }

  // 오염도 감소 로직
  // 1회 성공 시 오염도 20% 감소 (5번 성공하면 완치)
  void decreasePollution(String id) {
    state = state.map((theme) {
      if (theme.id == id) {
        int newLevel = (theme.pollutionLevel - 20).clamp(0, 100);
        return theme.copyWith(pollutionLevel: newLevel);
      }
      return theme;
    }).toList();
  }

  // 데이터 변경 시 호출 (예: 해금 등)
  void unlockTheme(String id) {
    state = state.map((theme) {
      if (theme.id == id) {
        return theme.copyWith(isUnlocked: true);
      }
      return theme;
    }).toList();
  }

  // 초기 8개 테마 데이터 정의
  static const List<ThemeModel> _initialThemes = [
    // 1. 공룡 (Dino) - 무료
    ThemeModel(
      id: 'dino',
      name: '공룡 공원',
      description: '화산재와 뼈다귀로 오염된 공룡 공원을 구해주세요!',
      backgroundAsset: 'assets/images/themes/dino/bg_polluted.png',
      trashAssets: ['assets/images/themes/dino/trash_bone.png', 'assets/images/themes/dino/trash_ash.png'],
      iconAsset: 'assets/images/themes/dino/icon.png',
      bgmPath: 'assets/sound/bgm/theme_dino.mp3',
      primaryColor: Color(0xFF4CAF50), // Green
      isUnlocked: true, // 기본 무료
      price: 0,
      pollutionLevel: 100,
    ),
    // 2. 우주 (Space)
    ThemeModel(
      id: 'space',
      name: '우주 정거장',
      description: '부서진 인공위성이 가득한 우주를 빛나게 해주세요!',
      backgroundAsset: 'assets/images/themes/space/bg_polluted.png',
      trashAssets: ['assets/images/themes/space/trash_satellite.png', 'assets/images/themes/space/trash_rock.png'],
      iconAsset: 'assets/images/themes/space/icon.png',
      bgmPath: 'assets/sound/bgm/theme_space.mp3',
      primaryColor: Color(0xFF3F51B5), // Indigo
      isUnlocked: false,
      price: 500,
      pollutionLevel: 100,
    ),
    // 3. 바다 (Ocean)
    ThemeModel(
      id: 'ocean',
      name: '바닷속 세상',
      description: '플라스틱 쓰레기로 아파하는 바다 친구들을 도와주세요!',
      backgroundAsset: 'assets/images/themes/ocean/bg_polluted.png',
      trashAssets: ['assets/images/themes/ocean/trash_bottle.png', 'assets/images/themes/ocean/trash_net.png'],
      iconAsset: 'assets/images/themes/ocean/icon.png',
      bgmPath: 'assets/sound/bgm/theme_ocean.mp3',
      primaryColor: Color(0xFF2196F3), // Blue
      isUnlocked: false,
      price: 500,
      pollutionLevel: 100,
    ),
    // 4. 공주 (Princess)
    ThemeModel(
      id: 'princess',
      name: '공주님의 성',
      description: '먼지 쌓인 성을 청소하고 화려한 무도회를 열어봐요!',
      backgroundAsset: 'assets/images/themes/princess/bg_polluted.png',
      trashAssets: ['assets/images/themes/princess/trash_dust.png', 'assets/images/themes/princess/trash_web.png'],
      iconAsset: 'assets/images/themes/princess/icon.png',
      bgmPath: 'assets/sound/bgm/theme_princess.mp3',
      primaryColor: Color(0xFFE91E63), // Pink
      isUnlocked: false,
      price: 500,
      pollutionLevel: 100,
    ),
    // 5. 로봇 (Robot)
    ThemeModel(
      id: 'robot',
      name: '로봇 공장',
      description: '녹슨 고철들이 가득한 공장을 최첨단 도시로 만들어요!',
      backgroundAsset: 'assets/images/themes/robot/bg_polluted.png',
      trashAssets: ['assets/images/themes/robot/trash_metal.png', 'assets/images/themes/robot/trash_oil.png'],
      iconAsset: 'assets/images/themes/robot/icon.png',
      bgmPath: 'assets/sound/bgm/theme_robot.mp3',
      primaryColor: Color(0xFF607D8B), // Blue Grey
      isUnlocked: false,
      price: 500,
      pollutionLevel: 100,
    ),
    // 6. 숲 (Forest)
    ThemeModel(
      id: 'forest',
      name: '요정의 숲',
      description: '말라죽은 나무들을 살리고 요정 친구들을 불러봐요!',
      backgroundAsset: 'assets/images/themes/forest/bg_polluted.png',
      trashAssets: ['assets/images/themes/forest/trash_stump.png', 'assets/images/themes/forest/trash_leaf.png'],
      iconAsset: 'assets/images/themes/forest/icon.png',
      bgmPath: 'assets/sound/bgm/theme_forest.mp3',
      primaryColor: Color(0xFF8BC34A), // Light Green
      isUnlocked: false,
      price: 500,
      pollutionLevel: 100,
    ),
    // 7. 자동차 (Car)
    ThemeModel(
      id: 'car',
      name: '자동차 도시',
      description: '매연으로 가득 찬 도시를 맑은 전기차 도시로 바꿔요!',
      backgroundAsset: 'assets/images/themes/car/bg_polluted.png',
      trashAssets: ['assets/images/themes/car/trash_smog.png', 'assets/images/themes/car/trash_tire.png'],
      iconAsset: 'assets/images/themes/car/icon.png',
      bgmPath: 'assets/sound/bgm/theme_car.mp3',
      primaryColor: Color(0xFFF44336), // Red
      isUnlocked: false,
      price: 500,
      pollutionLevel: 100,
    ),
    // 8. 베이커리 (Bakery)
    ThemeModel(
      id: 'bakery',
      name: '달콤 빵집',
      description: '곰팡이 핀 빵들을 치우고 맛있는 케이크를 만들어요!',
      backgroundAsset: 'assets/images/themes/bakery/bg_polluted.png',
      trashAssets: ['assets/images/themes/bakery/trash_mold.png', 'assets/images/themes/bakery/trash_fly.png'],
      iconAsset: 'assets/images/themes/bakery/icon.png',
      bgmPath: 'assets/sound/bgm/theme_bakery.mp3',
      primaryColor: Color(0xFFFF9800), // Orange
      isUnlocked: false,
      price: 500,
      pollutionLevel: 100,
    ),
  ];
}
