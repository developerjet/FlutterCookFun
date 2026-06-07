import 'package:json_annotation/json_annotation.dart';

part 'home_list_model.g.dart';

/// 首页数据模型
@JsonSerializable()
class HomeDataModel {
  final List<HomeFoodListData> data;

  HomeDataModel({this.data = const []});

  factory HomeDataModel.fromJson(Map<String, dynamic> json) =>
      _$HomeDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeDataModelToJson(this);
}

/// 首页食材分类数据
@JsonSerializable()
class HomeFoodListData {
  final String? image;
  final String? id;
  final String? text;
  final int? type;

  @JsonKey(name: 'order_no')
  final int? orderNo;

  @JsonKey(name: 'tag_isselfdefine')
  final int? tagIsselfdefine;

  final List<FoodSubData>? data;

  HomeFoodListData({
    this.image,
    this.id,
    this.text,
    this.type,
    this.orderNo,
    this.tagIsselfdefine,
    this.data,
  });

  factory HomeFoodListData.fromJson(Map<String, dynamic> json) =>
      _$HomeFoodListDataFromJson(json);

  Map<String, dynamic> toJson() => _$HomeFoodListDataToJson(this);
}

/// 食材子分类数据
@JsonSerializable()
class FoodSubData {
  final String? id;
  final String? text;

  @JsonKey(name: 'tag_isselfdefine')
  final int? tagIsselfdefine;

  final int? type;

  @JsonKey(name: 'order_no')
  final int? orderNo;

  final String? image;

  FoodSubData({
    this.id,
    this.text,
    this.tagIsselfdefine,
    this.type,
    this.orderNo,
    this.image,
  });

  factory FoodSubData.fromJson(Map<String, dynamic> json) =>
      _$FoodSubDataFromJson(json);

  Map<String, dynamic> toJson() => _$FoodSubDataToJson(this);
}
