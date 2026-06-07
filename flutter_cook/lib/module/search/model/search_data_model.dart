import 'package:json_annotation/json_annotation.dart';

part 'search_data_model.g.dart';

@JsonSerializable()
class SearchDataModel {
  final SearchTop? top;
  final SearchSecond? second;
  final List<SearchDataListModel>? data;

  const SearchDataModel({
    this.top,
    this.second,
    this.data,
  });

  factory SearchDataModel.fromJson(Map<String, dynamic> json) =>
      _$SearchDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchDataModelToJson(this);
}

@JsonSerializable()
class SearchTop {
  final int? count;
  final List<SearchTopData>? data;

  const SearchTop({
    this.count,
    this.data,
  });

  factory SearchTop.fromJson(Map<String, dynamic> json) =>
      _$SearchTopFromJson(json);

  Map<String, dynamic> toJson() => _$SearchTopToJson(this);
}

@JsonSerializable()
class SearchTopData {
  final String? id;
  final String? title;
  final String? image;

  const SearchTopData({
    this.id,
    this.title,
    this.image,
  });

  factory SearchTopData.fromJson(Map<String, dynamic> json) =>
      _$SearchTopDataFromJson(json);

  Map<String, dynamic> toJson() => _$SearchTopDataToJson(this);
}

@JsonSerializable()
class SearchSecond {
  final String? total;
  @JsonKey(name: 'course_name')
  final String? courseName;

  const SearchSecond({
    this.total,
    this.courseName,
  });

  factory SearchSecond.fromJson(Map<String, dynamic> json) =>
      _$SearchSecondFromJson(json);

  Map<String, dynamic> toJson() => _$SearchSecondToJson(this);
}

@JsonSerializable()
class SearchDataListModel {
  final String? id;
  final String? text;

  const SearchDataListModel({
    this.id,
    this.text,
  });

  factory SearchDataListModel.fromJson(Map<String, dynamic> json) =>
      _$SearchDataListModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchDataListModelToJson(this);
}