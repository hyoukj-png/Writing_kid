// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ThemeModelImpl _$$ThemeModelImplFromJson(Map<String, dynamic> json) =>
    _$ThemeModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      backgroundAsset: json['backgroundAsset'] as String,
      trashAssets: (json['trashAssets'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      iconAsset: json['iconAsset'] as String,
      bgmPath: json['bgmPath'] as String,
      primaryColor: const ColorConverter()
          .fromJson((json['primaryColor'] as num).toInt()),
      isUnlocked: json['isUnlocked'] as bool,
      price: (json['price'] as num).toInt(),
      pollutionLevel: (json['pollutionLevel'] as num).toInt(),
    );

Map<String, dynamic> _$$ThemeModelImplToJson(_$ThemeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'backgroundAsset': instance.backgroundAsset,
      'trashAssets': instance.trashAssets,
      'iconAsset': instance.iconAsset,
      'bgmPath': instance.bgmPath,
      'primaryColor': const ColorConverter().toJson(instance.primaryColor),
      'isUnlocked': instance.isUnlocked,
      'price': instance.price,
      'pollutionLevel': instance.pollutionLevel,
    };
