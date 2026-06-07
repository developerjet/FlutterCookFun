// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeDataModel _$HomeDataModelFromJson(Map<String, dynamic> json) =>
    HomeDataModel(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => HomeFoodListData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$HomeDataModelToJson(HomeDataModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

HomeFoodListData _$HomeFoodListDataFromJson(Map<String, dynamic> json) =>
    HomeFoodListData(
      image: json['image'] as String?,
      id: json['id'] as String?,
      text: json['text'] as String?,
      type: (json['type'] as num?)?.toInt(),
      orderNo: (json['order_no'] as num?)?.toInt(),
      tagIsselfdefine: (json['tag_isselfdefine'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => FoodSubData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeFoodListDataToJson(HomeFoodListData instance) =>
    <String, dynamic>{
      'image': instance.image,
      'id': instance.id,
      'text': instance.text,
      'type': instance.type,
      'order_no': instance.orderNo,
      'tag_isselfdefine': instance.tagIsselfdefine,
      'data': instance.data,
    };

FoodSubData _$FoodSubDataFromJson(Map<String, dynamic> json) => FoodSubData(
      id: json['id'] as String?,
      text: json['text'] as String?,
      tagIsselfdefine: (json['tag_isselfdefine'] as num?)?.toInt(),
      type: (json['type'] as num?)?.toInt(),
      orderNo: (json['order_no'] as num?)?.toInt(),
      image: json['image'] as String?,
    );

Map<String, dynamic> _$FoodSubDataToJson(FoodSubData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'tag_isselfdefine': instance.tagIsselfdefine,
      'type': instance.type,
      'order_no': instance.orderNo,
      'image': instance.image,
    };
