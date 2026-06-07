// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookDetailModel _$BookDetailModelFromJson(Map<String, dynamic> json) =>
    BookDetailModel(
      code: json['code'] as String?,
      msg: json['msg'] as String?,
      version: json['version'] as String?,
      timestamp: (json['timestamp'] as num?)?.toInt(),
      data: json['data'] == null
          ? null
          : BookMoreData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookDetailModelToJson(BookDetailModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'version': instance.version,
      'timestamp': instance.timestamp,
      'data': instance.data,
    };

BookMoreData _$BookMoreDataFromJson(Map<String, dynamic> json) => BookMoreData(
      dishCount: (json['dish_count'] as num?)?.toInt(),
      isNew: (json['is_new'] as num?)?.toInt(),
      sceneBackground: json['scene_background'] as String?,
      sceneDesc: json['scene_desc'] as String?,
      sceneId: (json['scene_id'] as num?)?.toInt(),
      sceneTitle: json['scene_title'] as String?,
      sceneType: (json['scene_type'] as num?)?.toInt(),
      thumbnail: json['thumbnail'] as String?,
      dishesList: (json['dishes_list'] as List<dynamic>?)
          ?.map((e) => BookDishesListModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      shareUrl: json['share_url'] as String?,
      relates: (json['relates'] as List<dynamic>?)
          ?.map((e) => BookRelates.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BookMoreDataToJson(BookMoreData instance) =>
    <String, dynamic>{
      'dish_count': instance.dishCount,
      'is_new': instance.isNew,
      'scene_background': instance.sceneBackground,
      'scene_desc': instance.sceneDesc,
      'scene_id': instance.sceneId,
      'scene_title': instance.sceneTitle,
      'scene_type': instance.sceneType,
      'thumbnail': instance.thumbnail,
      'dishes_list': instance.dishesList,
      'share_url': instance.shareUrl,
      'relates': instance.relates,
    };

BookDishesListModel _$BookDishesListModelFromJson(Map<String, dynamic> json) =>
    BookDishesListModel(
      image: json['image'] as String?,
      materialVideo: json['material_video'] as String?,
      processVideo: json['process_video'] as String?,
      dishesId: (json['dishes_id'] as num?)?.toInt(),
      dishesName: json['dishes_name'] as String?,
      dishesDesc: json['dishes_desc'] as String?,
      shareUrl: json['share_url'] as String?,
      like: (json['like'] as num?)?.toInt(),
      tagsInfo: (json['tags_info'] as List<dynamic>?)
          ?.map((e) => BookTagsInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BookDishesListModelToJson(
        BookDishesListModel instance) =>
    <String, dynamic>{
      'image': instance.image,
      'material_video': instance.materialVideo,
      'process_video': instance.processVideo,
      'dishes_id': instance.dishesId,
      'dishes_name': instance.dishesName,
      'dishes_desc': instance.dishesDesc,
      'share_url': instance.shareUrl,
      'like': instance.like,
      'tags_info': instance.tagsInfo,
    };

BookTagsInfo _$BookTagsInfoFromJson(Map<String, dynamic> json) => BookTagsInfo(
      id: (json['id'] as num?)?.toInt(),
      text: json['text'] as String?,
      type: (json['type'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BookTagsInfoToJson(BookTagsInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'type': instance.type,
    };

BookRelates _$BookRelatesFromJson(Map<String, dynamic> json) => BookRelates(
      sceneBackground: json['scene_background'] as String?,
      sceneId: (json['scene_id'] as num?)?.toInt(),
      sceneTitle: json['scene_title'] as String?,
      dishesCount: (json['dishes_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BookRelatesToJson(BookRelates instance) =>
    <String, dynamic>{
      'scene_background': instance.sceneBackground,
      'scene_id': instance.sceneId,
      'scene_title': instance.sceneTitle,
      'dishes_count': instance.dishesCount,
    };
