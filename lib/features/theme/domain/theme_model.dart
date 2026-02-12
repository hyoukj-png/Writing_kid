import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_model.freezed.dart';
part 'theme_model.g.dart';

// Custom Type Converter required for Color JSON serialization
class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color object) => object.value;
}

@freezed
class ThemeModel with _$ThemeModel {
  const factory ThemeModel({
    required String id,
    required String name,
    required String description,
    required String backgroundAsset,
    required List<String> trashAssets,
    required String iconAsset,
    required String bgmPath,
    @ColorConverter() required Color primaryColor,
    required bool isUnlocked,
    required int price,
    required int pollutionLevel, // 0~100 (100 = Polluted, 0 = Clean)
  }) = _ThemeModel;

  factory ThemeModel.fromJson(Map<String, dynamic> json) =>
      _$ThemeModelFromJson(json);
}
