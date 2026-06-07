// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cook_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CookHomeListModel _$CookHomeListModelFromJson(Map<String, dynamic> json) =>
    CookHomeListModel(
      id: json['id'] as String?,
      text: json['text'] as String?,
      image: json['image'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CookListDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CookHomeListModelToJson(CookHomeListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'image': instance.image,
      'data': instance.data,
    };

CookListDataModel _$CookListDataModelFromJson(Map<String, dynamic> json) =>
    CookListDataModel(
      id: json['id'] as String?,
      text: json['text'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$CookListDataModelToJson(CookListDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'image': instance.image,
    };
