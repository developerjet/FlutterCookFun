// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchDataModel _$SearchDataModelFromJson(Map<String, dynamic> json) =>
    SearchDataModel(
      top: json['top'] == null
          ? null
          : SearchTop.fromJson(json['top'] as Map<String, dynamic>),
      second: json['second'] == null
          ? null
          : SearchSecond.fromJson(json['second'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SearchDataListModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchDataModelToJson(SearchDataModel instance) =>
    <String, dynamic>{
      'top': instance.top,
      'second': instance.second,
      'data': instance.data,
    };

SearchTop _$SearchTopFromJson(Map<String, dynamic> json) => SearchTop(
      count: (json['count'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SearchTopData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchTopToJson(SearchTop instance) => <String, dynamic>{
      'count': instance.count,
      'data': instance.data,
    };

SearchTopData _$SearchTopDataFromJson(Map<String, dynamic> json) =>
    SearchTopData(
      id: json['id'] as String?,
      title: json['title'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$SearchTopDataToJson(SearchTopData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image': instance.image,
    };

SearchSecond _$SearchSecondFromJson(Map<String, dynamic> json) => SearchSecond(
      total: json['total'] as String?,
      courseName: json['course_name'] as String?,
    );

Map<String, dynamic> _$SearchSecondToJson(SearchSecond instance) =>
    <String, dynamic>{
      'total': instance.total,
      'course_name': instance.courseName,
    };

SearchDataListModel _$SearchDataListModelFromJson(Map<String, dynamic> json) =>
    SearchDataListModel(
      id: json['id'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$SearchDataListModelToJson(
        SearchDataListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
    };
