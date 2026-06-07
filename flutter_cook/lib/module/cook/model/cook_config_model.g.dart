// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cook_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CookConfigListModel _$CookConfigListModelFromJson(Map<String, dynamic> json) =>
    CookConfigListModel(
      dishesId: json['dishes_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      video: json['video'] as String?,
      video1: json['video1'] as String?,
      image: json['image'] as String?,
      hardLevel: json['hard_level'] as String?,
      play: json['play'] as String?,
      cookingTime: json['cooking_time'] as String?,
      collectCount: json['collect_count'] as String?,
      taste: json['taste'] as String?,
      createDate: (json['create_date'] as num?)?.toInt(),
      content: json['content'] as String?,
      tagsInfo: (json['tags_info'] as List<dynamic>?)
          ?.map((e) => CookTagsInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CookConfigListModelToJson(
        CookConfigListModel instance) =>
    <String, dynamic>{
      'dishes_id': instance.dishesId,
      'title': instance.title,
      'description': instance.description,
      'video': instance.video,
      'video1': instance.video1,
      'image': instance.image,
      'hard_level': instance.hardLevel,
      'play': instance.play,
      'cooking_time': instance.cookingTime,
      'collect_count': instance.collectCount,
      'taste': instance.taste,
      'create_date': instance.createDate,
      'content': instance.content,
      'tags_info': instance.tagsInfo,
    };

CookTagsInfo _$CookTagsInfoFromJson(Map<String, dynamic> json) => CookTagsInfo(
      id: (json['id'] as num?)?.toInt(),
      text: json['text'] as String?,
      type: (json['type'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CookTagsInfoToJson(CookTagsInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'type': instance.type,
    };
