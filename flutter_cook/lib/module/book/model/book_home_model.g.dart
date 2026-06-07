// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_home_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookListModel _$BookListModelFromJson(Map<String, dynamic> json) =>
    BookListModel(
      dishCount: (json['dish_count'] as num?)?.toInt(),
      isNew: (json['is_new'] as num?)?.toInt(),
      sceneBackground: json['scene_background'] as String?,
      sceneDesc: json['scene_desc'] as String?,
      sceneId: (json['scene_id'] as num?)?.toInt(),
      sceneTitle: json['scene_title'] as String?,
      sceneType: (json['scene_type'] as num?)?.toInt(),
      thumbnail: json['thumbnail'] as String?,
    );

Map<String, dynamic> _$BookListModelToJson(BookListModel instance) =>
    <String, dynamic>{
      'dish_count': instance.dishCount,
      'is_new': instance.isNew,
      'scene_background': instance.sceneBackground,
      'scene_desc': instance.sceneDesc,
      'scene_id': instance.sceneId,
      'scene_title': instance.sceneTitle,
      'scene_type': instance.sceneType,
      'thumbnail': instance.thumbnail,
    };
